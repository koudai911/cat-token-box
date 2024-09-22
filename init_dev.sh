cd ~
apt-get update -y 
apt-get install wget -y
apt-get install sudo
apt-get -y install curl
apt-get install git -y
apt-get install yarn -y
sudo apt-get install npm -y
sudo npm install n -g
sudo n stable
sudo npm i -g yarn
apt-get install jq -y
apt-get install bc -y

# 下载cat-token-box 仓库并且构建
wget -O init_cat20.sh https://raw.githubusercontent.com/koudai911/cat-token-box/main/init_cat20.sh 
chmod +x init_cat20.sh
./init_cat20.sh
