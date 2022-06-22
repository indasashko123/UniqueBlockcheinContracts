// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '../Interfaces/IUserStorage.sol';

contract UserStorage is IUserStorage
{
    
   address payable _owner;
   mapping (address => bool) private SecretKey;

    struct User
    {
       uint id;
       address refererAddress;
       uint referrals;
    }
    
    mapping (uint => User) userById;               /// user id  => User
    mapping (address => User) userByAddres;        /// user address => User
    mapping (uint => address) userAddressById;     ///  UserID => user adres
    uint newUserId = 1; 

    constructor (address key)
    {
       SecretKey[key] = true;
       _owner = payable(msg.sender);
       User memory user = User 
       ({
        id : newUserId++,
        refererAddress : address(0),
        referrals : 0
       });
       userByAddres[_owner] = user;
       userById[user.id] = user;
       userAddressById[user.id] = _owner;
    }  

                                    /// Payable
   function AddUser(address userAddress, address ref, address key) override public payable 
   {
       require(SecretKey[key], "1");  // TEST
       require(!IsUserExist(userAddress),"User is registered now");
       if (!IsUserExist(ref))
       {
           ref = _owner;
       }
       User memory newUser = User
       ({
        id : newUserId++,
        refererAddress : ref,
        referrals : 0   
       });
       userByAddres[userAddress] = newUser;
       userById[newUser.id] = newUser;
       userAddressById[newUser.id] = userAddress;
   }
   function AddReferal(address userAddress, address key) override public payable   
   {
       require(SecretKey[key], "1");  // TEST
       userByAddres[userAddress].referrals ++;
   }

                                        /// VIEW
   function IsUserExist(address addr) override public view returns(bool)    
   {
      return userByAddres[addr].id != 0;
   }
   function IsUserExistById(uint id) override  public view returns (bool)
   {
       return userById[id].id != 0;
   }
   function GetReferrer(address userAddress) override public view returns (address)
    {
        return userByAddres[userAddress].refererAddress;
    }
   function GetUserByAddress (address userAddress) override public view returns (uint, address, uint)
   {
      User memory user = userByAddres[userAddress];
      return 
      (
        user.id,
        user.refererAddress,
        user.referrals
      );
   }
   function GetUserById(uint id) override public view returns (uint, address, uint)
   {
       User memory user = userById[id];
         return 
      (
        user.id,
        user.refererAddress,
        user.referrals
      );
   }
   function GetMembersCount() override public view returns(uint)
   {
       return newUserId-1;
   }
   function GetUserIdByAddress(address adr) override public view returns(uint)
   {
       return userByAddres[adr].id;
   }
   function GetUserAddressById(uint userId) override public view returns (address)
   {
       return userAddressById[userId];
   }




}