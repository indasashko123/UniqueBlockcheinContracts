const  {expect} = require("chai");
const { BigNumber } = require("ethers");
const {ethers} = require ("hardhat");

describe("User Tests", function ()
{
    let acc1;let acc2;let acc3;let acc4;let acc5;let acc6;let acc7; let acc8;let acc9;
    let acc10;let acc11;let acc12;let acc13;let acc14;let acc15;let acc16;
    let owner;
    let key;

    let tableStorageAddres;
    beforeEach(async function()
    {
       [acc1,acc2,acc3,acc4, acc5,acc6,acc7,acc8,acc9,acc10,
        acc11,acc12, acc13,acc14,acc15, acc16, owner, key
       ] = await ethers.getSigners();
        const TableStorage = await ethers.getContractFactory("TableStorage", owner);
        tableStorage = await TableStorage.deploy(key.address);
        await tableStorage.deployed();
        tableStorageAddres = tableStorage.address;

        
        const UserStorage = await ethers.getContractFactory("UserStorage", owner);
        userStorage = await UserStorage.deploy(key.address );
        await userStorage.deployed();
        userStorageAddres = userStorage.address;
        
        const UserController = await ethers.getContractFactory("UserController", owner);
        userController = await UserController.deploy(key.address, userStorageAddres);
        await userController.deployed();
        userControllerAddres = userController.address;



        const TableController = await ethers.getContractFactory("TableController", owner);
        tableController = await TableController.deploy(key.address, tableStorageAddres, userStorageAddres);
        await tableController.deployed();
    });




   it("Add Table", async function()
   {
    let tx = await tableStorage.AddTable(1, 3, acc1.address, 2 ,key.address);
    await tx.wait();
    let first = await tableStorage.GetFirstTableAddress(1);
    let act = await tableStorage.IsTableActive(2, 1);
    let actOw = await tableStorage.IsTableActive(1, 1);

    expect(act).to.eq(true);
    expect(actOw).to.eq(true);
    expect(first).to.eq(owner.address);
   });
    
   it("Get tablesCount", async function()
   {
    let tx = await tableController.BuyTable(1,  acc1.address ,key.address);
    await tx.wait();
    let tx1 = await tableController.BuyTable(2,  acc1.address ,key.address);
    await tx1.wait();
    let tx2 = await tableController.BuyTable(3,  acc1.address ,key.address);
    await tx2.wait();
    let tx3 = await tableController.BuyTable(4, acc1.address,key.address);
    await tx3.wait();
    
    let txSome = await tableController.BuyTable(4,  acc2.address ,key.address);
    await txSome.wait();

    let tx4 = await tableController.BuyTable(5,  acc1.address,key.address);
    await tx4.wait();
    let tx5 = await tableController.BuyTable(6,  acc1.address,key.address);
    await tx5.wait();
    let tx6 = await tableController.BuyTable(7, acc1.address,key.address);
    await tx6.wait();
    let tx7 = await tableController.BuyTable(8, acc1.address ,key.address);
    await tx7.wait();
    let tx8 = await tableController.BuyTable(9,  acc1.address ,key.address);
    await tx8.wait();
    let tx9 = await tableController.BuyTable(10, acc1.address ,key.address);
    await tx9.wait();
    let tx10 = await tableController.BuyTable(11,  acc1.address ,key.address);
    await tx10.wait();
    let tx11 = await tableController.BuyTable(12,  acc1.address ,key.address);
    await tx11.wait();
    let tx12 = await tableController.BuyTable(13,  acc1.address ,key.address);
    await tx12.wait();
    let tx13 = await tableController.BuyTable(14,  acc1.address ,key.address);
    await tx13.wait();
    let tx14 = await tableController.BuyTable(15,  acc1.address ,key.address);
    await tx14.wait();
    let tx15 = await tableController.BuyTable(16,  acc1.address ,key.address);
    await tx15.wait();

    let count = await tableController.GetTablesCount();

    let HE1 = await tableController.GetHeadIndex(1);
    let HE2 = await tableController.GetHeadIndex(2);
    let HE3 = await tableController.GetHeadIndex(3);
    let HE4 = await tableController.GetHeadIndex(4);

    let TQ1 = await tableController.GetTablesQueue(1);
    let TQ4 = await tableController.GetTablesQueue(4);

    expect(HE1).to.eq(1);
    expect(HE2).to.eq(1);
    expect(HE3).to.eq(1);
    expect(HE4).to.eq(2);

    expect(TQ1.length).to.eq(3);
    expect(TQ4.length).to.eq(5);

    expect(count[1]).to.eq(2);
    expect(count[2]).to.eq(2);
    expect(count[3]).to.eq(2);
    expect(count[4]).to.eq(3);

   });

   
   it("Deactivate unnecessary Table", async function()
   {


        let reg1 = await userController.Register(key.address, acc1.address, 1);
        await reg1.wait();
        let tx1 = await tableController.BuyTable(1,  acc1.address ,key.address);
        await tx1.wait();
        let reg2 = await userController.Register(key.address, acc2.address, 1);
        await reg2.wait();
        let tx2 = await tableController.BuyTable(1,  acc2.address ,key.address);
        await tx2.wait();
        let reg3 = await userController.Register(key.address, acc3.address, 1);
        await reg3.wait();
        let tx3 = await tableController.BuyTable(1,  acc3.address ,key.address);
        await tx3.wait();
        let reg4 = await userController.Register(key.address, acc4.address, 1);
        await reg4.wait();
        let tx4 = await tableController.BuyTable(1,  acc4.address ,key.address);
        await tx4.wait();
        
        let count4 = await tableController.GetTablesCount();
        expect(count4[1]).to.eq(5);

        let reg5 = await userController.Register(key.address, acc5.address, 1);
        await reg5.wait();
        let tx5 = await tableController.BuyTable(1,  acc5.address ,key.address);
        await tx5.wait();
        let reg6 = await userController.Register(key.address, acc6.address, 1);
        await reg6.wait();
        let tx6 = await tableController.BuyTable(1,  acc6.address ,key.address);
        await tx6.wait();
        let reg7 = await userController.Register(key.address, acc7.address, 1);
        await reg7.wait();
        let tx7 = await tableController.BuyTable(1,  acc7.address ,key.address);
        await tx7.wait();
        let reg8 = await userController.Register(key.address, acc8.address, 1);
        await reg8.wait();
        let tx8 = await tableController.BuyTable(1,  acc8.address ,key.address);
        await tx8.wait();
        let reg9 = await userController.Register(key.address, acc9.address, 1);
        await reg9.wait();
        let tx9 = await tableController.BuyTable(1,  acc9.address ,key.address);
        await tx9.wait();
        let reg10 = await userController.Register(key.address, acc10.address, 1);
        await reg10.wait();
        let tx10 = await tableController.BuyTable(1,  acc10.address ,key.address);
        await tx10.wait();

        let count10 = await tableController.GetTablesCount();
        expect(count10[1]).to.eq(11);
        let HE10 = await tableController.GetHeadIndex(1);
        expect(HE10).to.eq(10);
        let TQ10 = await tableController.GetTablesQueue(1);
        expect(TQ10.length).to.eq(21);

        let reg11 = await userController.Register(key.address, acc11.address, 1);
        await reg11.wait();
        let tx11 = await tableController.BuyTable(1,  acc11.address ,key.address);
        await tx11.wait();

        let acc1Id = await userController.GetUserIdByAddress(acc1.address);
        let act = await tableController.IsTableActive(acc1Id,1);
        expect(act).to.eq(false);
   
        let HE1 = await tableController.GetHeadIndex(1);
        expect(HE1).to.eq(11);

        let TQ1 = await tableController.GetTablesQueue(1);
        expect(TQ1.length).to.eq(22);

        let count = await tableController.GetTablesCount();
        expect(count[1]).to.eq(11);


        let firstAddress = await tableController.GetFirstTableAddress(1);
        expect(acc6.address).to.eq(firstAddress);
   });


   it("Add Rewards", async function()
   {
    let tx = await tableController.AddRewardSum(1, 1, 100000000, key.address);
    await tx.wait();

    let tx1 = await tableController.AddReferalPayout(1, 200000000, key.address);
    await tx1.wait();

    let rew1 = await tableController.GetUserRewards(1);

    expect(rew1[0]).to.eq(100000000);
    expect(rew1[1]).to.eq(200000000);

    let tx2 = await tableController.AddRewardSum(1, 1, 100000000, key.address);
    await tx2.wait();

    let tx3 = await tableController.AddReferalPayout(1, 200000000, key.address);
    await tx3.wait();

    let rew = await tableController.GetUserRewards(1);



    expect(rew[0]).to.eq(200000000);
    expect(rew[1]).to.eq(400000000);
   });


   it("Get place", async function()
   {
    let reg1 = await userController.Register(key.address, acc1.address, 1);
    await reg1.wait();
    let tx1 = await tableController.BuyTable(1,  acc1.address ,key.address);
    await tx1.wait();

    let place1 = await tableController.GetPlaceInQueue(2, acc1.address, 1);
    expect(place1[0]).to.eq(1);
    expect(place1[1]).to.eq(2);

    
    let reg2 = await userController.Register(key.address, acc2.address, 1);
    await reg2.wait();
    let tx2 = await tableController.BuyTable(1,  acc2.address ,key.address);
    await tx2.wait();

    let place2 = await tableController.GetPlaceInQueue(2, acc1.address, 1);
    expect(place2[0]).to.eq(3);
    expect(place2[1]).to.eq(3);

    let reg3 = await userController.Register(key.address, acc3.address, 1);
    await reg3.wait();
    let tx3 = await tableController.BuyTable(1,  acc3.address ,key.address);
    await tx3.wait();

    let place3 = await tableController.GetPlaceInQueue(2, acc1.address, 1);
    expect(place3[0]).to.eq(2);
    expect(place3[1]).to.eq(4);

    let reg4 = await userController.Register(key.address, acc4.address, 1);
    await reg4.wait();
    let tx4 = await tableController.BuyTable(1,  acc4.address ,key.address);
    await tx4.wait();

    let place4 = await tableController.GetPlaceInQueue(2, acc1.address, 1);
    expect(place4[0]).to.eq(1);
    expect(place4[1]).to.eq(5);

    let stat = await tableController.GetGlobalStatistic();
    expect(stat).to.eq(20);

   });


});





