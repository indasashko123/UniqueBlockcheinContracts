const  {expect} = require("chai");
const { BigNumber } = require("ethers");
const {ethers} = require ("hardhat");

describe("User Tests", function ()
{
    let acc1;let acc2;let acc3;let acc4;let acc5;let acc6;let acc7; let acc8;let acc9;
    let acc10;let acc11;let acc12;let acc13;let acc14;let acc15;let acc16;
    let owner;
    let key;

    let userControllerAddres;
    beforeEach(async function()
    {
       [acc1,acc2,acc3,acc4, acc5,acc6,acc7,acc8,acc9,acc10,
        acc11,acc12, acc13,acc14,acc15, acc16, owner, key
       ] = await ethers.getSigners();
    
        /// STORAGE
        const UserStorage = await ethers.getContractFactory("UserStorage", owner);
        userStorage = await UserStorage.deploy(key.address );
        await userStorage.deployed();
        userStorageAddres = userStorage.address;

        /// CONTROLLER
        const UserController = await ethers.getContractFactory("UserController", owner);
        userController = await UserController.deploy(key.address, userStorageAddres);
        await userController.deployed();
        userControllerAddres = userController.address;
    });


   it("Reg", async function()
   {
    let tx = await userController.Register(key.address, acc1.address, 1 );
    await tx.wait();
    let Acc1Adrress = await userStorage.GetUserAddressById(2);
    expect(Acc1Adrress).to.eq(acc1.address);
   });

   it("Reg 2", async function()
   {
    let tx = await userController.Register(key.address, acc1.address, 1 );
    await tx.wait();
    let tx2 = await userController.Register(key.address, acc2.address, 1 );
    await tx2.wait();
    let tx3 = await userController.Register(key.address, acc3.address, 1);
    await tx3.wait();
    let Acc1Adrress = await userStorage.GetUserAddressById(2);
    let Acc2Adrress = await userStorage.GetUserAddressById(3);
    let Acc3Adrress = await userStorage.GetUserAddressById(4);
    expect(Acc1Adrress).to.eq(acc1.address);
    expect(Acc2Adrress).to.eq(acc2.address);
    expect(Acc3Adrress).to.eq(acc3.address);
   }
   );


   it("Reg 3", async function()
   {
    let tx = await userController.Register(key.address, acc1.address, 1 );
    await tx.wait();
    let tx2 = await userController.Register(key.address, acc2.address, 1 );
    await tx2.wait();
    let tx3 = await userController.Register(key.address, acc3.address, 1);
    await tx3.wait();
    let tx4 = await userController.Register(key.address, acc2.address, 1);
    await tx4.wait();
    let tx5 = await userController.Register(key.address, acc3.address, 1);
    await tx5.wait();
    let Acc1Adrress = await userStorage.GetUserAddressById(2);
    let Acc2Adrress = await userStorage.GetUserAddressById(3);
    let Acc3Adrress = await userStorage.GetUserAddressById(4);
    let Acc22Adrress = await userStorage.GetUserAddressById(5);
    let Acc33Adrress = await userStorage.GetUserAddressById(6);
    let memebers = await userController.GetMembersCount();


    expect(memebers).to.eq(4);
    expect(Acc1Adrress).to.eq(acc1.address);
    expect(Acc2Adrress).to.eq(acc2.address);
    expect(Acc3Adrress).to.eq(acc3.address);
    expect(Acc22Adrress).to.eq("0x0000000000000000000000000000000000000000");
    expect(Acc33Adrress).to.eq("0x0000000000000000000000000000000000000000");
   }
   );
   

   it("Referer", async function()
   {
    let tx = await userController.Register(key.address, acc1.address, 1);
    await tx.wait();
    let u1Id = await userController.GetUserIdByAddress(acc1.address);

    let tx2 = await userController.Register(key.address, acc2.address, u1Id);
    await tx2.wait();
    let u2Id = await userController.GetUserIdByAddress(acc2.address);

    let tx3 = await userController.Register(key.address, acc3.address, u2Id);
    await tx3.wait();
    let u3Id = await userController.GetUserIdByAddress(acc3.address);

    let tx4 = await userController.Register(key.address, acc4.address, u3Id);
    await tx4.wait();
    let u4Id = await userController.GetUserIdByAddress(acc4.address);

    let tx5 = await userController.Register(key.address, acc5.address, u4Id);
    await tx5.wait();


    let Acc1Adrress = await userController.GetUserAddressById(2);
    let Acc2Adrress = await userController.GetUserAddressById(3);
    let Acc3Adrress = await userController.GetUserAddressById(4);
    let Acc4Adrress = await userController.GetUserAddressById(5);
    let Acc5Adrress = await userController.GetUserAddressById(6);
    let memebers = await userController.GetMembersCount();
    let user1 = await userController.GetUserByAddress(acc1.address);
    let user2 = await userController.GetUserByAddress(acc2.address);
    let user3 = await userController.GetUserByAddress(acc3.address);
    let user4 = await userController.GetUserByAddress(acc4.address);
    let user5 = await userController.GetUserByAddress(acc5.address);
    let userById = await userController.GetUserById(u3Id);
    let ref1 = await userController.GetReferrer(acc1.address);
    let ref2 = await userController.GetReferrer(acc2.address);
    let ref3 = await userController.GetReferrer(acc3.address);
 
    expect(ref1).to.eq(owner.address);
    expect(ref2).to.eq(acc1.address);
    expect(ref3).to.eq(acc2.address);

    expect(userById[0]).to.eq(user3[0]);
    expect(userById[1]).to.eq(user3[1]);
    expect(userById[2]).to.eq(user3[2]);

    expect(user1[2]).to.eq(4);
    expect(user2[2]).to.eq(3);
    expect(user3[2]).to.eq(2);
    expect(user4[2]).to.eq(1);
    expect(user5[2]).to.eq(0);

    expect(user1[1]).to.eq(owner.address);
    expect(user2[1]).to.eq(acc1.address);
    expect(user3[1]).to.eq(acc2.address);
    expect(user4[1]).to.eq(acc3.address);
    expect(user5[1]).to.eq(acc4.address);



    expect(memebers).to.eq(6);
    expect(Acc1Adrress).to.eq(acc1.address);
    expect(Acc2Adrress).to.eq(acc2.address);
    expect(Acc3Adrress).to.eq(acc3.address);
    expect(Acc4Adrress).to.eq(acc4.address);
    expect(Acc5Adrress).to.eq(acc5.address);
   }
   );


   it("Ref percents", async function()
   {

    let pers = [0, 8,  4, 3, 2, 1,  1,  1  ];
    let Percents1 = await userController.GetReferalPercent(1);
    let Percents2 = await userController.GetReferalPercent(2);
    let Percents3 = await userController.GetReferalPercent(3);
    let Percents4 = await userController.GetReferalPercent(4);
    let Percents5 = await userController.GetReferalPercent(5);
    let Percents6 = await userController.GetReferalPercent(6);
    let Percents7 = await userController.GetReferalPercent(7);
    
    expect(Percents1).to.eq([pers[1]]);
    expect(Percents2).to.eq([pers[2]]);
    expect(Percents3).to.eq([pers[3]]);
    expect(Percents4).to.eq([pers[4]]);
    expect(Percents5).to.eq([pers[5]]);
    expect(Percents6).to.eq([pers[6]]);
    expect(Percents7).to.eq([pers[7]]);
   });



   it("Ref percents 1", async function()
   {

    let pers = [0, 8,  4, 3, 2, 1,  1,  1  ];
    let Percents = await userController.GetReferalPercentArray();
    let lines = await userController.GetReferalLines();

    expect(lines).to.eq(7);
    expect(Percents[1]).to.eq(pers[1]);
    expect(Percents[2]).to.eq(pers[2]);
    expect(Percents[3]).to.eq(pers[3]);
    expect(Percents[4]).to.eq(pers[4]);
    expect(Percents[5]).to.eq(pers[5]);
    expect(Percents[6]).to.eq(pers[6]);
    expect(Percents[7]).to.eq(pers[7]);
   });
});

 
/* 
Register(address key, address userAddress, uint refId)


*/