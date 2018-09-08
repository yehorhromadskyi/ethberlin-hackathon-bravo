pragma solidity ^0.4.24;

contract DelayedExecutor
{
    address public backupAddress;
    uint256 public bounty;
    uint256 public expirationDate;

    bool public isAlive;

    constructor(
        address _backupAddress, 
        uint256 _bounty, 
        uint256 _expirationDate)
    {
        backupAddress = _backupAddress;
        bounty = _bounty;
        expirationDate = _expirationDate;

        // assert(bounty > 0);
    }
}