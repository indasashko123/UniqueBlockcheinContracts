
const  {expect} = require("chai");
const { BigNumber } = require("ethers");
const {ethers} = require ("hardhat");

describe("Game Tests", function ()
{
    let acc1;let acc2;let acc3;let acc4;let acc5;let acc6;let acc7; let acc8;let acc9;
    let acc10;let acc11;let acc12;let acc13;let acc14;let acc15;let acc16;
    let owner;

    let matrixAddress;
    let viewAddres;
    let reinvestAddress;
    beforeEach(async function()
    {
       [acc1,acc2,acc3,acc4, acc5,acc6,acc7,acc8,acc9,acc10,
        acc11,acc12, acc13,acc14,acc15, acc16, owner, key
       ] = await ethers.getSigners();

        const Matrix = await ethers.getContractFactory("MatrixGame", owner);
        matrix = await Matrix.deploy(acc16.address);
        await matrix.deployed();
        matrixAddress = matrix.address;
       
        let addreses = await matrix.GetContractaAddress();

        const Reinvest = await ethers.getContractFactory("Reinvest", owner);
        reinvest = await Reinvest.deploy(addreses[2], addreses[0],  addreses[1], matrixAddress);
        await reinvest.deployed();
        reinvestAddress = reinvest.address;

        let depositeAddress = await reinvest.GetDepositeAddress();

        const View = await ethers.getContractFactory("View", owner);
        view = await View.deploy(addreses[0],addreses[1],addreses[2],depositeAddress);
        await view.deployed();
        viewAddres = view.address;

    });




    it("Deploy", async function()
   {
    
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

   it("Add White List", async function()
   {
       let ownerId = await view.GetUserId(owner.address);
       expect(ownerId).to.eq(1);

       let regtx = await userController.Register(acc1.address, 1);
       await regtx.wait();

       let whiteId = await view.GetUserId(acc1.address);
       let queue = await tableController.GetTablesQueue(2);
       expect(whiteId).to.eq(2);
       expect(queue.length).to.eq(1);


       let tx = await tableController.AddWhite(whiteId,3,acc1.address);
       await tx.wait();
       
       let queueNew = await tableController.GetTablesQueue(2);
       expect(queueNew.length).to.eq(2);
       expect(queueNew[0]).to.eq(owner.address);
       expect(queueNew[1]).to.eq(acc1.address);
   });

   it("View Tables", async function()
   {
       let ownerId = await view.GetUserId(owner.address);
       expect(ownerId).to.eq(1);
       let tx = await matrix.connect(acc1).BuyTable(1, 1, {value :  ethers.utils.parseEther("0.04")});
       await tx.wait();
       let tx2 = await matrix.connect(acc2).BuyTable(1, 1, {value : ethers.utils.parseEther("0.04")});
       await tx2.wait();
       let tx3 = await matrix.connect(acc3).BuyTable(1, 1, {value :  ethers.utils.parseEther("0.04")});
       await tx3.wait();
       let tx4 = await matrix.connect(acc4).BuyTable(1, 1, {value : ethers.utils.parseEther("0.04")});
       await tx4.wait();
       let tx5 = await matrix.connect(acc5).BuyTable(1, 1, {value :  ethers.utils.parseEther("0.04")});
       await tx5.wait();
       let tx6 = await matrix.connect(acc6).BuyTable(1, 1, {value : ethers.utils.parseEther("0.04")});
       await tx6.wait();

       let tx7 = await matrix.connect(acc7).BuyTable(1, 1, {value :  ethers.utils.parseEther("0.04")});
       await tx7.wait();
       let tx8 = await matrix.connect(acc8).BuyTable(1, 1, {value : ethers.utils.parseEther("0.04")});
       await tx8.wait();
       let tx9 = await matrix.connect(acc9).BuyTable(1, 1, {value :  ethers.utils.parseEther("0.04")});
       await tx9.wait();
       let tx10 = await matrix.connect(acc10).BuyTable(1, 1, {value : ethers.utils.parseEther("0.04")});
       await tx10.wait();
       let tx11 = await matrix.connect(acc11).BuyTable(1, 1, {value :  ethers.utils.parseEther("0.04")});
       await tx11.wait();
       let tx12 = await matrix.connect(acc12).BuyTable(1, 1, {value : ethers.utils.parseEther("0.04")});
       await tx12.wait();

       let tx13 = await matrix.connect(acc13).BuyTable(1, 1, {value :  ethers.utils.parseEther("0.04")});
       await tx13.wait();
       let tx14 = await matrix.connect(acc14).BuyTable(1, 1, {value : ethers.utils.parseEther("0.04")});
       await tx14.wait();
       let tx15 = await matrix.connect(acc15).BuyTable(1, 1, {value :  ethers.utils.parseEther("0.04")});
       await tx15.wait();
       let tx16 = await matrix.connect(acc16).BuyTable(1, 1, {value : ethers.utils.parseEther("0.04")});
       await tx16.wait();

        

   
       let u1 = await view.GetUserLevels(2);
       let u2 = await view.GetUserLevels(3);
       let u3 = await view.GetUserLevels(4);
       let u4 = await view.GetUserLevels(5);
       let u5 = await view.GetUserLevels(6);
       let u6 = await view.GetUserLevels(7);
       let u7 = await view.GetUserLevels(8);
       let u8 = await view.GetUserLevels(9);
       let u9 = await view.GetUserLevels(10);
       let u10 = await view.GetUserLevels(11);
       let u11 = await view.GetUserLevels(12);
       let u12 = await view.GetUserLevels(13);
       let u13 = await view.GetUserLevels(14);
       let u14 = await view.GetUserLevels(15);
       let u15 = await view.GetUserLevels(16);
       let u16 = await view.GetUserLevels(17);
 
       
       let uC1 = await tableController.GetUserLevels(2);
       let uC2 = await tableController.GetUserLevels(3);
       let uC3 = await tableController.GetUserLevels(4);
       let uC4 = await tableController.GetUserLevels(5);
       let uC5 = await tableController.GetUserLevels(6);
       let uC6 = await tableController.GetUserLevels(7);
       let uC7 = await tableController.GetUserLevels(8);
       let uC8 = await tableController.GetUserLevels(9);
       let uC9 = await tableController.GetUserLevels(10);
       let uC10 = await tableController.GetUserLevels(11);
       let uC11 = await tableController.GetUserLevels(12);
       let uC12 = await tableController.GetUserLevels(13);
       let uC13 = await tableController.GetUserLevels(14);
       let uC14 = await tableController.GetUserLevels(15);
       let uC15 = await tableController.GetUserLevels(16);
       let uC16 = await tableController.GetUserLevels(17);

  
       expect(u1[1][1]).to.eq(uC1[1][1]);
       expect(u2[1][1]).to.eq(uC2[1][1]);
       expect(u3[1][1]).to.eq(uC3[1][1]);
       expect(u4[1][1]).to.eq(uC4[1][1]);
       expect(u5[1][1]).to.eq(uC5[1][1]);
       expect(u6[1][1]).to.eq(uC6[1][1]);

       let data = await view.GetData(acc1.address);
       
       extect(data[0]).to.eq(0);
       expect(data[1]).to.eq(1);


   });


});



