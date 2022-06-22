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
        const UserController = await ethers.getContractFactory("UserController", owner);
        userController = await UserController.deploy(key.address );
        await userController.deployed();
        userControllerAddres = userController.address;
    });


   it("UserAdd", async function()
   {
    let tx = await userStorage.AddUser(acc1.address, owner.address, key.address);
    await tx.wait();
    let Acc1Adrress = await userStorage.GetUserAddressById(2);
    expect(Acc1Adrress).to.eq(acc1.address);
   });



   
});