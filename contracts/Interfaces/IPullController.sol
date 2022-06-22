// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IPullController 
{
    function BuyTicket(address userAddress, uint ticketCost, address key) external payable;
    function AddMemberReferalRewards(uint value, uint UserId, address key) external payable;
    function AddMemberRewards(uint value, uint UserId, address key) external payable;




    function GetRewardableLines() external view returns(uint[] memory);
    function IsPullExist(uint id) external view returns (bool);
    function GetTicketCountOnPull(uint pullId) external view returns(uint);
    function GetPullCrondFindingSum(uint pullId)  external view returns (uint);
    function GetTicketInfo(uint pullId, uint ticketNumber) external view returns(address,uint,uint);
}