pragma solidity ^0.4.18;

contract CircuitBreaker {
    bool public stopped;
    address public owner;
    bytes16 public message;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier isStopped() {
        require(!stopped);
        _;
    }

    function CircuitBreaker() public {
        owner = msg.sender;
        stopped = false;
    }

    function toggleCircuit(bool _stopped) public onlyOwner {
        stopped = _stopped;
    }

    function setMessage(bytes16 _message) public isStopped {
        message = _message;
    }
}