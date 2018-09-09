pragma solidity ^0.4.24;

import "./delayed_executor.sol";

contract DelayedExecutorFactory
{
    address[] public executors;

    function getExecutorsCount () 
        public view returns (uint256 executorsCount)
    {
        return executors.length;
    }

    function createExecutor (
        address owner, 
        address backupAddress, 
        uint inactivePeriod, 
        uint bounty) 
        public returns (address newExecutorAddress)
    {
        address exe = address(new DelayedExecutor(
            owner, backupAddress, inactivePeriod, bounty));

        executors.push(exe);

        return exe;
    }
}