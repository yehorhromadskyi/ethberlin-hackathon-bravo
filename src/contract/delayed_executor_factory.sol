pragma solidity ^0.4.24;

import "./delayed_executor.sol";

contract DelayedExecutorFactory
{
    address[] public executors;

    function getExecutorsCount () 
        public
        view
        returns (uint256)
    {
        return executors.length;
    }

    function createExecutor (address backupAddress, uint inactivePeriod, uint bounty) 
        public
        returns (address)
    {
        address exe = address(new DelayedExecutor(backupAddress, inactivePeriod, bounty));

        executors.push(exe);

        return exe;
    }
}