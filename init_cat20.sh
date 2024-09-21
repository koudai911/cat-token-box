
cd ~
git clone https://github.com/koudai911/cat-token-box.git
cd cat-token-box
yarn install
yarn build
sudo chmod 777 packages/tracker/docker/data
sudo chmod 777 packages/tracker/docker/pgdata

# cd packages/cli 
# yarn cli wallet create
# chmod +x script.sh
# yarn cli wallet address
# yarn cli wallet balances
# yarn cli wallet export
