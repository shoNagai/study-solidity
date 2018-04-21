pragma solidity ^0.4.18;
// クラウドファンディング用コントラクト
contract CroudFunding {
    // 投資家
    struct Investor {
        address addr;
        uint amount;
    }

    address public owner;          // コントラクトのオーナー
    uint public numInvestors;    // 投資家数
    uint public deadline;            // 締め切り
    string public status;             // ステータス
    bool public ended;              // 終了しているかどうか
    uint public  minAmount;      //  最低金額
    uint public goalAmount;    // 目標額
    uint public totalAmount;    // 合計額
    mapping (uint => Investor) public investors;   // 投資家管理用のマップ

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    // コンストラクタ
    function CroudFunding(uint _duration, uint _goalAmount) public {
        owner = msg.sender;

        // 締め切りをUnixtimeで設定
        deadline = now + _duration;

        goalAmount = _goalAmount;
        status = "Funding";
        ended = false;

        numInvestors = 0;
        totalAmount = 0;
        minAmount = 0;
    }

    // 投資関数
    function fund() payable public {
        // キャンペーンが終わっていれば処理を中断
        require(!ended);
        // 最低金額より下または目標金額より多ければ中断
        require(minAmount <= msg.value && goalAmount >= msg.value);
        Investor storage inv = investors[numInvestors++];
        inv.addr = msg.sender;
        inv.amount = msg.value;
        totalAmount += inv.amount; 
    }

    // 最低金額を設定
    function setMinAmount(uint _minAmount) public onlyOwner {
        minAmount = _minAmount;
    }

    // 目標額を達成したか確認
    // また、キャンペーンの成功/失敗に応じたetherの送金を実施
    function checkGoalReached() public onlyOwner {
        // キャンペーンが終わっていれば処理を中断
        require(!ended);
        // 締め切り前の場合は処理を中断
        require(now >= deadline);
        if(totalAmount >= goalAmount) {     // キャンペーン成功の場合
            status = "Campaign Succeeded";
            ended = true;
            // オーナーにコントラクト内の全てのetherを送金
            owner.transfer(address(this).balance);
        }else {  // キャンペーン失敗の場合
            uint i = 0;
            status = "Campaign Failed";
            ended = true;
            // 投資家毎にetherを返金
            while(i <= numInvestors) {
                investors[i].addr.transfer(investors[i].amount);
                i++;
            }

        }
    }

    // コントラクトの破棄
    function kill() public onlyOwner {
        selfdestruct(owner);
    }

}