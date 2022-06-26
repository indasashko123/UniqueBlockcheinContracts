const  {expect} = require("chai");
const { BigNumber } = require("ethers");
const {ethers} = require ("hardhat");

describe("Pull controller Tests", function ()
{
    let owner;let acc1;let acc2;let acc3;let acc4;let acc5;let acc6;let acc7; let acc8;let acc9;
    let acc10;let acc11;let acc12;let acc13;let acc14;let acc15;let acc16;
    let key;

    let pullStorageAddres;
    let userStorageAddres;
    let pullControllerAddres;
    beforeEach(async function()
    {
       [acc1,acc2,acc3,acc4, acc5,acc6,acc7,acc8,acc9,acc10,
        acc11,acc12, acc13,acc14,acc15, acc16, owner, key
       ] = await ethers.getSigners();


        const PullStorage = await ethers.getContractFactory("PullStorage", owner);
        pullStorage = await PullStorage.deploy(1000 );
        await pullStorage.deployed();
        pullStorageAddres = pullStorage.address;

        const UserStorage = await ethers.getContractFactory("UserStorage", owner);
        userStorage = await UserStorage.deploy();
        await userStorage.deployed();
        userStorageAddres = userStorage.address;

        const UserController = await ethers.getContractFactory("UserController", owner)
        userController = await UserController.deploy(userStorageAddres);
        await userController.deployed();
        userController.SetKey();

        const PullController = await ethers.getContractFactory("PullController", owner);
        pullController = await PullController.deploy( pullStorageAddres, userStorageAddres );
        await pullController.deployed();
        pullControllerAddres = pullController.address;
        pullController.SetKey();
        userStorage.SetKey();

    });




   it("Buy ticket", async function()
   {
    let userReg = await userController.Register(acc1.address, 1);
    await userReg.wait();
    let tx = await pullController.BuyTicket(acc1.address, 100);
    await tx.wait();
    let inf =await pullController.GetTicketInfo(1,1);
    expect(inf[0]).to.eq(acc1.address);
    expect(inf[1]).to.eq(100);
    expect(inf[2]).to.eq(2);

    let userReg1 = await userController.Register(acc2.address,1);
    await userReg1.wait();
    let tx1 = await pullController.BuyTicket(acc2.address, 200);
    await tx1.wait();

    let inf1 = await pullController.GetTicketInfo(1,2);
    expect(inf1[0]).to.eq(acc2.address);
    expect(inf1[1]).to.eq(200);
    expect(inf1[2]).to.eq(3);
   });


   it("Complite pull", async function()
   {
    let userReg = await userController.Register(acc1.address, 1);
    await userReg.wait();
    let tx = await pullController.BuyTicket(acc1.address, 500);
    await tx.wait();

    let userReg1 = await userController.Register(acc2.address, 1);
    await userReg1.wait();
    let tx1 = await pullController.BuyTicket(acc2.address, 600);
    await tx1.wait();

    let existPull = await pullController.IsPullExist(2);
    expect(existPull).to.eq(true);

    let pull = await pullController.GetPull(2);
    expect(pull[0]).to.eq(2);
    expect(pull[1]).to.eq(1000);
    expect(pull[2]).to.eq(100);
    expect(pull[3]).to.eq(900);

    let ticketes = await pullController.GetTicketCountOnPull(1);
    expect(ticketes).to.eq(2);
    let ticketes1 = await pullController.GetTicketCountOnPull(2);
    expect(ticketes1).to.eq(1);

    let ticketeinfo1 = await pullController.GetTicketInfo(1,1);
    let ticketeinfo2 = await pullController.GetTicketInfo(1,2);
    let ticketeinfo3 = await pullController.GetTicketInfo(2,1);
    
   expect(ticketeinfo1[0]).to.eq(acc1.address);
   expect(ticketeinfo1[1]).to.eq(500);
   expect(ticketeinfo1[2]).to.eq(2);

   expect(ticketeinfo2[0]).to.eq(acc2.address);
   expect(ticketeinfo2[1]).to.eq(500);
   expect(ticketeinfo2[2]).to.eq(3);

   expect(ticketeinfo3[0]).to.eq(acc2.address);
   expect(ticketeinfo3[1]).to.eq(100);
   expect(ticketeinfo3[2]).to.eq(3);

    let userReg2 = await userController.Register(acc3.address,1);
    await userReg2.wait();
    let userReg3 = await userController.Register(acc4.address, 1);
    await userReg3.wait();

    let tx3 = await pullController.BuyTicket(acc3.address, 400);
    await tx3.wait();
    let tx4 = await pullController.BuyTicket(acc4.address, 500);
    await tx4.wait();
    
    let ticketes3 = await pullController.GetTicketCountOnPull(3);
    expect(ticketes3).to.eq(0);

    let pull3 = await pullController.GetPull(3);
    expect(pull3[0]).to.eq(3);
    expect(pull3[1]).to.eq(1000);
    expect(pull3[2]).to.eq(0);
    expect(pull3[3]).to.eq(1000);

   });
});
