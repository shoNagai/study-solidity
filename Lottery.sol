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

// 宝くじコントラクト
contract Lottery is Mortal {

    // 応募者
    struct Applicant {
        address addr;
        uint amount;
    }

    bool public stopped;    // 宝くじ停止制御
    bool public ended;       // 終了しフラグ
    uint public deadline;   // 締め切り
    mapping (uint => Applicant) public applicants;   // 応募者を管理
    uint public numApplicants;  // 応募者数を管理
    address public winnerAddress;  // 当選者アドレス
    uint public winnerAmout; // 当選金額
    uint public winnerInt;  // 抽選者int
    uint public timestamp;  // タイムスタンプ
    mapping (address => uint) public applicantBalance; // 応募者の返金マップ

    // 宝くじ停止チェック
    modifier isStopped() {
        // 停止されてない場合
        require(!stopped);
        _;
    }

    // コンストラクタ
    function Lottery(uint _duration) public {

        // 締め切りを設定（Unixtime）
        deadline = now + _duration;

        numApplicants = 0;
        stopped = false;
        ended = false;
    }

    // 応募処理
    function enter() public payable isStopped {

        // 応募期間を過ぎていない場合
        require(now <= deadline);

        // 抽選が終わってない場合
        require(!ended);

        // 既に応募済みの場合は処理終了
        for(uint i = 0; i < numApplicants; i++){
            require(applicants[i].addr != msg.sender);
        }

        // 応募者を追加
        Applicant storage app = applicants[numApplicants++];
        app.addr = msg.sender;
        app.amount = msg.value;

    }

    // 抽選処理
    function hold() public onlyOwner {
        
        // 応募期間を過ぎた場合
        require(now > deadline);

        // 終了フラグを立てる
        ended = true;

        // 応募が3件以上の場合
        if (numApplicants >= 3) {

            // ブロック生成時のタイムスタンプ
            timestamp = block.timestamp;
            winnerInt = timestamp % 3;

            winnerAddress = applicants[winnerInt].addr;

            for(uint i = 0; i < numApplicants; i++){
                winnerAmout += applicants[i].amount;
            }

        } else { // 応募が3件未満の場合

            // 返金マップの作成
            for(uint j = 0; j < numApplicants; j++){
                applicantBalance[applicants[j].addr] = applicants[j].amount;
            }

        }
    }

    // 返金処理
    function withdraw() external {
        // 返金額が0より大きい場合に処理
        require(applicantBalance[msg.sender] > 0);

        // 返金額の退避
        uint refundAmount = applicantBalance[msg.sender];

        // 返金額の更新
        applicantBalance[msg.sender] = 0;

        // 返金
        msg.sender.transfer(refundAmount);
    }

    // 停止フラグの制御
    function toggleCircuit(bool _stopped) public onlyOwner {
        stopped = _stopped;
    }
}