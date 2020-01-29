pragma solidity ^0.5;
pragma experimental ABIEncoderV2;


contract ICarTrade{

    struct Car{
        uint number;
        string owner_name;
        string make;
        string model;
        string color;
        address payable owner;
    }
    
    struct Order{
        Car car;
        uint price;
        string status;
    }

    Order[] public orders;
    Car[] public cars;
    
    mapping(address => string) public names; // 주소와 이름이 매칭되는 해쉬테이블
    mapping(uint => address) carToOwner; // 차의 소유주를 알려주는 해쉬테이블
    mapping(uint => Order) public numToOrder; // 차량고유번호로 판매정보를 알려주는 해쉬테이블
    
    function balanceOf() public view returns(uint ) {
        uint balance = msg.sender.balance;
        return balance;
    }

    function registerCar(string memory _make, string memory _model, string memory _color) public {
        uint Id = cars.length; // cars 배열의 길이, 즉 자동차의 고유번호를 순차적으로 매긴다.
        address payable owner = msg.sender;
        string memory owner_name = names[msg.sender];
        cars.push(Car(Id, owner_name, _make, _model, _color, owner));
        carToOwner[Id] = msg.sender;

    }
    function registerName(string memory _name) public {
        names[msg.sender] = _name;
    }
    function sellMyCar(uint cnumber, uint price) public {
        string memory status = 'sale';
        require(msg.sender == cars[cnumber].owner, "This car doesn't belong to you!");
        numToOrder[cnumber] = orders[orders.push(Order(cars[cnumber], price, status)) - 1];
        
    }
    function buyUserCar(uint orderedcnumber) payable public {
        balanceTransfer(cars[orderedcnumber].owner, numToOrder[orderedcnumber].price);
        changeCarOwner(orderedcnumber, msg.sender);
    }

    function getPrice(uint orderedcnumber) public view returns (uint ){
        uint price = 0;
        for (uint i = 0; i < orders.length; i++) {
            if (orders[i].car.number == orderedcnumber && keccak256(bytes(orders[i].status)) != keccak256(bytes("done"))) {
                price = orders[i].price;
                break;
            }
        }
        return price;
    } 

    function balanceTransfer(address payable seller, uint price) payable public {
        require(msg.sender != address(0), "ERC20: transfer from the zero address");
        require(seller != address(0), "ERC20: transfer to the zero address");
        uint eth = price * 10**18;
        seller.transfer(eth);
    }

    function changeCarOwner(uint cnumber, address payable addr) public {
        carToOwner[cnumber] = addr;
        cars[cnumber].owner_name = names[addr];
        cars[cnumber].owner = addr;
        for (uint i = 0; i < orders.length; i++) {
            if (orders[i].car.number == cnumber && keccak256(bytes(orders[i].status)) != keccak256(bytes("done"))) {
                orders[i].car.owner_name = names[addr];
                orders[i].car.owner = addr;
                orders[i].status = 'done';
                break;
            }
        }
        numToOrder[cnumber].car = cars[cnumber];
        numToOrder[cnumber].status = 'done';
    }

    function getMyCars() public view returns(Car[] memory) {
        Car[] memory tmpCar = new Car[](cars.length);
        uint j = 0;
        for (uint i; i < cars.length; i++) {
            if (msg.sender == cars[i].owner) {
                tmpCar[j++] = cars[i];
            }
        }
        return tmpCar;
    }
    function getName() public view returns(string memory) {
        return names[msg.sender];
    }
    function getAllRegisteredCar() public view returns(Car[] memory) {
        return cars;
    }
    function getAllOrderedCar() public view returns(Order[] memory) {
        Order[] memory tmpOrder = new Order[](orders.length);
        uint j = 0;
        for (uint i; i < orders.length; i++) {
            if (keccak256(bytes(orders[i].status)) == keccak256(bytes('sale'))) {
                tmpOrder[j++] = orders[i];
            }
        }
        return tmpOrder;
    }
}