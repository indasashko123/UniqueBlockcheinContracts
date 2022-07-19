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

   it("Change Table controller", async function()
   {
       let ownerId = await view.GetUserId(owner.address);
       expect(ownerId).to.eq(1);
       let tx = await matrix.connect(acc1).BuyTable(1, 1, {value :  ethers.utils.parseEther("0.04")});
       await tx.wait();
       let tx2 = await matrix.connect(acc2).BuyTable(1, 1, {value : ethers.utils.parseEther("0.04")});
       await tx2.wait();
       let tx3 = await matrix.connect(acc3).BuyTable(1, 1, {value :  ethers.utils.parseEther("0.04")});
       await tx3.wait();
       
       let u1 = await view.GetUserLevels(2);
       let u2 = await view.GetUserLevels(3);
       let u3 = await view.GetUserLevels(4);

       let uC1 = await tableController.GetUserLevels(2);
       let uC2 = await tableController.GetUserLevels(3);
       let uC3 = await tableController.GetUserLevels(4);

       expect(u1[1][1]).to.eq(uC1[1][1]);
       expect(u2[1][1]).to.eq(uC2[1][1]);
       expect(u3[1][1]).to.eq(uC3[1][1]);

        const TableController2 = await ethers.getContractFactory("TableControllerV1", owner);
        tableController2 = await TableController2.deploy(tableStorageAddres ,userStorageAddres );
        await tableController2.deployed();
        tableControllerAddres2 = tableController2.address;
        await tableStorage.Change(tableControllerAddres2);


        let changeTh = await matrix.ChangeTableStorage(tableControllerAddres2);
        await changeTh.wait();

        let reg1 = await userController.Register(acc4.address, 2);
        await reg1.wait();

        let regUserId = await view.GetUserId(acc4.address);

        let thadd = await tableController2.AddWhiteNotFull(regUserId, 5, acc4.address, 5);
        await thadd.wait();

        let newData = await view.GetUserLevels(regUserId);
    

        let QT = await tableController2.GetTablesQueue(1);

        expect(QT.length).to.eq(8);
        expect(QT[0]).to.eq('0x0000000000000000000000000000000000000000');
        expect(QT[1]).to.eq('0x0000000000000000000000000000000000000000');
        expect(QT[2]).to.eq('0x0000000000000000000000000000000000000000');
        expect(QT[3]).to.eq(acc2.address);
        expect(QT[4]).to.eq(acc1.address);
        expect(QT[5]).to.eq(acc3.address);
        expect(QT[6]).to.eq(owner.address);
        expect(QT[7]).to.eq(acc4.address);
   });
});



