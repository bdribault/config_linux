echo -n "git user.name : "
read NAME

echo -n "git user.email : "
read EMAIL

echo -n "graphical env ? [y/n] : "
read GRAPHICAL

echo -n "docker engine ? [y/n] : "
read DOCKER

DEFAULT_PACKET_LIST="git vim tree"
GRAPHIC_PACKET_LIST="meld"

PROJECT_PATH=https://raw.githubusercontent.com/bdribault/config_linux/master

sudo apt update

# Install default packets
sudo apt install -y ${DEFAULT_PACKET_LIST}

# git configuration
if [[ ! -z ${NAME} ]]
then
    git config --global user.name "${NAME}"
fi
if [[ ! -z ${EMAIL} ]]
then
    git config --global user.email "${EMAIL}"
fi

git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
git config --global alias.st "status"
git config --global alias.co "checkout"
git config --global alias.br "branch"
git config --global alias.gone "! git fetch -p && git for-each-ref --format '%(refname:short) %(upstream:track)' | awk '\$2 == \"[gone]\" {print \$1}' | xargs -r git branch -D"

# Install graphical packets if needed
if [[ "${GRAPHICAL}" == "y" ]]
then
    sudo apt install -y ${GRAPHIC_PACKET_LIST}
fi

# Install docker if needed
if [[ "${DOCKER}" == "y" ]]
then
    # Add Docker's official GPG key:
    sudo apt install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update

    # Install docker
    sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    # Check install is ok
    sudo docker run hello-world

    # Manage Docker as a non-root user
    sudo groupadd docker
    sudo usermod -aG docker $USER

    # Install docker compose helpers
    mkdir $HOME/bin
    wget -P $HOME/bin $PROJECT_PATH/docker_compose_alias/dcfr
    wget -P $HOME/bin $PROJECT_PATH/docker_compose_alias/dcl
    wget -P $HOME/bin $PROJECT_PATH/docker_compose_alias/dcr
    sudo chmod +x $HOME/bin/dc*
    echo 'PATH="$HOME/bin:$PATH"' >> ~/.bashrc

    echo "You may have to logout/login or restart your VM for group membership to be re-evaluated"
fi
