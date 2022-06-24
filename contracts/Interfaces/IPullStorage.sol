// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IPullStorage
{
    /////   PAYABLE
    function SetMember(uint UserId, address key) external payable ;
    function SetTicket(address userAdr, uint value, uint userId, address key) external payable;
    function SetCurrentPullValue(uint value, address key)  external payable ;
    function AddNewPull(address key) external payable ;
    function AddMemberReferalRewards(uint value, uint UserId, address key) external payable;
    function AddMemberRewards(uint value, uint UserId, address key) external payable;
    function AddMemberDeposite(uint userId, uint value, address key) external payable;


       ///// VIEW

     function IsPullExist(uint id) external view returns (bool);
     function GetStatistic() external view returns(uint,uint,uint);
     function IsMemberExist(uint id) external view returns(bool);
     function GetTicketCountOnPull(uint pullId) external view returns(uint);
     function GetTicketInfo(uint pullId, uint ticketNumber) external view returns(address,uint,uint);
     function GetPullCollectedSum(uint pullId)  external view returns (uint);
     function GetCurrentPull() external view returns(uint,uint,uint,uint);
     function GetMember(uint id ) external view returns(uint,uint,uint);
     function GetTicketByPullId(uint pullId) external view returns(address[] memory, uint[]memory,uint[]memory);
     function GetLastCurrentPullSum() external view returns (uint);
     function GetPull(uint pullId) external view returns(uint,uint,uint,uint);
}