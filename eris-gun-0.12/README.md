# Quick start
```sh
sudo yum install nodejs npm --enablerepo=epel
sudo npm install
sudo npm install forever -g
PORT=1111 RPC_HOST=192.168.99.100 ACCOUNT_TYPE=full CHAIN_NAME=apir_chain forever start app.js
```
