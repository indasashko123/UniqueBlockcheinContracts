// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IUserStorage
{
   function AddUser(address userAddress, address Ref, address key) external payable;
   function AddReferal(address userAddress, address key) external payable;
   
   
   
   
   function IsUserExist(address addr) external view returns(bool);
   function IsUserExistById(uint id) external view returns (bool);
   function GetReferrer(address userAddress) external view returns (address);
   function GetUserByAddress (address userAddress) external view returns (uint, address,uint);
   function GetUserById(uint id) external view returns (uint, address,uint);
   function GetMembersCount() external view returns(uint);
   function GetUserIdByAddress(address adr) external view returns(uint);
   function GetUserAddressById(uint userId) external view returns (address);
}