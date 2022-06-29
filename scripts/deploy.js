const hre = require("hardhat");
const ethers = hre.ethers;

let owner;
let reinvest;
async function main ()
{  
    [owner,reinvest]= await ethers.getSigners();
    
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
        matrix = await Matrix.deploy(userControllerAddres, pullControllerAddres, tableControllerAddres, reinvest.address);
        await matrix.deployed();
        matrixAddress = matrix.address;
        console.log("Matrix contract address -- " + "" +matrixAddress);

        const Reinvest = await ethers.getContractFactory("Reinvest", owner);
        reinvest = await Reinvest.deploy(pullControllerAddres, userControllerAddres,  tableControllerAddres, matrixAddress, depositeControllerAddres);
        await reinvest.deployed();
        reinvestAddress = reinvest.address;
        console.log("Reinvest contract address -- " + "" +reinvestAddress);
    
        const View = await ethers.getContractFactory("View", owner);
        view = await View.deploy(userControllerAddres,  tableControllerAddres, pullControllerAddres, depositeControllerAddres);
        await view.deployed();
        viewAddres = view.address;
        console.log("view contract address -- " + "" +viewAddres);
}


main()
   .then(() => 
        {
        process.exit(0);
        })
   .catch((error)=> 
        {
        console.error(error);
        process.exit(1);
        });