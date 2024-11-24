function load_env {
    export $(cat .env | sed 's/#.*//g' | grep -v "WELCOME_FOOTER" | grep -v "WELCOME_MESSAGE" | xargs)
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

function ensure_bbbhtml5yml {
    if [ ! -f conf/bbb-html5.yml ]; then

        cat << EOF > conf/bbb-html5.yml
# this file equals the /etc/bigbluebutton/bbb-html5.yml file referenced in the docs
public:
  app:
    appName: BigBlueButton HTML5 Client (docker)
EOF
    fi
}