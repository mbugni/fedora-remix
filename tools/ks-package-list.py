#!/usr/bin/python3
import copy
import sys
import argparse

import pykickstart
import pykickstart.parser
import pykickstart.version

import dnf
import dnf.conf
import dnf.transaction

PKG_FORMAT = "{name}-{version}-{release}.{arch}"

# Command line parsing
argparser = argparse.ArgumentParser(description='List kickstart package dependencies.')
argparser.add_argument('kickstart_file', metavar='KICKSTART', help='The kickstart file to parse')
version_opt = argparser.add_mutually_exclusive_group()
version_opt.add_argument('--releasever', metavar='RELEASEVER', help='release version', type=int, required=False)
version_opt.add_argument('--stream', metavar='STREAM', help='stream version', type=int, required=False)
argparser.add_argument('--format', metavar='FORMAT', help='package format (default is '+ PKG_FORMAT +')', required=False)
argparser.add_argument('--verbose', help='print additional info to stderr', action='store_true')
args = argparser.parse_args()

# Kickstart parsing
ksparser = pykickstart.parser.KickstartParser(pykickstart.version.makeVersion())
ksparser.readKickstart(args.kickstart_file)

# Base object for dnf operations: https://dnf.readthedocs.io/en/latest/api.html
dnf_base = dnf.Base()

# Load variables substitutions from base.conf.varsdir, default value for varsdir is ("/etc/yum/vars/", "/etc/dnf/vars/")
# the varsdir is searched under the installroot location. So if the varsdir is located on the host (outside the installroot)
# then you have to use "/" as installroot in this call:
#  dnf_base.conf.substitutions.update_from_etc(installroot=dnf_base.conf.installroot, varsdir=dnf_base.conf.varsdir)

# Set release version, if any
if args.releasever:
    if args.verbose:
        print(f'# Setting release version to {args.releasever}', file=sys.stderr)
    dnf_base.conf.releasever = args.releasever
# Set stream version, if any
elif args.stream:
    if args.verbose:
        print(f'# Setting stream version to {args.stream}', file=sys.stderr)
    dnf_base.conf.releasever = args.stream
    # Example of setting substitutions programmatically: the CentOS Stream version
    dnf_base.conf.substitutions['stream'] = f"{args.stream}-stream"

if args.verbose:
    print(f'# Exclude weak dependencies: {ksparser.handler.packages.excludeWeakdeps}', file=sys.stderr)
dnf_base.conf.install_weak_deps = not ksparser.handler.packages.excludeWeakdeps

# Create parser for kickstart 'repo' command
repoparser = argparse.ArgumentParser(prog='repo', description='Kickstart repo command')
repoparser.add_argument('--name', required=True)
repoparser.add_argument('--excludepkgs', required=False)
repourl_opt = repoparser.add_mutually_exclusive_group()
repourl_opt.add_argument('--baseurl', required=False)
repourl_opt.add_argument('--metalink', required=False)
repourl_opt.add_argument('--mirrorlist', required=False)

# Parse repo list from kickstart file
repolist = ksparser.handler.commands['repo'].dataList()
if repolist:
    if args.verbose:
        print(f'# Processing {len(repolist)} repositories using substitutions {dnf_base.conf.substitutions}:', file=sys.stderr)
    for repocmd in repolist:
        repo_conf = copy.copy(dnf_base.conf)
        if args.verbose:
            print(f"#  {repocmd}".strip(), file=sys.stderr)
        repoargs = repoparser.parse_args(args=f"{repocmd}".split()[1:])
        repourls = {}
        if repoargs.baseurl:
            repourls['baseurl'] = repoargs.baseurl
        if repoargs.metalink:
            repourls['metalink'] = repoargs.metalink
        if repoargs.mirrorlist:
            repourls['mirrorlist'] = repoargs.mirrorlist
        if repoargs.excludepkgs:
            repo_conf.exclude_pkgs(repoargs.excludepkgs)
        # Add repo to current configuration
        dnf_base.repos.add_new_repo(repoid=repoargs.name.strip('"'), conf=repo_conf, **repourls)
elif args.verbose:
        print('# No repository command in kickstart file', file=sys.stderr)

# Dump config
# print(f"# Config: {dnf_base.conf.dump()}", file=sys.stderr)

# Retrieve metadata information about all known packages
dnf_base.fill_sack(load_system_repo=False)

# Retrieve metadata information about all known groups
dnf_base.read_comps()

# Parse modules (currently disabled)
# modulelist = ksparser.handler.commands['module'].dataList()
# if modulelist:
#     if args.verbose:
#         print(f'# Processing {len(modulelist)} modules:', file=sys.stderr)
#     moduleparser = argparse.ArgumentParser(prog='module', description='Kickstart module command')
#     moduleparser.add_argument('--name', required=True)
#     moduleparser.add_argument('--stream', required=True)
#     module_base = dnf.module.module_base.ModuleBase(dnf_base)
#     enabled_modules = []
#     for module in modulelist:
#         moduleargs = moduleparser.parse_args(args=f"{module}".split()[1:])
#         modulever = f"{moduleargs.name}:{moduleargs.stream}"
#         print(f"# Enabling module: {modulever}", file=sys.stderr)
#         module_packages, nsvcap = module_base.get_modules(modulever)

#         print("Parsed NSVCAP:")
#         print("name:", nsvcap.name)
#         print("stream:", nsvcap.stream)
#         print("version:", nsvcap.version)
#         print("context:", nsvcap.context)
#         print("arch:", nsvcap.arch)
#         print("profile:", nsvcap.profile)

#         print("Matching modules:")
#         for mpkg in module_packages:
#             print(mpkg.getFullIdentifier())

#         enabled_modules.append(moduleargs.name)
#     module_base.enable(enabled_modules)

# Resolves package list from name
def resolvePackage(pkg_name):
    return dnf_base.sack.query().filter(name__glob=pkg_name, latest_per_arch=True)
    
# Process kickstart required groups
for group in ksparser.handler.packages.groupList:
    resolved_group = dnf_base.comps.group_by_pattern(group.name)
    if resolved_group:
        # Add group to install transaction
        found = dnf_base.group_install(resolved_group.id, dnf_base.conf.group_package_types)
        if args.verbose:
            print(f"# Including {found} packages from group {group}", file=sys.stderr)
    else:
        print(f"# Warning: cannot find required group {group.name}", file=sys.stderr)

# Process kickstart excluded packages
excluded_list = ksparser.handler.packages.excludedList
if excluded_list:
    if args.verbose:
        print(f"# Processing {len(excluded_list)} explicitly excluded packages: {excluded_list}", file=sys.stderr)
    for pkg in excluded_list:
        resolved = resolvePackage(pkg)
        if not resolved and args.verbose:
            print(f"# Warning: cannot find excluded package {pkg}", file=sys.stderr)

# Process kickstart required packages
included_list = ksparser.handler.packages.packageList
for pkg in included_list:
    resolved = resolvePackage(pkg)
    if not resolved:
        print(f"# Warning: cannot find required package {pkg}", file=sys.stderr)
        
# Resolve install dependencies
dnf_base.install_specs(included_list, exclude=excluded_list)
dnf_base.resolve()

# Print formatted results
pkg_format = PKG_FORMAT
if args.format:
    pkg_format = args.format
for pkg in sorted(dnf_base.transaction.install_set):
    print(pkg_format.format(name=pkg.name,epoch=pkg.epoch,version=pkg.version,release=pkg.release,arch=pkg.arch))
