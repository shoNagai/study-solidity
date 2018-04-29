pragma solidity ^0.4.11;

contract MarketPlaceOverflow {
    address public owner;
    uint public stockQuantity;

    modifier onlyOwner() {
        require(owner == msg.sender);
        _;
    }

    event AddStock(uint _addedQuantity);

    function MarketPlaceOverflow() public {
        owner = msg.sender;
        stockQuantity = 100;
    } 

    function addStock(uint _addedQuantity) public onlyOwner {

        // 追加数のチェック
        require(_addedQuantity < 256);

        // オーバーフローチェック
        require(stockQuantity + _addedQuantity > stockQuantity);

        emit AddStock(_addedQuantity);
        stockQuantity += _addedQuantity;
    }

}