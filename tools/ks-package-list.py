#!/usr/bin/python3
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
argparser.add_argument('--releasever', metavar='RELEASEVER', help='release version', type=int, required=False)
argparser.add_argument('--format', metavar='FORMAT', help='package format (default is '+ PKG_FORMAT +')', required=False)
argparser.add_argument('--verbose', help='print additional info to stderr', action='store_true')
args = argparser.parse_args()

# Kickstart parsing
ksparser = pykickstart.parser.KickstartParser(pykickstart.version.makeVersion())
ksparser.readKickstart(args.kickstart_file)

# Base object for dnf operations: https://dnf.readthedocs.io/en/latest/api.html
dnf_base = dnf.Base()

# Set release version if any
if args.releasever:
    if args.verbose:
        print(f'# Setting release version to {args.releasever}', file=sys.stderr)
    dnf_base.conf.releasever = args.releasever

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
        print(f'# Processing {len(repolist)} repositories', file=sys.stderr)
    for repocmd in ksparser.handler.commands['repo'].dataList():
        repo_conf = dnf.Base().conf
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
