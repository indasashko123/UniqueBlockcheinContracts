// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import '../Interfaces/IUserStorage.sol';
import "../Protect/SecretKey.sol";
contract UserStorage is IUserStorage, SecretKey
{
    
   address payable _owner;

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

    constructor ()
    {
       _owner = payable(msg.sender);
       User memory user = User 
       ({
        id : newUserId++,
        refererAddress : _owner,
        referrals : 0
       });
       userByAddres[_owner] = user;
       userById[user.id] = user;
       userAddressById[user.id] = _owner;
    }  

                                    /// Payable
   function AddUser(address userAddress, address ref) override public payable Pass()
   {
       if (!IsUserExist(userAddress))
       {
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
      
   }
   function AddReferal(address userAddress) override public payable Pass()
   {  
       uint userId = userByAddres[userAddress].id;
       userByAddres[userAddress].referrals++;
       userById[userId].referrals++;
   }
   function SetKey() override public payable
   {
    this.Set(msg.sender);
   }
   function ChangeKey(address newKey) public payable 
    {
        require(msg.sender == _owner, "2");
        this.Change(newKey);
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