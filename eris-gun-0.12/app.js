'use strict';

// ENV VARIABLES:
//   PORT=1111
//   CHAIN_DIR=.eris
//   CHAIN_HOST=localhost
//   CHAIN_NAME=apir_chain
//   APP_NAME=apir
//   ACCOUNT_TYPE=participant
var port =         process.env.PORT || 1111;
var chainUrl =     'http://' + (process.env.CHAIN_HOST || 'localhost') + ':1337/rpc';
var chainDir =     process.env.CHAIN_DIR || (process.env.HOME + '/.eris')
var chainName =    process.env.CHAIN_NAME || 'apir_chain'
var appName =      process.env.APP_NAME || 'apir'
var accountType =  process.env.ACCOUNT_TYPE || 'participant'
var accountName =  chainName + '_' + accountType + '_000'
var contractPath = chainDir + '/apps/' + appName + '/jobs_output.json'
var accountPath =  chainDir + '/chains/' + chainName + '/accounts.json'

var http =            require('http');
var edbFactory =      require('eris-db');
var accounts =        require(accountPath);
var contractAddress = require(contractPath).deployStorageK;
var edb = edbFactory.createInstance(chainUrl);
var account = accounts[accountName];

var server = http.createServer(function (request, response) {
  var body;

  switch (request.method) {
    case 'POST':
      body = '';

      request.on('data', function (chunk) {
        body += chunk;
      });

      request.on('end', function () {
        console.log("Received request to transact " + body + '.');
        edb.txs().transactAndHold(account.privKey, contractAddress, body, 1000000, 0, null, function (error, result) {
          if (error) {
            console.log(error);
            response.statusCode = 500;
            response.write('{}')
          } else {
            console.log(result);
            response.statusCode = 200;
            response.setHeader('Content-Type', 'application/json');
            response.write(JSON.stringify(result));
          }
          response.end();
        })
      })

      break

    default:
      response.statusCode = 501;
      response.end();
  }
});

server.listen(port, function () {
  console.log('Listening for HTTP requests on port ' + port);
});
