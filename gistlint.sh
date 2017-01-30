#!/bin/bash

function print_usage() {
    echo "USAGE: gistlint.sh [mode]"
    echo "mode is one of:"
    echo -e "\tgit : look for files tracked in git status"
    echo -e "\tall : look for all python files in current directory"
    return 1
}


function lint_item() {
    pyfile=$(echo "$1")
    LOUT=$(python3-pylint $pyfile 2> /dev/null)
    SCORE=$(echo "$LOUT" | grep "Your code has been rated at" | awk '{print $7}')
    WARNINGS=$(echo "$LOUT" | grep --color=always "^.*[C,R,W,E,F].*\:[\ ][0-9]")
    echo "$pyfile : $SCORE"
    SLINE=$(echo "$LOUT" | grep "Your code has been rated at" | grep -o "\-[0-9]*\.[0-9][0-9])")
    RC=0
    if [[ -n $SLINE ]]; then
        echo "======================================================================="
        echo "Pylint score for $pyfile has gone down: ($SLINE"
        echo -e "$WARNINGS"
        RC=1
        echo "======================================================================="
    fi

    return $RC
}

function is_python() {
    FILE=$(echo "$1")

    if [[ -n $(echo $FILE | grep '.*\.py$') ]]; then
        return 0
    fi
    if [[ -n $(grep "env python.*" $FILE) ]]; then
        return 0
    fi
    return 1
}

function lint_git() {
    ITEMS=""
    STATUS=$(git status -s)
    OLDIFS=$IFS
    IFS=$'\n'
    is_good=0
    for item in $STATUS; do
        STATUS=$(echo $item | awk '{print $1}')
        if [ $STATUS != 'D' ] &&     [ $STATUS != '??' ]; then #skip deleted items, untracked
            fname=$(echo $item | awk '{print $2}')
            if $(is_python $fname) ; then
                lint_item $fname
                if [ $? -eq 1 ]; then
                    is_good=1
                fi
            fi
        fi
    done
    IFS=$OLDIFS

    exit $is_good

}

function lint_all()
{
    FLIST=$(find . -name "*.py")
    SLIST=$(grep -rnlw "^#!/usr/bin/env python.*" .)
    TLIST=$(echo "$FLIST"; echo "$SLIST")
    TLIST=$(echo "$TLIST" | sort -u)
    RC=0
    for pyfile in $TLIST; do
        lint_item $pyfile
        if [ $? -eq 1 ]; then
            RC=1
        fi
    done

    return $RC
}

if [[ $(pwd | grep -o '\.git.*') ]]; then
    #we're in a .git directory
    CD_COUNT=$(pwd | grep -o "/\.git.*" | grep -o "/" | wc -l)
    base=""
    for (( i = 0; i < $CD_COUNT; i++ )); do
        base=$(echo "$base../")
    done

    cd $base
fi
#script start
case "$1" in
    "git" )
    lint_git
        ;;
    "all" )
    lint_all
        ;;
    * )
    print_usage
        ;;
esac


exit $RC
