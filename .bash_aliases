# Search history
alias gh='history|grep'

# List dirs sort by last modified
alias ltr='ls -ltr'

# quickly get away from current directory
alias ..='cd ..'

# Create parent directories on-demand
alias mkdir='mkdir -pv'

# Safety nets
# do not delete / or prompt if deleting more than 3 files at a time #
alias rm='rm -I --preserve-root'

# GIT
alias gt='git log --oneline --decorate --graph --all --date-order --pretty'
