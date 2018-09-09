pragma solidity ^0.4.24;

import "./safe_math.sol";

contract DelayedExecutor
{
    using SafeMath for uint;

    address public owner;
    address public backupAddress;
    uint256 public inactivePeriod;
    uint256 public expirationDate;
    uint256 public bounty;

    bool public dead;

    constructor(
        address _owner,
        address _backupAddress,
        uint256 _inactivePeriod,
        uint256 _bounty)
        public
    {
        owner = _owner;
        backupAddress = _backupAddress;
        inactivePeriod = _inactivePeriod;
        bounty = _bounty;

        expirationDate = block.timestamp.add(inactivePeriod);

        assert(owner != address(0));
        assert(backupAddress != address(0));
        assert(bounty > 0);
    }

    function () public payable
    {
        require(!dead, "Contract is closed");

        if (expired())
        {
            uint balansLeft = address(this).balance.sub(bounty);
            msg.sender.transfer(bounty);
            backupAddress.transfer(balansLeft);
            dead = true;
        }
        else if (msg.sender == owner)
        {
            expirationDate = block.timestamp.add(inactivePeriod);
        }
    }

    function expired ()
        public
        view
        returns (bool isExpired)
    {
        return expirationDate > block.timestamp;
    }
}