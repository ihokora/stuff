#!/bin/sh
echo "Downloading eris..."
mkdir -p $HOME/.bin
PATH=$PATH:$HOME/.bin
echo `curl -L https://github.com/eris-ltd/eris-cli/releases/download/v0.12.0/eris_0.12.0_darwin_amd64 > $HOME/.bin/eris`
chmod +x $HOME/.bin/eris
echo "Installing eris..."
echo `yes | eris init`

# Define central server node
central_host=get.polywaytech.com

# Define blockchain name
chain_name=apir_chain

# Define chain_dir
chain_dir=~/.eris/chains/$chain_name

# Define chain_config
chain_config=$chain_dir/config.toml

# Define app dir
app_dir=~/.eris/apps/apir

# Make folder for apir app
mkdir -p $app_dir

# Clean eris chains before start
eris clean -y --chains

echo "Starting eris keys service..."
eris services start keys

echo "Making eris chain for you..."
eris chains make $chain_name --account-types=Full:1

# Edit the config.toml
sed 's/# block_size =.*$/block_size = 100000/g' $chain_config > $chain_config.new;
mv $chain_config.new $chain_config
sed 's/# timeout_propose =.*$/timeout_propose = 30000/g' $chain_config > $chain_config.new;
mv $chain_config.new $chain_config
sed 's/# timeout_propose_delta =.*$/timeout_propose_delta = 5000/g' $chain_config > $chain_config.new;
mv $chain_config.new $chain_config
sed 's/# timeout_prevote =.*$/timeout_prevote = 10000/g' $chain_config > $chain_config.new;
mv $chain_config.new $chain_config
sed 's/# timeout_prevote_delta =.*$/timeout_prevote_delta = 5000/g' $chain_config > $chain_config.new;
mv $chain_config.new $chain_config
sed 's/# timeout_precommit =.*$/timeout_precommit = 10000/g' $chain_config > $chain_config.new;
mv $chain_config.new $chain_config
sed 's/# timeout_precommit_delta =.*$/timeout_precommit_delta = 5000/g' $chain_config > $chain_config.new;
mv $chain_config.new $chain_config
sed 's/# timeout_commit =.*$/timeout_commit = 10000/g' $chain_config > $chain_config.new;
mv $chain_config.new $chain_config

echo "Starting your chain..."
eris chains start $chain_name

echo "Deploying contract..."
full_addr=$(cat $chain_dir/addresses.csv | grep full_000 | cut -d ',' -f 1)
cd $app_dir && eris pkgs do -c $chain_name -a $full_addr -z
