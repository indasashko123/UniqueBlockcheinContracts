// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IPullController 
{
    function BuyTicket(address userAddress, uint ticketCost) external payable;
    function AddMemberReferalRewards(uint value, uint UserId) external payable;
    function AddMemberRewards(uint value, uint UserId) external payable;

       ///// VIEW
    function GetRewardableLines() external view returns(uint[] memory);
    function GetMember(uint userId) external view returns(uint,uint,uint);
    function IsPullExist(uint id) external view returns (bool);
    function GetTicketCountOnPull(uint pullId) external view returns(uint);
    function GetPullCollectedSum(uint pullId)  external view returns (uint);
    function GetTicketInfo(uint pullId, uint ticketNumber) external view returns(address,uint,uint);
    function GetCurrentPull() external view returns(uint,uint,uint,uint);
    function GetPull(uint pullId) external view returns(uint,uint,uint,uint);
    function SetKey() external payable;
}