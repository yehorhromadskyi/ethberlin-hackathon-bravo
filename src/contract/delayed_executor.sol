pragma solidity ^0.4.24;

contract DelayedExecutor
{
    address public backupAddress;
    uint256 public expirationDate;
    uint256 public bounty;

    bool public isAlive;

    constructor(
        address _backupAddress,
        uint256 _expirationDate,
        uint256 _bounty)
    {
        backupAddress = _backupAddress;
        expirationDate = _expirationDate;
        bounty = _bounty;

        // assert(bounty > 0);
    }

    
}