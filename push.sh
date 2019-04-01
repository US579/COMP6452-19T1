#!/bin/bash
if $1
then
    git add $1
fi
git add .
git commit -m 'commit'
git push
