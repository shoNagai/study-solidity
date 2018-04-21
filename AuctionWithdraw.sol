pragma solidity ^0.4.18;

contract AuctionWithdraw {
    address public highestBidder;  // 最高提示アドレス
    uint public highestBid;   // 最高提示額
    mapping (address => uint) public usersBalance;

    function Auction() public payable {
        highestBidder = msg.sender;
        highestBid = 0;
    }

    // bid関数
    function bid() public payable {
        // bidが現在の最高額より大きい場合のみ処理
        require(msg.value > highestBid);

        // 現在の最高額と提示者アドレスの退避
        usersBalance[highestBidder] += highestBid;

        // 最高額と提示者アドレスの更新
        highestBid = msg.value;
        highestBidder = msg.sender;
    }

    function withdraw() external {
        // 返金額が0より大きい場合に処理
        require(usersBalance[msg.sender] > 0);

        // 返金額の退避
        uint refundAmount = usersBalance[msg.sender];

        // 返金額の更新
        usersBalance[msg.sender] = 0;

        // 返金
        msg.sender.transfer(refundAmount);
    }
}