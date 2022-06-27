const  {expect} = require("chai");
const { BigNumber } = require("ethers");
const {ethers} = require ("hardhat");

describe("User Tests", function ()
{
   let owner; let acc1;let acc2;let acc3;let acc4;let acc5;let acc6;let acc7; let acc8;let acc9;
   let acc10;let acc11;let acc12;let acc13;let acc14;let acc15;  let acc16;

    let userStorageAddres;
    beforeEach(async function()
    {
       [acc1,acc2,acc3,acc4, acc5,acc6,acc7,acc8,acc9,acc10,
        acc11,acc12, acc13,acc14,acc15, acc16, owner, key
       ] = await ethers.getSigners();
        const UserStorage = await ethers.getContractFactory("UserStorage", owner);
        userStorage = await UserStorage.deploy();
        await userStorage.deployed();
        userStorageAddres = userStorage.address;

        userStorage.SetKey();
    });




   it("UserAdd", async function()
   {
    let tx = await userStorage.AddUser(acc1.address, owner.address);
    await tx.wait();
    let Acc1Adrress = await userStorage.GetUserAddressById(2);
    expect(Acc1Adrress).to.eq(acc1.address);
   });


   it("User api", async function()
   {
    let tx = await userStorage.AddUser(acc1.address, owner.address);
    await tx.wait();
    let tx1 = await userStorage.AddReferal(acc1.address);
    await tx1.wait();
    let refs =await userStorage.GetUserByAddress(acc1.address);
    expect(refs[2]).to.eq(1);
   });


   it("User isRegistered", async function()
   {
      let tx = await userStorage.AddUser(acc1.address, owner.address);
      await tx.wait();
      let registerd = await userStorage.IsUserExist(acc1.address);
      let registerdAd = await userStorage.IsUserExistById(2);
      let registerd2 = await userStorage.IsUserExist(acc2.address);
      let registerdAd2 = await userStorage.IsUserExistById(3); 
      expect(registerd).to.eq(true);
      expect(registerdAd).to.eq(true);
      expect(registerd2).to.eq(false);
      expect(registerdAd2).to.eq(false);
   });


   it ("User getReferal", async function()
   {
      let tx = await userStorage.AddUser(acc1.address, owner.address);
      await tx.wait();
      let referal = await userStorage.GetReferrer(acc1.address);
      expect(referal).to.eq(owner.address);
   });


   it ("User API", async function()
   {
      let tx = await userStorage.AddUser(acc1.address, owner.address);
      await tx.wait();
      let userId = await userStorage.GetUserIdByAddress(acc1.address);
      let userAddress = await userStorage.GetUserAddressById(userId);
      let t1 = await userStorage.GetUserByAddress(userAddress);
      let t2 = await userStorage.GetUserById(userId);
      expect(await userStorage.GetMembersCount()).to.eq(2);
      expect(t1[1]).to.eq(t2[1]);
      expect(t1[2]).to.eq(t2[2]);
      expect(t1[0]).to.eq(t2[0]);

      let tx1 = await userStorage.AddUser(acc2.address, acc1.address);
      await tx1.wait();
      let userId2 = await userStorage.GetUserIdByAddress(acc2.address);
      let userAddress2 = await userStorage.GetUserAddressById(userId2);
      let t12 = await userStorage.GetUserByAddress(userAddress2);
      let t22 = await userStorage.GetUserById(userId2);
      expect(await userStorage.GetMembersCount()).to.eq(3);
      expect(t12[1]).to.eq(t22[1]);
      expect(t12[2]).to.eq(t22[2]);
      expect(t12[0]).to.eq(t22[0]);
   });

});
