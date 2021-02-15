echo -n "git user.name : "
read NAME

echo -n "git user.email : "
read EMAIL

echo -n "graphical env ? [y/n] : "
read GRAPHICAL

DEFAULT_PACKET_LIST="git vim tree"
GRAPHIC_PACKET_LIST="meld"

echo "installing default packets"

sudo apt-get install -y ${DEFAULT_PACKET_LIST}
if [[ "${GRAPHICAL}" == "y" ]]
then
    echo "installing graphical packets"
    sudo apt-get install -y ${GRAPHIC_PACKET_LIST}
fi

if [[ ! -z ${NAME} ]]
then
    echo "setting git user.name to ${NAME}"
    git config --global user.name "${NAME}"
fi
if [[ ! -z ${EMAIL} ]]
then
    echo "setting git user.email to ${EMAIL}"
    git config --global user.email "${EMAIL}"
fi

git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
git config --global alias.st "status"
git config --global alias.co "checkout"
git config --global alias.br "branch"
git config --global alias.gone "! git fetch -p && git for-each-ref --format '%(refname:short) %(upstream:track)' | awk '\$2 == \"[gone]\" {print \$1}' | xargs -r git branch -D"
