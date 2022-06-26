// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IKeyStorage.sol";
import "../../Protect/SecretKey.sol";


contract KeyStorage is SecretKey, IKeyStorage
{
    uint value;
    constructor()
    {
        value = 1;
    }
    function ADD(uint _value) public override payable Pass()
    {
        value += _value;
    }
    function REDUSE(uint _value) public override payable Pass()
    {
        require(value > _value, "1");
        value -= _value;
    }

    function GET() public override view returns(uint)
    {
        return (value);
    }
    function SetKey() public override payable
    {
        this.Set(msg.sender);
    }
}