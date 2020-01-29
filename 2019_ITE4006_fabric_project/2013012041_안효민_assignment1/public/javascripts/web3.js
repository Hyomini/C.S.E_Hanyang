var web3 = new Web3();
web3.setProvider(new Web3.providers.HttpProvider('http://localhost:8545'));

const contract_address = "0x9Ccf83911Cd492C4c9c1B9f721CA77D596ecA161";
const abi = [
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "address payable",
				"name": "seller",
				"type": "address"
			},
			{
				"internalType": "uint256",
				"name": "price",
				"type": "uint256"
			}
		],
		"name": "balanceTransfer",
		"outputs": [],
		"payable": true,
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "uint256",
				"name": "orderedcnumber",
				"type": "uint256"
			}
		],
		"name": "buyUserCar",
		"outputs": [],
		"payable": true,
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "uint256",
				"name": "cnumber",
				"type": "uint256"
			},
			{
				"internalType": "address payable",
				"name": "addr",
				"type": "address"
			}
		],
		"name": "changeCarOwner",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "string",
				"name": "_make",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_model",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "_color",
				"type": "string"
			}
		],
		"name": "registerCar",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "string",
				"name": "_name",
				"type": "string"
			}
		],
		"name": "registerName",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [
			{
				"internalType": "uint256",
				"name": "cnumber",
				"type": "uint256"
			},
			{
				"internalType": "uint256",
				"name": "price",
				"type": "uint256"
			}
		],
		"name": "sellMyCar",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "balanceOf",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"name": "cars",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "number",
				"type": "uint256"
			},
			{
				"internalType": "string",
				"name": "owner_name",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "make",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "model",
				"type": "string"
			},
			{
				"internalType": "string",
				"name": "color",
				"type": "string"
			},
			{
				"internalType": "address payable",
				"name": "owner",
				"type": "address"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "getAllOrderedCar",
		"outputs": [
			{
				"components": [
					{
						"components": [
							{
								"internalType": "uint256",
								"name": "number",
								"type": "uint256"
							},
							{
								"internalType": "string",
								"name": "owner_name",
								"type": "string"
							},
							{
								"internalType": "string",
								"name": "make",
								"type": "string"
							},
							{
								"internalType": "string",
								"name": "model",
								"type": "string"
							},
							{
								"internalType": "string",
								"name": "color",
								"type": "string"
							},
							{
								"internalType": "address payable",
								"name": "owner",
								"type": "address"
							}
						],
						"internalType": "struct ICarTrade.Car",
						"name": "car",
						"type": "tuple"
					},
					{
						"internalType": "uint256",
						"name": "price",
						"type": "uint256"
					},
					{
						"internalType": "string",
						"name": "status",
						"type": "string"
					}
				],
				"internalType": "struct ICarTrade.Order[]",
				"name": "",
				"type": "tuple[]"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "getAllRegisteredCar",
		"outputs": [
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "number",
						"type": "uint256"
					},
					{
						"internalType": "string",
						"name": "owner_name",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "make",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "model",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "color",
						"type": "string"
					},
					{
						"internalType": "address payable",
						"name": "owner",
						"type": "address"
					}
				],
				"internalType": "struct ICarTrade.Car[]",
				"name": "",
				"type": "tuple[]"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "getMyCars",
		"outputs": [
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "number",
						"type": "uint256"
					},
					{
						"internalType": "string",
						"name": "owner_name",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "make",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "model",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "color",
						"type": "string"
					},
					{
						"internalType": "address payable",
						"name": "owner",
						"type": "address"
					}
				],
				"internalType": "struct ICarTrade.Car[]",
				"name": "",
				"type": "tuple[]"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [],
		"name": "getName",
		"outputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"internalType": "uint256",
				"name": "orderedcnumber",
				"type": "uint256"
			}
		],
		"name": "getPrice",
		"outputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"internalType": "address",
				"name": "",
				"type": "address"
			}
		],
		"name": "names",
		"outputs": [
			{
				"internalType": "string",
				"name": "",
				"type": "string"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"name": "numToOrder",
		"outputs": [
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "number",
						"type": "uint256"
					},
					{
						"internalType": "string",
						"name": "owner_name",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "make",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "model",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "color",
						"type": "string"
					},
					{
						"internalType": "address payable",
						"name": "owner",
						"type": "address"
					}
				],
				"internalType": "struct ICarTrade.Car",
				"name": "car",
				"type": "tuple"
			},
			{
				"internalType": "uint256",
				"name": "price",
				"type": "uint256"
			},
			{
				"internalType": "string",
				"name": "status",
				"type": "string"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"constant": true,
		"inputs": [
			{
				"internalType": "uint256",
				"name": "",
				"type": "uint256"
			}
		],
		"name": "orders",
		"outputs": [
			{
				"components": [
					{
						"internalType": "uint256",
						"name": "number",
						"type": "uint256"
					},
					{
						"internalType": "string",
						"name": "owner_name",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "make",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "model",
						"type": "string"
					},
					{
						"internalType": "string",
						"name": "color",
						"type": "string"
					},
					{
						"internalType": "address payable",
						"name": "owner",
						"type": "address"
					}
				],
				"internalType": "struct ICarTrade.Car",
				"name": "car",
				"type": "tuple"
			},
			{
				"internalType": "uint256",
				"name": "price",
				"type": "uint256"
			},
			{
				"internalType": "string",
				"name": "status",
				"type": "string"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	}
]
let carTrade = new web3.eth.Contract(abi, contract_address);
var userAddress = "";

$(document).ready(function() {
	startDapp();
})

var startDapp = async function() {
	getBalance();
	getName();
	getAddress();
}


var getBalance = function() {
	html = "";
	html += carTrade.methods.balanceOf().call({from:userAddress});
	document.getElementById('balanceAmount').innerHTML = html;
}

var getName = async function() {
	html = "";
	html += carTrade.methods.getName().call({from: userAddress});
	document.getElementById('name').innerHTML = html;
}

var getAddress = function() {
	$('#address').text(userAddress);
}

var registerAddress = async function() {
	var address = await document.getElementById("private_key").value;
	userAddress = address;
	$('#address').text(userAddress);
}

var registerName = async function() {
	var name = await document.getElementById("change_name").value;
	console.log(name)
	carTrade.methods.registerName(name).send({from : userAddress, gas:5000000});
	getName();
}


var registerMyCar = async function() {
	var make = await document.getElementById("make").value;
	var model = await document.getElementById("model").value;
	var color = await document.getElementById("color").value;
	console.log(make)
	console.log(model)
	console.log(color)
	carTrade.methods.registerCar(make, model, color).send({from: userAddress, gas:5000000});
}

var sellMyCar = async function() {
	var cnumber = await document.getElementById("mycars-category").value;
	var price = await document.getElementById("price").value;
	console.log(cnumber)
	console.log(price)
	carTrade.methods.sellMyCar(cnumber, price).send({from: userAddress, gas:5000000});
}

var buyUserCar = async function() {
	var cnumber = await document.getElementById("sale-category").value;
	var price = await carTrade.methods.getPrice(cnumber).call({from: userAddress});
	console.log(cnumber)
	carTrade.methods.buyUserCar(cnumber, price).send({from: userAddress, gas:5000000, value:price * Math.pow(10, 18)});
}

var getMyCars = async function() {
	var carList = new Array(await carTrade.methods.getMyCars().call({from: userAddress}));
}

var getRegisteredCars = async function() {
}

var getSellMyCars = async function() {
}

var getCarsOnSale = async function() {

}

var getBuyUsersCar = async function() {

}

