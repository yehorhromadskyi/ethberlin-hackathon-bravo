pragma solidity ^0.4.24;

contract DelayedExecutor
{
    address public backupAddress;
    uint public bounty;
    uint public expirationTime;

    constructor(
        address _backupAddress, 
        uint _bounty, 
        uint _expirationTime)
    {
        backupAddress = _backupAddress;
        bounty = _bounty;
        expirationTime = _expirationTime;

        // assert(bounty > 0);
    }
}