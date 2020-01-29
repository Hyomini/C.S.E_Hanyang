package org.hyperledger.fabric.example;
 
import java.util.Objects;
 
import org.hyperledger.fabric.contract.annotation.DataType;
import org.hyperledger.fabric.contract.annotation.Property;

import com.owlike.genson.annotation.JsonProperty;

public class Order {
    @Property()
    private String id;

    @Property()
    private String make;
    
    @Property()
    private String model;
    
    @Property()
    private String color;
    
    @Property()
    private String owner;
    
    @Property()
    private int price;
    
    @Property()
	private String status;

	public String getId() {
        return id;
    }

    public String getMake() {
        return make;
    }

    public String getModel() {
        return model;
    }

    public String getColor() {
        return color;
    }

    public String getOwner() {
        return owner;
    }

	public int getPrice() {
		return price;
	}

	public String getStatus() {
		return status;
	}

	public void changeStatus() {
		status="done";
	}

    public Order(@JsonProperty("id") final String id, @JsonProperty("make") final String make, @JsonProperty("model") final String model, @JsonProperty("color") final String color, @JsonProperty("owner") final String owner, @JsonProperty("price") final int price, @JsonProperty("status") final String status)
	{
		this.id = id;
		this.make = make;
		this.model = model;
		this.color = color;
		this.owner = owner;
		this.price = price;
		this.status = status;
	}
}