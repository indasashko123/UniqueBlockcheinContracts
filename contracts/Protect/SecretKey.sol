// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SecretKey 
{
    address private _keyOwner;
    constructor()  
    {
        _keyOwner = msg.sender;
        CurrentKey = Key
        ({
            Set : false,
            AddressKey : address(0)
        });
    }
    struct Key
    {
        bool Set;
        address AddressKey;
    }
   Key private CurrentKey;


   function Set(address _addressKey) external payable
   {
      require(!CurrentKey.Set, "1");
      CurrentKey = Key
      ({
        Set : true,
        AddressKey : _addressKey
      });
   }
   function Change(address newAddress) public payable
   {
       CurrentKey.AddressKey = newAddress;
   }

    modifier Pass()
    {
    require(CurrentKey.AddressKey == msg.sender, "1");
        _;
    }
}