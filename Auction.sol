pragma solidity ^0.4.18;

contract Auction {
    address public highestBidder;  // 最高提示アドレス
    uint public highestBid;   // 最高提示額

    function Auction() public payable {
        highestBidder = msg.sender;
        highestBid = 0;
    }

    // bid関数
    function bid() public payable {
        // bidが現在の最高額より大きい場合のみ処理
        require(msg.value > highestBid);

        // 現在の最高額と提示者アドレスの退避
        uint refundAmount = highestBid;
        address currentHighestBidder = highestBidder;

        // 最高額と提示者アドレスの更新
        highestBid = msg.value;
        highestBidder = msg.sender;

        // 返金
        currentHighestBidder.transfer(refundAmount);
    }
}