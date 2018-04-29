pragma solidity ^0.4.18;

contract Owned {
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function owned() internal {
        owner = msg.sender;
    }

    function changeOwner(address _newOwner) public onlyOwner {
        owner = _newOwner;
    }
}

contract Mortal is Owned {
    // コントラクトの破棄して、etherをownerへ送る
    function kill() public onlyOwner {
        selfdestruct(owner);
    }
}

contract MortalSample is Mortal {
    string public someState;

    function() public payable {
    }

    function MortalSample() public {
        owned();
        someState = "initial";
    }
}