function load_env {
    FILE=.env
    if [ "$BBB_DOCKER_DEV" = "1" ]; then
        FILE=dev.env
    else
        FILE=.env
    fi

    if [ -f $FILE ]
    then
        export $(cat $FILE | sed 's/#.*//g' | grep -v "WELCOME_FOOTER" | grep -v "WELCOME_MESSAGE" | grep -v "CLIENT_TITLE" | xargs)
    fi
}

function ensure_submodules {
    MISSING_SUBMODULES=$(git submodule status | grep -v ' (' |  awk '{print $2}' || /bin/true)
    echo 
    if [ ! -z "$MISSING_SUBMODULES" ]; then
        echo "ERROR: following submodules are not checked out. we can't continue here"
        git submodule status | grep -v ' (' |  awk '{print " -", $2}'
        echo ""
        echo "if you really want to build images by yourself (not required for a normal production setup), use following command to check out all the submodules and try again"
        echo "  git submodule update --init"
        exit 1
    fi
    
}

