/*
 * SPDX-License-Identifier: Apache-2.0
 */

'use strict';

const { FileSystemWallet, Gateway } = require('fabric-network');
const path = require('path');

const ccpPath = path.resolve(__dirname, '..', 'fabric-network', 'connection-org1.json');

var query = async function(name){
    try {

        // Create a new file system based wallet for managing identities.
        const walletPath = path.join(process.cwd(), 'wallet');
        const wallet = new FileSystemWallet(walletPath);
        console.log(`Wallet path: ${walletPath}`);

        // Check to see if we've already enrolled the user.
        const userExists = await wallet.exists(name);
        if (!userExists) {
            console.log('An identity for the user does not exist in the wallet');
            console.log('Run the registerUser.js application before retrying');
            return;
        }

        // Create a new gateway for connecting to our peer node.
        const gateway = new Gateway();
        await gateway.connect(ccpPath, { wallet, identity: name, discovery: { enabled: true, asLocalhost: true } });

        // Get the network (channel) our contract is deployed to.
        const network = await gateway.getNetwork('mychannel');

        // Get the contract from the network.
        const contract = network.getContract('mycc');

        //execute query function
        const mycars = await contract.submitTransaction('getMyCar',name);
		const allcars = await contract.submitTransaction('getAllRegisteredCar',name);
		const orders = await contract.submitTransaction('getAllOrderedCar',name);
        var queryResult = [];

       // const result = await contract.evaluateTransaction('getMyCar',name);
		var after = mycars.toString('utf8').substring(1);
		var table = [];
		//query result value(string), string to json and use 
        for(var i=0; i<after.length; ++i) {
			if(after[i]=='{') {
				var j=i;
				while(after[i++]!='}') {}		
				var test = JSON.parse(after.substring(j,i)); // -> string to json
				table.push(test['key']);
				table.push(test['owner']);
				table.push(test['make']);
				table.push(test['model']);
				table.push(test['color']);
			}
		}
		queryResult.push(table);
	
		table=[];
		after=allcars.toString('utf8').substring(1);
        for(var i=0; i<after.length; ++i) {
			if(after[i]=='{') {
				var j=i;
				while(after[i++]!='}') {}		
				var test = JSON.parse(after.substring(j,i)); // -> string to json
				table.push(test['key']);
				table.push(test['owner']);
				table.push(test['make']);
				table.push(test['model']);
				table.push(test['color']);
			}
		}
		queryResult.push(table);

		table=[];
		after=orders.toString('utf8').substring(1);
        for(var i=0; i<after.length; ++i) {
			if(after[i]=='{') {
				var j=i;
				while(after[i++]!='}') {}		
				var test = JSON.parse(after.substring(j,i)); // -> string to json
				table.push(test['carid']);
				table.push(test['owner']);
				table.push(test['make']);
				table.push(test['model']);
				table.push(test['color']);
				table.push(test['price']);
				table.push(test['status']);
			}
		}
		queryResult.push(table);
        return queryResult;

    } catch (error) {
        console.error(`Failed to evaluate transaction: ${error}`);
        process.exit(1);
    }
}

exports.query = query;