#!/bin/bash
#set -x

# get copy of tools if not present
if [[ ! -d ./_tools ]]; then
    git clone https://github.com/RehabMan/hack-tools.git _tools
fi
# update tools to latest
if [[ -e ./_tools/.git ]]; then
    cd ./_tools && git pull
    cd ..
fi
# remove old tools copy (that was in tools instead of _tools)
rm -Rf tools

#eof
