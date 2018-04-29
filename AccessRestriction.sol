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

contract AccessRestriction is Owned {
    string public someState;

    function AccessRestriction() public {
        owned();

        someState = "initial";
    }

    function updateSomeState(string _newState) public onlyOwner {
        someState = _newState;
    }
}