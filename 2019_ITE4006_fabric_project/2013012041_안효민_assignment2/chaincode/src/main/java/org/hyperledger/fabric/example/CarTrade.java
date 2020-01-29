/*
Copyright IBM Corp., DTCC All Rights Reserved.

SPDX-License-Identifier: Apache-2.0
*/
package org.hyperledger.fabric.example;

import java.util.ArrayList;
import java.util.List;

import com.google.protobuf.ByteString;
import io.netty.handler.ssl.OpenSsl;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hyperledger.fabric.shim.ChaincodeBase;
import org.hyperledger.fabric.shim.ChaincodeStub;
import org.hyperledger.fabric.shim.ChaincodeException;
import org.hyperledger.fabric.shim.ledger.KeyValue;
import org.hyperledger.fabric.shim.ledger.QueryResultsIterator;

import static java.nio.charset.StandardCharsets.UTF_8;
import com.owlike.genson.Genson;

public class CarTrade extends ChaincodeBase {

    private static Log _logger = LogFactory.getLog(CarTrade.class);
    private final Genson genson = new Genson();
    int next_id = 0;
    int next_order = 0;

    @Override
    public Response init(ChaincodeStub stub) {
        try {
            String func = stub.getFunction();
            if (!func.equals("init")) {
                return newErrorResponse("function other than init is not supported");
            }
            return newSuccessResponse();
        } catch (Throwable e) {
            return newErrorResponse(e);
        }
    }

    public enum FabCarErrors {
        CAR_NOT_FOUND,
        CAR_ALREADY_EXISTS
    }
       

    @Override
    public Response invoke(ChaincodeStub stub) {
        try {
            _logger.info("Invoke java chaincode");
            String func = stub.getFunction();
            List<String> params = stub.getParameters();
            if (func.equals("registerCar")) {
                return registerCar(stub, params);
            }
            if (func.equals("sellMyCar")) {
                return sellMyCar(stub, params);
            }
            if (func.equals("buyUserCar")) {
                return buyUserCar(stub, params);
            }
            if (func.equals("changeCarOwner")) {
                return changeCarOwner(stub, params);
            }
            if (func.equals("getMyCar")) {
                return getMyCar(stub, params);
            }
            if (func.equals("getAllRegisteredCar")) {
                return getAllRegisteredCar(stub, params);
            }
            if (func.equals("getAllOrderedCar")) {
                return getAllOrderedCar(stub, params);
            }
            return newErrorResponse("Invalid invoke function name.");
        } catch (Throwable e) {
            return newErrorResponse(e);
        }
    }

    private Response registerCar(ChaincodeStub stub, List<String> args) {
        String make = new String(args.get(0));
        String model = new String(args.get(1));
        String color = new String(args.get(2));
        String owner = new String(args.get(3));
        String key = Integer.toString(next_id++);

        Car car = new Car(make, model, color, owner);

        String carState = genson.serialize(car);

        stub.putStringState(key, carState);

        return newSuccessResponse("invoke finished successfully");
    }

    private Response sellMyCar(ChaincodeStub stub, List<String> args) {
        String id = new String(args.get(0));
        int price = Integer.parseInt(args.get(1));
        String status = "sale";

        String carState = stub.getStringState(id);

        if (carState.isEmpty()) {
            String errorMessage = String.format("Car %s does not exist!", id);
            System.out.println(errorMessage);
            throw new ChaincodeException(errorMessage, FabCarErrors.CAR_ALREADY_EXISTS.toString());
        }

        Car car = genson.deserialize(carState, Car.class);
        
        Order order = new Order(id, car.getMake(), car.getModel(), car.getColor(), car.getOwner(), price, status);
        String orderState = genson.serialize(order);
        String key = String.format("O%03d", next_order++);

        stub.putStringState(key, orderState);

        return newSuccessResponse("invoke finished successfully");
    }

