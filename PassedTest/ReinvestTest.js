
const  {expect} = require("chai");
const { BigNumber } = require("ethers");
const {ethers} = require ("hardhat");

describe("Reinvest Tests", function ()
{
    let acc1;let acc2;let acc3;let acc4;let acc5;let acc6;let acc7; let acc8;let acc9;
    let acc10;let acc11;let acc12;let acc13;let acc14;let acc15;let acc16;
    let owner;
    let key;

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

   it("BuyTable 100 Rewards to full pull", async function()
   {
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
    let pull = await view.GetStructure(1);

    expect(pull[3][0]).to.eq(2);
    expect(pull[4][0]).to.eq(ethers.utils.parseEther("7.556"));
    expect(pull[3][1]).to.eq(3);
    expect(pull[4][1]).to.eq(ethers.utils.parseEther("2.444"));
    expect(pull[0]).to.eq(ethers.utils.parseEther("10"));
    expect(pull[1]).to.eq(ethers.utils.parseEther("10"));

    let rewardPull = await reinvest.RewardToPull(1, {value : ethers.utils.parseEther("100")})
    await rewardPull.wait();

    let user  = await view.GetFullUserInfo(acc1.address);
    let user2  = await view.GetFullUserInfo(acc2.address);
     
    expect(user[3][3]).to.eq(ethers.utils.parseEther("45.336"));
    expect(user[3][4]).to.eq(ethers.utils.parseEther("1.17312"));
    expect(user2[3][3]).to.eq(ethers.utils.parseEther("13.49088"));

    expect(user[3][2]).to.eq(ethers.utils.parseEther("30.224"));
    expect(user2[3][2]).to.eq(ethers.utils.parseEther("9.776"));
    
    const balance0ETH = await ethers.provider.getBalance(reinvestAddress);
    });



    it("BuyTable 100 + 200 Rewards to full pull", async function()
   {
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

    let rewardPull = await reinvest.RewardToPull(1, {value : ethers.utils.parseEther("100")})
    await rewardPull.wait();

    let rewardPull2 = await reinvest.RewardToPull(1, {value : ethers.utils.parseEther("200")})
    await rewardPull2.wait();

    let user  = await view.GetFullUserInfo(acc1.address);
    let user2  = await view.GetFullUserInfo(acc2.address);
     
    expect(user[3][3]).to.eq(ethers.utils.parseEther("136.008"));
    expect(user[3][4]).to.eq(ethers.utils.parseEther("3.51936"));
    expect(user2[3][3]).to.eq(ethers.utils.parseEther("40.47264"));

    expect(user[3][2]).to.eq(ethers.utils.parseEther("90.672"));
    expect(user2[3][2]).to.eq(ethers.utils.parseEther("29.328"));

    const balance0ETH = await ethers.provider.getBalance(reinvestAddress);
    expect(balance0ETH).to.eq(ethers.utils.parseEther("120"))
    });


    it("BuyTable 100 Rewards + Reinvest to full pull", async function()
    {
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
 
     let rewardPull = await reinvest.RewardToPull(1, {value : ethers.utils.parseEther("100")})
     await rewardPull.wait();
 
     let user  = await view.GetFullUserInfo(acc1.address);
     let user2  = await view.GetFullUserInfo(acc2.address);
 
     expect(user[3][2]).to.eq(ethers.utils.parseEther("30.224"));
     expect(user2[3][2]).to.eq(ethers.utils.parseEther("9.776"));

     let tx111 = await matrix.connect(acc3).BuyTable(1, 1, {value :  ethers.utils.parseEther("0.04")});
     await tx111.wait();
     let tx112 = await matrix.connect(acc4).BuyTable(1, 1, {value :  ethers.utils.parseEther("0.04")});
     await tx112.wait();
     let tx113 = await matrix.connect(acc5).BuyTable(1, 1, {value :  ethers.utils.parseEther("0.04")});
     await tx113.wait();
     let tx114 = await matrix.connect(acc6).BuyTable(1, 1, {value :  ethers.utils.parseEther("0.04")});
     await tx114.wait();
     let tx115 = await matrix.connect(acc7).BuyTable(1, 1, {value :  ethers.utils.parseEther("0.04")});
     await tx115.wait();
     let tx116 = await matrix.connect(acc8).BuyTable(1, 1, {value :  ethers.utils.parseEther("0.04")});
     await tx116.wait();
     let tx117 = await matrix.connect(acc9).BuyTable(1, 1, {value :  ethers.utils.parseEther("0.04")});
     await tx117.wait();
     let tx118 = await matrix.connect(acc10).BuyTable(1, 1, {value :  ethers.utils.parseEther("0.04")});
     await tx118.wait();
     let tx119 = await matrix.connect(acc11).BuyTable(1, 1, {value :  ethers.utils.parseEther("0.04")});
     await tx119.wait();
     
     let userTablesBefore = await view.GetUserLevels(2);
    expect(userTablesBefore[0][1]).to.eq(false);
    expect(userTablesBefore[1][1]).to.eq(0);
    const balance0ETH = await ethers.provider.getBalance(reinvestAddress);
    expect(balance0ETH).to.eq(ethers.utils.parseEther("40"))
    let tx1010 = await reinvest.connect(acc1).ReinvestTable(1, acc1.address);
    await tx1010.wait();
    
    let userTables = await view.GetUserLevels(2);
    expect(userTables[0][1]).to.eq(true);
    expect(userTables[1][1]).to.eq(3);
    const balance0ETHNew = await ethers.provider.getBalance(reinvestAddress);
    let balacnsReduced = false;
    if (balance0ETHNew < ethers.utils.parseEther("40") && balance0ETHNew >= ethers.utils.parseEther("39.9"))
    {
        balacnsReduced =true;
    }
    let userDep  = await view.GetFullUserInfo(acc1.address);
    expect(userDep[3][2]).to.eq(ethers.utils.parseEther("30.184"));
    expect(balacnsReduced).to.eq(true);
    });
});