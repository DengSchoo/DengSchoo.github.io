#!/bin/bash
git add . > ehco
git commit -m "$1" > echo
git push > echo

mkdocs gh-deploy > echo