    private Response buyUserCar(ChaincodeStub stub, List<String> args) {
        String id = new String(args.get(0));
        String buyer = new String(args.get(1));
        String status = "done";

        String carState = stub.getStringState(id);
		Car car = genson.deserialize(carState, Car.class);
		
		Order order = null;
		String orderKey= "";
		String startKey = "O000";
		String endKey = "O999";

		QueryResultsIterator<KeyValue> results = stub.getStateByRange(startKey,endKey);
		for(KeyValue result: results) {
			order = genson.deserialize(result.getStringValue(), Order.class);
			if(order.getId().equals(id) && order.getStatus().equals("sale")) {
				orderKey = result.getKey();
				break;
			}
        }
        
        changeCarOwner(stub, args);
        Order newOrder = new Order(id, car.getMake(), car.getModel(), car.getColor(), car.getOwner(), order.getPrice(), status);
		String orderState=genson.serialize(newOrder);
        stub.putStringState(orderKey,orderState);
        
        return newSuccessResponse("invoke finished successfully");
    }

    private Response changeCarOwner(ChaincodeStub stub, List<String> args) {
        String id = new String(args.get(0));
        String newOwner = new String(args.get(1));
        String status = "done";

        String carState = stub.getStringState(id);

        if (carState.isEmpty()) {
            String errorMessage = String.format("Car %s does not exist", id);
            System.out.println(errorMessage);
            throw new ChaincodeException(errorMessage, FabCarErrors.CAR_NOT_FOUND.toString());
        }

        Car car = genson.deserialize(carState, Car.class);

        Car newCar = new Car(car.getMake(), car.getModel(), car.getColor(), newOwner);
        newCar.changeId(id);

        String newCarState = genson.serialize(newCar);
        stub.putStringState(id, newCarState);

        return newSuccessResponse("invoke finished successfully");
    }

    private Response getMyCar(ChaincodeStub stub, List<String> args) {
        final String startKey = "0";
        final String endKey = "999";
        final String name = new String(args.get(0));
        String val = "";
        
        QueryResultsIterator<KeyValue> results = stub.getStateByRange(startKey, endKey);

        for (KeyValue result: results) {
            Car car = genson.deserialize(result.getStringValue(), Car.class);
            if (name.equals(car.getOwner())) {
                String carString = genson.serialize(car);
				String key = result.getKey();
				val = val + ",{\"key\":\""+key+"\",}" + carString; 
            }
        }

        return newSuccessResponse(val, ByteString.copyFrom(val, UTF_8).toByteArray());
        //return newSuccessResponse("invoke finished successfully");
    }

    private Response getAllRegisteredCar(ChaincodeStub stub, List<String> args) {
        final String startKey = "0";
        final String endKey = "999";
        String val = "";
        
        QueryResultsIterator<KeyValue> results = stub.getStateByRange(startKey, endKey);

        for (KeyValue result: results) {
            Car car = genson.deserialize(result.getStringValue(), Car.class);
            String carString = genson.serialize(car);
			String key = result.getKey();
			val = val + ",{\"key\":\""+key+"\",}" + carString;
        }

        return newSuccessResponse(val, ByteString.copyFrom(val, UTF_8).toByteArray());
        //return newSuccessResponse("invoke finished successfully");
    }

    private Response getAllOrderedCar(ChaincodeStub stub, List<String> args) {
        final String startKey = "O000";
        final String endKey = "O999";
        final String status = "sale";
        String val = "";
        List<Order> orders = new ArrayList<Order>();
        
        QueryResultsIterator<KeyValue> results = stub.getStateByRange(startKey, endKey);

        for (KeyValue result: results) {
            Order order = genson.deserialize(result.getStringValue(), Order.class);
            if (status.equals(order.getStatus())) {
                String orderString = genson.serialize(order);
			    val = val + "," + orderString;
            }
        }

        return newSuccessResponse(val, ByteString.copyFrom(val, UTF_8).toByteArray());
        //return newSuccessResponse("invoke finished successfully");
    }

    public static void main(String[] args) {
        System.out.println("OpenSSL avaliable: " + OpenSsl.isAvailable());
        new CarTrade().start(args);
    }
}