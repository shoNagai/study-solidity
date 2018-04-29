pragma solidity ^0.4.11;

contract MarketPlaceTOD {
    address public owner;
    uint public price;
    uint public stockQuantity;

    modifier onlyOwner() {
        require(owner == msg.sender);
        _;
    }

    event UpdatePrice(uint _price);
    event Buy(uint _price, uint _quantity, uint _value, uint _change);

    function MarketPlaceTOD() public {
        owner = msg.sender;
        price = 1;
        stockQuantity = 100;
    } 

    function updatePrice(uint _price) public onlyOwner {
        price = _price;
        emit UpdatePrice(price);
    }

    function buy(uint _quantity) public payable {
        if(msg.value < _quantity * price || _quantity > stockQuantity) {
            revert();
        }
        if(!msg.sender.send(msg.value - _quantity * price)) {
            revert();
        }

        stockQuantity -= _quantity;
        emit Buy(price,  _quantity, msg.value, msg.value - _quantity * price);

    }

}