
const  {expect} = require("chai");
const { BigNumber } = require("ethers");
const {ethers} = require ("hardhat");

describe("Reinvest Tests", function ()
{
    let acc1;let acc2;let acc3;let acc4;let acc5;let acc6;let acc7; let acc8;let acc9;
    let acc10;let acc11;let acc12;let acc13;let acc14;let acc15;let acc16;
    let owner;
    let key;

    let userStorageAddres;
    let userControllerAddres;
    let tableStorageAddres;
    let tableControllerAddres;
    let pullStorageAddres;
    let pullControllerAddres;
    let matrixAddress;
    let viewAddres;
    beforeEach(async function()
    {
       [acc1,acc2,acc3,acc4, acc5,acc6,acc7,acc8,acc9,acc10,
        acc11,acc12, acc13,acc14,acc15, acc16, owner, key
       ] = await ethers.getSigners();


        const UserStorage = await ethers.getContractFactory("UserStorage", owner);
        userStorage = await UserStorage.deploy();
        await userStorage.deployed();
        userStorageAddres = userStorage.address;
     
        const UserController = await ethers.getContractFactory("UserController", owner);
        userController = await UserController.deploy( userStorageAddres );
        await userController.deployed();
        userControllerAddres = userController.address;
    
        const TableStorage = await ethers.getContractFactory("TableStorage", owner);
        tableStorage = await TableStorage.deploy();
        await tableStorage.deployed();
        tableStorageAddres = tableStorage.address;

        const TableController = await ethers.getContractFactory("TableController", owner);
        tableController = await TableController.deploy(tableStorageAddres ,userStorageAddres );
        await tableController.deployed();
        tableControllerAddres = tableController.address;
    
        const PullStorage = await ethers.getContractFactory("PullStorage", owner);
        pullStorage = await PullStorage.deploy(ethers.utils.parseEther("10"));
        await pullStorage.deployed();
        pullStorageAddres = pullStorage.address;
     
        const PullController = await ethers.getContractFactory("PullController", owner);
        pullController = await PullController.deploy(pullStorageAddres, userStorageAddres);
        await pullController.deployed();
        pullControllerAddres = pullController.address;

        

        const DepositeStorage = await ethers.getContractFactory("DepositeStorage", owner);
        depositeStorage = await DepositeStorage.deploy();
        await depositeStorage.deployed();
        depositeStorageAddres = depositeStorage.address;
     
        const DepositeController = await ethers.getContractFactory("DepositeController", owner);
        depositeController = await DepositeController.deploy(depositeStorageAddres);
        await depositeController.deployed();
        depositeControllerAddres = depositeController.address;

        const Matrix = await ethers.getContractFactory("MatrixGame", owner);
        matrix = await Matrix.deploy(userControllerAddres, pullControllerAddres, tableControllerAddres, acc16.address);
        await matrix.deployed();
        matrixAddress = matrix.address;

        const Reinvest = await ethers.getContractFactory("Reinvest", owner);
        reinvest = await Reinvest.deploy(pullControllerAddres, userControllerAddres,  tableControllerAddres, matrixAddress, depositeControllerAddres);
        await reinvest.deployed();
        reinvestAddress = reinvest.address;

        const View = await ethers.getContractFactory("View", owner);
        view = await View.deploy(userControllerAddres,  tableControllerAddres, pullControllerAddres, depositeControllerAddres);
        await view.deployed();
        viewAddres = view.address;
    });




   it("BuyTable2 to full pull", async function()
   {
    
  /*
    0 ether,    
    0.04 ether, 
    0.07 ether, 
    0.12 ether,  
    0.2 ether, 
    0.35 ether,  
    0.6 ether, 
    1.3 ether,  
    2.1 ether,
    3.3 ether,
    4.7 ether,
    6 ether,
    8 ether,
    11 ether,
    14 ether,
    16 ether,
    20 ether
*/
    let tx = await matrix.connect(acc1).BuyTable(1, 1, {value :  ethers.utils.parseEther("0.04")});
    await tx.wait();
    let tx1 = await matrix.connect(acc1).BuyTable(2, 1, {value :  ethers.utils.parseEther("0.07")});
    await tx1.wait();
    let tx2 = await matrix.connect(acc1).BuyTable(3, 1, {value :  ethers.utils.parseEther("0.12")});
    await tx2.wait();
    let tx3 = await matrix.connect(acc1).BuyTable(4, 1, {value :  ethers.utils.parseEther("0.2")});
    await tx3.wait();
    let tx4 = await matrix.connect(acc1).BuyTable(5, 1, {value :  ethers.utils.parseEther("0.35")});
    await tx4.wait();
    let tx5 = await matrix.connect(acc1).BuyTable(6, 1, {value :  ethers.utils.parseEther("0.6")});
    await tx5.wait();
    let tx6 = await matrix.connect(acc1).BuyTable(7, 1, {value :  ethers.utils.parseEther("1.3")});
    await tx6.wait();
    let tx7 = await matrix.connect(acc1).BuyTable(8, 1, {value :  ethers.utils.parseEther("2.1")});
    await tx7.wait();
    let tx8 = await matrix.connect(acc1).BuyTable(9, 1, {value :  ethers.utils.parseEther("3.3")});
    await tx8.wait();
    let tx9 = await matrix.connect(acc1).BuyTable(10, 1, {value :  ethers.utils.parseEther("4.7")});
    await tx9.wait();
    let tx10 = await matrix.connect(acc1).BuyTable(11, 1, {value :  ethers.utils.parseEther("6")});
    await tx10.wait();
    let tx11 = await matrix.connect(acc1).BuyTable(12, 1, {value :  ethers.utils.parseEther("8")});
    await tx11.wait();
    let tx12 = await matrix.connect(acc1).BuyTable(13, 1, {value :  ethers.utils.parseEther("11")});
    await tx12.wait();
/// 37.78 (12.22)

    let tx13 = await matrix.connect(acc2).BuyTable(1, 2, {value :  ethers.utils.parseEther("0.04")});
    await tx13.wait();
    let tx14 = await matrix.connect(acc2).BuyTable(2, 2, {value :  ethers.utils.parseEther("0.07")});
    await tx14.wait();
    let tx15 = await matrix.connect(acc2).BuyTable(3, 2, {value :  ethers.utils.parseEther("0.12")});
    await tx15.wait();
    let tx16 = await matrix.connect(acc2).BuyTable(4, 2, {value :  ethers.utils.parseEther("0.2")});
    await tx16.wait();
    let tx17 = await matrix.connect(acc2).BuyTable(5, 2, {value :  ethers.utils.parseEther("0.35")});
    await tx17.wait();
    let tx18 = await matrix.connect(acc2).BuyTable(6, 2, {value :  ethers.utils.parseEther("0.6")});
    await tx18.wait();
    let tx19 = await matrix.connect(acc2).BuyTable(7, 2, {value :  ethers.utils.parseEther("1.3")});   
    await tx19.wait();
    let tx20 = await matrix.connect(acc2).BuyTable(8, 2, {value :  ethers.utils.parseEther("2.1")});
    await tx20.wait();
    let tx21 = await matrix.connect(acc2).BuyTable(9, 2, {value :  ethers.utils.parseEther("3.3")});
    await tx21.wait();
    let tx22 = await matrix.connect(acc2).BuyTable(10, 2, {value :  ethers.utils.parseEther("4.7")});
    await tx22.wait();

    /// 12.78

    let pull =await view.GetPullById(1);
    expect(pull[1]).to.eq(ethers.utils.parseEther("10"));
    expect(pull[2]).to.eq(ethers.utils.parseEther("10"));
    expect(pull[3]).to.eq(ethers.utils.parseEther("0"));

    let rewardPull = await reinvest.RewardToPull(1, {value : "100000000000000000000"})
    await rewardPull.wait();

    let user  = await view.GetFullUserInfo(acc1.address);
    let user2  = await view.GetFullUserInfo(acc1.address);
     
    let ticket1 = await view.GetTicketInfo(1,1);
    let ticket2 = await view.GetTicketInfo(1,2);

    console.log(ticket1[1].toString());
    console.log(ticket2[1].toString());

    console.log("Reward from pull" + " " +user[3][3].toString());
    console.log("Reward from ref"+" "+user[3][4].toString());
    console.log("Rewar from pull User2"+" "+user2[3][3].toString());
    console.log("Deposite 1"+ " " + user[3][2]);
    console.log("Deposite 2"+ " " + user2[3][2]);
   });

    
   

 
});