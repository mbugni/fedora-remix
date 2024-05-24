## Colored prompt
if [ -n "$PS1" ]; then
	if [[ "$TERM" == *256color ]]; then
		if [ $(id -u) -eq 0 ]; then
			PS1='\[\e[91m\]\u@\h \[\e[93m\]\W\[\e[0m\]\$ '
		else
			PS1='\[\e[94m\]\u@\h \[\e[93m\]\W\[\e[0m\]\$ '
		fi
	else
		if [ $(id -u) -eq 0 ]; then
			PS1='\[\e[31m\]\u@\h \[\e[33m\]\W\[\e[0m\]\$ '
		else
			PS1='\[\e[34m\]\u@\h \[\e[33m\]\W\[\e[0m\]\$ '
		fi
	fi
fi 
