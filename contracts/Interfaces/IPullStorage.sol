// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IPullStorage
{
    /////   PAYABLE
    function SetMember(uint UserId ) external;
    function SetTicket(uint value, uint userId ) external;
    function SetCurrentPullValue(uint value )  external;
    function AddNewPull( ) external;
    function AddMemberReferalRewards(uint value, uint UserId ) external;
    function AddMemberRewards(uint value, uint UserId ) external;
    function AddToTicket(uint userId, uint value) external;
   
      ///// VIEW
     function GetPullsCount() external view returns (uint); 
     function TicketExistOnPull (uint userId, uint pullId) external view returns(bool);  
     function IsPullExist(uint id) external view returns (bool);
     function GetStatistic() external view returns(uint,uint,uint);
     function IsMemberExist(uint id) external view returns(bool);
     function GetTicketCountOnPull(uint pullId) external view returns(uint);
     function GetTicketInfo(uint pullId, uint ticketNumber) external view returns(uint, uint);
     function GetPullCollectedSum(uint pullId)  external view returns (uint);
     function GetCurrentPull() external view returns(uint,uint,uint);
     function GetMember(uint id ) external view returns(uint,uint);
     function GetTicketsByPullId(uint pullId) external view returns(uint[]memory,uint[]memory);
     function GetLastCurrentPullSum() external view returns (uint);
     function GetPull(uint pullId) external view returns(uint,uint,uint);
     function GetStructure(uint pullId) external view returns(uint,uint,uint, uint[] memory, uint[] memory);
}