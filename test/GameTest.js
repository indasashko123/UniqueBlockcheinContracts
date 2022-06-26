
const  {expect} = require("chai");
const { BigNumber } = require("ethers");
const {ethers} = require ("hardhat");

describe("Game Tests", function ()
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

        const Matrix = await ethers.getContractFactory("MatrixGame", owner);
        matrix = await Matrix.deploy(userControllerAddres, pullControllerAddres, tableControllerAddres, acc16.address);
        await matrix.deployed();
        matrixAddress = matrix.address;
       



        const DepositeStorage = await ethers.getContractFactory("DepositeStorage", owner);
        depositeStorage = await DepositeStorage.deploy();
        await depositeStorage.deployed();
        depositeStorageAddres = depositeStorage.address;
     
        const DepositeController = await ethers.getContractFactory("DepositeController", owner);
        depositeController = await DepositeController.deploy(depositeStorageAddres);
        await depositeController.deployed();
        depositeControllerAddres = depositeController.address;

        const View = await ethers.getContractFactory("View", owner);
        view = await View.deploy(userControllerAddres,  tableControllerAddres, pullControllerAddres, depositeControllerAddres);
        await view.deployed();
        viewAddres = view.address;
    });




   it("BuyTable", async function()
   {
    
    let tx = await matrix.connect(acc1).BuyTable(1, 1, {value :  ethers.utils.parseEther("0.04")});
    await tx.wait();
    let user = await view.GetFullUserInfo(acc1.address);
    let userId = user[0];

    expect(user[0]).to.eq(2);
    expect(user[1]).to.eq(owner.address);
    expect(user[2]).to.eq(0);
    expect(user[3][0]).to.eq(0);
    expect(user[3][1]).to.eq(0);
    expect(user[3][2]).to.eq(0);


    let userTables = await view.GetUserLevels(userId)
    expect(userTables[0][1]).to.eq(true);
    expect(userTables[1][1]).to.eq(3);
    expect(userTables[2][1]).to.eq(1);
    expect(userTables[3][1]).to.eq(0);
   });


   it("BuyTable2", async function()
   {
    
    let tx = await matrix.connect(acc1).BuyTable(1, 1, {value :  ethers.utils.parseEther("0.04")});
    await tx.wait();
    let tx2 = await matrix.connect(acc2).BuyTable(1, 2, {value : ethers.utils.parseEther("0.04")});
    await tx2.wait();
    let user = await view.GetFullUserInfo(acc1.address);
    let user2 = await view.GetFullUserInfo(acc2.address);
    let userId = user[0];
    let userId2 = user2[0];

    expect(user[2]).to.eq(1);
    expect(user[3][0]).to.eq(ethers.utils.parseEther("0.024"));
    expect(user[3][1]).to.eq(ethers.utils.parseEther("0.0032"));

    let userTables = await view.GetUserLevels(userId)
    expect(userTables[0][1]).to.eq(true);
    expect(userTables[1][1]).to.eq(2);
    expect(userTables[2][1]).to.eq(1);
    expect(userTables[3][1]).to.eq(ethers.utils.parseEther("0.024"));

    let tx3 = await matrix.connect(acc3).BuyTable(1, 3, {value : ethers.utils.parseEther("0.04")});
    await tx3.wait();
     
    let user1new1 = await view.GetFullUserInfo(acc1.address);
    expect(user1new1[2]).to.eq(2);
    expect(user1new1[3][0]).to.eq(ethers.utils.parseEther("0.024"));
    expect(user1new1[3][1]).to.eq(ethers.utils.parseEther("0.0048"));
    

    let ac1ballance = await (await ethers.provider.getBalance(acc1.address));
    let ac2ballance = await (await ethers.provider.getBalance(acc2.address));
    let ac3ballance = await (await ethers.provider.getBalance(acc3.address));
    let owner1ballance = await (await ethers.provider.getBalance(owner.address));
    let contballance = await matrix.getContractBalance();
   });

 
});
///  ID / REFERER / REFERALS COUNT / [ Table Rewards , Referal Rewards , USerDEposite] 
///  Tables Active  /  Payouts   /  activation Times   /   Table rewards   


