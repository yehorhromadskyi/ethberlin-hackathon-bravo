pragma solidity ^0.4.24;

contract DelayedExecutor
{
    address public backupAddress;
    uint256 public inactivePeriod;
    uint256 public bounty;
    uint256 public lastActivity;

    bool public isAlive;

    constructor(
        address _backupAddress,
        uint256 _inactivePeriod,
        uint256 _bounty)
        public
    {
        backupAddress = _backupAddress;
        inactivePeriod = _inactivePeriod;
        bounty = _bounty;

        assert(bounty > 0);
    }
}