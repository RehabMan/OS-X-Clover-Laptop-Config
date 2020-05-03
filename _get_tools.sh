#!/bin/bash
#set -x

# get copy of tools if not present
if [[ ! -d ./_tools && -z "$(git -C ./_tools/ rev-parse --show-superproject-working-tree)" ]]; then
    git submodule add -f --name hack-tools https://github.com/RehabMan/hack-tools.git ./_tools
    git submodule update --init ./_tools
fi
# update tools to latest
if [[ -d ./_tools && -n "$(git -C ./_tools/ rev-parse --show-superproject-working-tree)" ]]; then
    git -C ./_tools/ pull
fi
# remove old tools copy (that was in tools instead of _tools)
rm -Rf tools

#eof
