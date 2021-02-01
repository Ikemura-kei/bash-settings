#!/bin/bash

sudo apt install build-essential

sudo apt install clang-format

GREEN='\033[0;32m'
NC='\033[0m'

#===============#
#===== git =====#
#===============#
sudo apt install git
if [ -e ~/.ssh/id_rsa.pub ]; then
  echo "ssh key found, please add it to github"
  echo
  echo -n "please configure your user name: "
  read NAME
  echo
  echo -n "please configure your email: "
  read EMAIL
  git config --global user.name $NAME
  git config --global user.email $EMAIL
else
  echo "ssh key not found, generating one ..."
  ssh-keygen -t rsa
fi

printf "\n${GREEN}=>fetching vim configurations\n${NC}"
git clone git@github.com:Ikemura-kei/vim-settings.git

#================#
#===== snap =====#
#================#
printf "\n${GREEN}=>checking snap installation${NC}\n"
if ! command -v snap &> /dev/null
then 
  echo "snap not installed, installing with apt"
  sudo apt install snapd
else 
  echo "snap is already installed, info: " && snap --version
fi

#================#
#===== ccls =====#
#================#
printf "\n${GREEN}=>installing ccls language server\n${NC}"
sudo snap install ccls --classic

#======================#
#===== python 3.8 =====#
#======================#
printf "\n${GREEN}=>checking python3 installation\n${NC}"
if ! command -v python3 &> /dev/null
then 
  echo -n "python 3.x not found, do you want to install it ? [y/n]: "
  read RESPONSE
  if [[ "$RESPONSE" == "y" ]] || [[ "$RESPONSE" == "Y" ]]
  then 
    sudo apt update && sudo apt install software-properties-common && sudo add-apt-repository ppa:deadsnakes/ppa && sudo apt update && sudo apt install python3.8 && echo "pythob 3.8 installed, info: " && python3 -v
  fi
else 
  echo "python3 is already installed, info: " && python3 -V
fi

#================#
#===== pip3 =====#
#================#
printf "\n${GREEN}=>checking pip3 installation${NC}\n"
if ! command -v pip3 &> /dev/null
then
  echo -n "pip3 is not installed, do you want to install it? [y/n]: " && read RESPONSE
  if [[ "$RESPONSE" == "y" ]] || [[ "$RESPONSE" == "Y" ]]; then
    sudo apt install python3-pip && echo "pip3 is now installed, info: " && pip3 -V
  fi
else
  echo "pip3 is already installed, info: " && pip3 -V
fi

#==============================#
#===== powerline settings =====#
#==============================#

printf "\n${GREEN}=>checking powerline installation${NC}\n"
if ! command -v powerline-daemon &> /dev/null
then
  echo "powerline could not be found, do you want to install it with (pip install git+git://github.com/Lokaltog/powerline)? [y/n]: "
  read RESPONSE
  if [[ "$RESPONSE" == "y" ]] || [[ "$RESPONSE" == "Y" ]]
  then 
    pip3 install git+git://github.com/Lokaltog/powerline && echo "powerline is now installed"
  fi
else
  echo "powerline is installed, enabling powerline for both shell and vim"
  powerline-daemon -q
  POWERLINE_BASH_CONTINUATION=1
  POWERLINE_BASH_SELECT=1
  export TERM="screen-256color"
fi

if [ -e $HOME/anaconda3/lib/python3.8/site-packages/powerline/bindings/bash/powerline.sh ]; then
  $HOME/anaconda3/lib/python3.8/site-packages/powerline/bindings/bash/powerline.sh
fi

if [ -e $HOME/.local/lib/python3.8/site-packages/powerline/bindings/bash/powerline.sh ]; then
  $HOME/.local/lib/python3.8/site-packages/powerline/bindings/bash/powerline.sh
fi

#================#
#===== curl =====#
#================#
printf "\n${GREEN}=>checking curl installation${NC}\n"
if ! command -v curl &> /dev/null
then
  echo "curl is not installed, installing it with command (sudo apt install curl)" 
  sudo apt install curl && echo "curl is now installed"
else
  echo "curl is already installed, info: " && curl -V
fi

#==================#
#===== nodejs =====#
#==================#
printf "\n${GREEN}=>checking nodejs installation\n${NC}"
if ! command -v node &> /dev/null
then
  echo -n "nodejs is not installed, do you want to install it? (executing command (curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -)) [y/n]: "
  read RESPONSE

  if [[ "$RESPONSE" == "y" ]] || [[ "$RESPONSE" == "Y" ]]
  then 
    echo "installing nodejs (>= 10.12)"
    curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash - && echo "nodejs is now installed, info: " && node -v 
  fi
else
  echo "nodejs is already installed, info: " && node -v
fi

#===============#
#===== vim =====#
#===============#
printf "\n${GREEN}=>installing vim 8.2"
sudo add-apt-repository ppa:jonathonf.vim && sudo apt update && sudo apt install vim
if [ -e $HOME/.vim ]; then
  mkdir $HOME/.vim
  cp -r $HOME/vim-settings/* $HOME/.vim 
  vim +PlugInstall +qall
fi

#===================#
#===== opencv3 =====#
#===================#
printf "\n${GREEN}=>installing opencv3\n${NC}"
cd $HOME
sudo apt install wget
sudo apt update && sudo apt install -y cmake g++ wget unzip
wget -O opencv.zip https://github.com/opencv/opencv/archive/master.zip
unzip opencv.zip
mkdir -p build && cd build
cmake ../opencv-master
cmake --build .

#=======================#
#===== ros melodic =====#
#=======================#
printf "\n${GREEN}=>installing ros melodic\n${NC}"
cd $HOME
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
sudo apt update
sudo apt install ros-melodic-desktop-full
sudo pip3 install rosdep
sudo rosdep init
sudo rosdep update
sudo apt install python-rosinstall python-rosinstall-generator python-wstool build-essential


#==========================#
#===== rm2021 project =====#
#==========================#
printf "\n${GREEN}cloning rm2021 cv project\n${NC}"
cd $HOME
git clone git@github.com:Ikemura-kei/HKUST-Enterprize-Autonomous-Robot-Framework.git
echo ""

echo "Done basic setup, please download the Spinnaker SDK and then you will be set!"
