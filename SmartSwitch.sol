pragma solidity ^0.4.18;

contract SmartSwitch {

    // スイッチの構造体
    struct Switch {
        address addr;    // 利用者のアドレス
        uint endTime;   // 利用終了時間
        bool status;       // 利用可能ステータス
    }

    address public owner;
    address public iot;

    mapping (uint => Switch) public switches;   // Switchを格納するマップ

    uint public numPaid;  // 支払いが行われた回数

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier onlyIoT() {
        require(msg.sender == iot);
        _;
    }

    // コストラクタ
    function SmartSwitch(address _iot) public {
        owner = msg.sender;
        iot = _iot;
        numPaid = 0;
    }

    // 支払い時の処理
    function payToSwitch() public payable {
        require(msg.value == 1000000000000000000);

        Switch storage s = switches[numPaid++];
        s.addr = msg.sender;
        s.endTime = now + 300;
        s.status = true;
    }

    // ステータスを変更する処理
    function updateStatus(uint _index) public onlyIoT{
        require(switches[_index].addr != 0);
        require(now > switches[_index].endTime);

        switches[_index].status = false;
    }

    // 支払われたetherを引き出す処理
    function withdrawFunds() public onlyOwner {
        owner.transfer(address(this).balance);
    }

    // コントラクトの破棄
    function kill() public onlyOwner {
        selfdestruct(owner);
    }


}