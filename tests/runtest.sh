#!/bin/bash

echo "setup..."
git init
git add test.sh my_script lib.py
git status -s
echo "Running..."
echo "=============TEST1==============="
../gistlint.sh git
TEST1=$?
echo "=============TEST2==============="
sed -i -- 's/tgr =/tgr=/g' lib.py
../gistlint.sh git
TEST2=$?
echo "=============TEST3==============="
sed -i -- 's/tgr=/tgr =/g' lib.py
../gistlint.sh git
TEST3=$?
echo "=============TEST4==============="
../gistlint.sh all
TEST4=$?
echo "Clenaing up."
rm -rf --preserve-root .git/
echo "=============RESULTS==============="
echo "1: $TEST1"
echo "2: $TEST2"
echo "3: $TEST3"
echo "4: $TEST4"
