pragma solidity ^0.4.18;

contract Ownable {
    // オーナー
    address public owner;

    // オーナーチェック
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    // コンストラクタ
    function Ownable() public {
        owner = msg.sender;
    }

    // オーナー変更
    function changeOwner(address _newOwner) public onlyOwner {
        owner = _newOwner;
    }
}

// 破棄用コントラクト
contract Mortal is Ownable {
    // コントラクトの破棄して、etherをownerへ送る
    function kill() public onlyOwner {
        selfdestruct(owner);
    }
}

// オークション用コントラクト
contract Auction is Mortal {

    bool public stopped;                  // オークション停止制御
    uint public deadline;                  // 締め切り
    bool public ended;                     // 終了しているかどうか
    address public highestBidder;   // 最高提示アドレス
    uint public highestBid;              // 最高提示額
    address public organizer;          // 主催者
    mapping (address => uint) public biddersBalance; // 入札者の残高マップ

    // オークション停止チェック
    modifier isStopped() {
        // 停止されてない場合
        require(!stopped);
        _;
    }

    // コンストラクタ
    function Auction(uint _duration, address _organizer) public payable {

        // 締め切りを設定（Unixtime）
        deadline = now + _duration;
        // 主催者の設定
        organizer = _organizer;

        stopped = false;
        ended = false;
        highestBidder = msg.sender;
        highestBid = 0;
    }

    // 入札処理
    function bid() public payable isStopped {
        // キャンペーンが終わってない場合
        require(!ended);
        // 入札受付終了時間を過ぎていない場合
        require(now < deadline);
        // bidが現在の最高額より大きい場合
        require(msg.value > highestBid);

        // 現在の最高額と提示者アドレスの退避
        biddersBalance[highestBidder] += highestBid;

        // 最高額と提示者アドレスの更新
        highestBid = msg.value;
        highestBidder = msg.sender;
    }

    // オークション終了処理
    function closeAuction() public onlyOwner {
        // キャンペーンが終わってない場合
        require(!ended);

        // オークションを終了
        ended = true;

        // 主催者に最高額のetherを送金
        organizer.transfer(highestBid);
    }

    // 返金処理
    function withdraw() external {
        // 返金額が0より大きい場合に処理
        require(biddersBalance[msg.sender] > 0);

        // 返金額の退避
        uint refundAmount = biddersBalance[msg.sender];

        // 返金額の更新
        biddersBalance[msg.sender] = 0;

        // 返金
        msg.sender.transfer(refundAmount);
    }

    // 停止フラグの制御
    function toggleCircuit(bool _stopped) public onlyOwner {
        stopped = _stopped;
    }
}

