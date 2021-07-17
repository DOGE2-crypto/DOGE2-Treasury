pragma solidity ^0.8.6;
//SPDX-License-Identifier: UNLICENSED

interface IERC20 {
    function transfer(address user, uint256 amount) external returns (bool);
}

contract TimelockDeposits {
  address payable public owner;
  uint256 public delay;

  struct timelockTransaction {
    address token;
    uint256 value;
    uint256 block;
    bool isExecuted;
    uint256 id;
  }
  timelockTransaction[] public transactions;
  
  event AddTransaction(address indexed token, uint256 value, uint256 block, uint256 indexed ID);
  event ExecuteTransaction(address indexed token, uint256 value, uint256 block, uint256 indexed ID);

  modifier onlyOwner {
    require(msg.sender == owner, 'Only owner');
    _;
  }

  constructor(address payable _owner, uint256 _delay) {
    owner = _owner;
    delay = _delay;
  }

  function requestWithdraw(uint256 _value) external onlyOwner {
    transactions.push(
        timelockTransaction(address(0), _value, block.number, false, transactions.length)
    );
    emit AddTransaction(address(0), _value, block.number, transactions.length - 1);
  }

  function requestWithdrawToken(address _token, uint _value) external onlyOwner {
    transactions.push(
        timelockTransaction(_token, _value, block.number, false, transactions.length)
    );
    emit AddTransaction(_token, _value, block.number, transactions.length - 1);
  }

  function executeWithdrawal(uint256 _ID) external onlyOwner {
    require(!transactions[_ID].isExecuted, 'Already executed');
    require(block.number - transactions[_ID].block > delay, 'Delay not satisfied');

    if (transactions[_ID].token == address(0)) owner.transfer(transactions[_ID].value);
    else IERC20(transactions[_ID].token).transfer(owner, transactions[_ID].value);
    
    transactions[_ID].isExecuted = true;

    emit ExecuteTransaction(transactions[_ID].token, transactions[_ID].value, block.number, transactions[_ID].id);
  }

  receive() external payable { } 
  fallback() external payable { }
}
