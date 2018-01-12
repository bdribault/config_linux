echo "user.name pour git ?"
read NAME
echo "user.email pour git ?"
read EMAIL

sudo apt-get install -y git vim tree

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
