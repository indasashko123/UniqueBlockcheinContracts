// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IKeyStorage.sol";


contract KeyCont 
{
    IKeyStorage keyStorage;
    constructor(address keyStorageAddress)
    {
        keyStorage = IKeyStorage(keyStorageAddress);
        keyStorage.SetKey();
    }
    function ADD(uint _value) public payable 
    {
       keyStorage.ADD(_value);
    }
    function REDUSE(uint _value) public payable 
    {
        keyStorage.REDUSE(_value);
    }

    function GET() public view returns(uint)
    {
        return keyStorage.GET();
    }

}