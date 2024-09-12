cd ~
git clone https://github.com/koudai911/cat-token-box.git
cd cat-token-box
yarn install
yarn build
sudo chmod 777 packages/tracker/docker/data
sudo chmod 777 packages/tracker/docker/pgdata

cd packages/cli 
cat config.json # 查看 config.json 文件配置，记得修改自己仓库的 config.example.json 文件
yarn cli wallet create
chmod +x script.sh
yarn cli wallet address
yarn cli wallet balances
