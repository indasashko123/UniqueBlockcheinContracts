const  {expect} = require("chai");
const { BigNumber } = require("ethers");
const {ethers} = require ("hardhat");

describe("Key Tests", function ()
{
    let acc1;let acc2;let acc3;let acc4;let acc5;let acc6;let acc7; let acc8;let acc9;
    let acc10;let acc11;let acc12;let acc13;let acc14;let acc15;let acc16;
    let owner;
    let key;

    let KSAdd;
    let KCAdd;
    beforeEach(async function()
    {
       [acc1,acc2,acc3,acc4, acc5,acc6,acc7,acc8,acc9,acc10,
        acc11,acc12, acc13,acc14,acc15, acc16, owner, key
       ] = await ethers.getSigners();

        const KS = await ethers.getContractFactory("KeyStorage", owner);
        kS = await KS.deploy();
        await kS.deployed();
        KSAdd = kS.address;

        const KC = await ethers.getContractFactory("KeyCont", owner);
        kC = await KC.deploy( KSAdd);
        await kC.deployed();
        KCAdd = kC.address;
    });




   it("Deploy", async function()
   {




    let tx = await kC.ADD(1);
    await tx.wait();
    let answer = await kC.GET();
    expect(answer).to.eq(2);


   });


  

});