var express = require('express');
var enroll = require('../fabric_js/enrollAdmin.js')
var register = require('../fabric_js/registerUser.js')
var query = require('../fabric_js/query.js')
var invoke = require('../fabric_js/invoke.js')
var router = express.Router();

let user;
var myCars;
var carsOnSale;
var registeredCars;

/* GET home page. */
router.get('/', function(req, res, next) {
 	res.render('index', { name: req.cookies.user, myCars: myCars, registeredCars: registeredCars, carsOnSale: carsOnSale});
});

router.get('/enrollAdmin', async function(req, res, next) {
	enroll.enrollAdmin();
		res.redirect('/');
})

router.post('/registerUser', async function(req, res, next) {
	user = req.body.user;
	console.log(user);
	register.registerUser(user);
	res.cookie('user', user);
	res.redirect('/');
})

router.post('/registerCar', async function(req, res, next) {
	var result = await invoke.invoke(req.cookies.user, "registerCar", [req.body.make,req.body.model,req.body.color,req.cookies.user]);
	var queryResult = await query.query(req.cookies.user);
	myCars = queryResult[0];
	registeredCars = queryResult[1];
	carsOnSale = queryResult[2];
	res.render('index',{name: req.cookies.user, myCars: myCars, registeredCars: registeredCars, carsOnSale: carsOnSale});
	res.redirect('/');
});

router.post('/sellMyCar', async function(req, res, next) {
	var result = await invoke.invoke(req.cookies.user, "sellMyCar",req.body['demo-category']);
	var queryResult = await query.query(req.cookies.user);
	carsOnSale = queryResult[2];
	res.render('index',{name: req.cookies.user,myCars: myCars,registeredCars: registeredCars, carsOnSale: carsOnSale});
	res.redirect('/');
});

router.post('/buyCar', async function(req, res, next) {
	var result = await invoke.invoke(req.cookies.user,"buyUserCar",[req.body['demo-category'],req.cookies.user]);
	var queryResult = await query.query(req.cookies.user);
	myCars = queryResult[0];
	registeredCars = queryResult[1];
	carsOnSale = queryResult[2];
	res.render('index',{name: req.cookies.user,myCars: myCars, registeredCars: registeredCars, carsOnSale: carsOnSale});
	res.redirect('/');
});

module.exports = router;
