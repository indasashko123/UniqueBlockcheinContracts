// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IUserController 
{
    function Register(address key, address userAddress, uint refId) external payable;

    function GetReferalPercent(uint line) external view returns(uint); 
    function GetReferalLines() external view returns(uint);
    function IsUserExist(address addr) external view returns(bool);
    function IsUserExistById(uint id) external view returns (bool);
    function GetUserByAddress(address userAddress) external view returns (uint, address,uint);
    function GetUserById(uint id) external view returns (uint, address,uint);
    function GetUserIdByAddress(address adr) external view returns(uint);
    function GetUserAddressById(uint userId) external view returns (address);
    function GetReferrer(address userAddress) external view returns (address);
    function GetMembersCount() external view returns(uint);
    function GetReferalPercentArray() external view returns(uint[] memory);
}
