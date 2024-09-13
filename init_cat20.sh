tracker_ip=${1}
cd ~
git clone https://github.com/koudai911/cat-token-box.git
cd cat-token-box
yarn install
yarn build
sudo chmod 777 packages/tracker/docker/data
sudo chmod 777 packages/tracker/docker/pgdata

cd packages/cli 

echo '{
      "network": "fractal-mainnet",
      "tracker": "http://${tracker_ip}:3000",
      "dataDir": ".",
      "maxFeeRate": 30,
      "rpc": {
          "url": "http://${tracker_ip}:8332",
          "username": "bitcoin",
          "password": "opcatAwesome"
      }
    }' > ~/cat-token-box/packages/cli/config.json


yarn cli wallet create
chmod +x script.sh
yarn cli wallet address
yarn cli wallet balances
