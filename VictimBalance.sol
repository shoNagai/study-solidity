pragma solidity ^0.4.18;

contract VictimBalance {

    mapping (address => uint) public userBalances;
    event MessageLog(string);
    event BalanceLog(uint);

    function VictimBalance() public {

    }

    function addToBalance() public payable {
        userBalances[msg.sender] += msg.value;
    }

    function withdrawBalance() public payable returns(bool) {
        emit MessageLog("withdrawBalance started.");
        emit BalanceLog(address(this).balance);

        if(userBalances[msg.sender] == 0){
            emit MessageLog("No Balance.");
            return false;
        }

        uint amount = userBalances[msg.sender];

        userBalances[msg.sender] = 0;

        msg.sender.transfer(amount);

        emit MessageLog("withdrawBalance finished.");

        return false;
    }
}