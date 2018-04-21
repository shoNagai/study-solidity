pragma solidity ^0.4.18;

contract NameRegistry {

    // コントラクトの構造体
    struct Contract {
        address owner;
        address addr;
        bytes32 description;
    }

    // 登録済みのレコード数
    uint public numContracts;

    mapping (bytes32 => Contract) public contracts;

    // コストラクタ
    function NameRegistry() public {
        numContracts = 0;
    }

    modifier onlyOwner(bytes32 _name) {
        require(contracts[_name].owner == msg.sender);
        _;
    } 

    // コントラクトを登録
    function register(bytes32 _name) public returns (bool) {
        if(contracts[_name].owner == 0) {
            Contract storage con = contracts[_name];
            con.owner = msg.sender;
            numContracts++;
            return true;
        }else {
            return false;
        }
    }

    // コントラクトを削除
    function unregister(bytes32 _name) public returns (bool) {
        if(contracts[_name].owner == msg.sender) {
            contracts[_name].owner = 0;
            numContracts--;
            return true;
        }else {
            return false;
        }
    }

    // コントラクトのオーナーを変更
    function changeOwner(bytes32 _name, address _newOwner) public onlyOwner(_name) {
        contracts[_name].owner = _newOwner;
    }

    // コントラクトのオーナーの取得
    function getOwner(bytes32 _name) constant public returns (address) {
        return contracts[_name].owner;
    }

    // コントラクトのアドレスを設定
    function setAddr(bytes32 _name, address _addr) public onlyOwner(_name) {
        contracts[_name].addr = _addr;
    }

    // コントラクトのアドレスを取得
    function getAddr(bytes32 _name) constant public returns (address) {
        return contracts[_name].addr;
    }

    // コントラクトの説明を設定
    function setDescription(bytes32 _name, bytes32 _description) public onlyOwner(_name) {
        contracts[_name].description = _description;
    }

    // コントラクトの説明を取得
    function getDescription(bytes32 _name) constant public returns (bytes32) {
        return contracts[_name].description;
    }
}