const web3 = new Web3('http://localhost:8545');
const gasBuy = 900000;

ViewAbi = [
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "userAd",
          "type": "address"
        },
        {
          "internalType": "address",
          "name": "tableAd",
          "type": "address"
        },
        {
          "internalType": "address",
          "name": "pullAd",
          "type": "address"
        },
        {
          "internalType": "address",
          "name": "depAd",
          "type": "address"
        }
      ],
      "stateMutability": "nonpayable",
      "type": "constructor"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "userAddress",
          "type": "address"
        }
      ],
      "name": "GetFullUserInfo",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        },
        {
          "internalType": "address",
          "name": "",
          "type": "address"
        },
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        },
        {
          "internalType": "uint256[]",
          "name": "",
          "type": "uint256[]"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "pullId",
          "type": "uint256"
        }
      ],
      "name": "GetPullById",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        },
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        },
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        },
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "userId",
          "type": "uint256"
        },
        {
          "internalType": "address",
          "name": "userAddress",
          "type": "address"
        },
        {
          "internalType": "uint8",
          "name": "tableNumber",
          "type": "uint8"
        }
      ],
      "name": "GetTablePosition",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        },
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "pullId",
          "type": "uint256"
        }
      ],
      "name": "GetTicketCount",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "pullId",
          "type": "uint256"
        },
        {
          "internalType": "uint256",
          "name": "ticketNumber",
          "type": "uint256"
        }
      ],
      "name": "GetTicketInfo",
      "outputs": [
        {
          "internalType": "address",
          "name": "",
          "type": "address"
        },
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        },
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "userId",
          "type": "uint256"
        }
      ],
      "name": "GetUserLevels",
      "outputs": [
        {
          "internalType": "bool[]",
          "name": "",
          "type": "bool[]"
        },
        {
          "internalType": "uint16[]",
          "name": "",
          "type": "uint16[]"
        },
        {
          "internalType": "uint16[]",
          "name": "",
          "type": "uint16[]"
        },
        {
          "internalType": "uint256[]",
          "name": "",
          "type": "uint256[]"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    }
  ];
MatrixAbi = [
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "UserControllerAddress",
          "type": "address"
        },
        {
          "internalType": "address",
          "name": "PullControllerAddress",
          "type": "address"
        },
        {
          "internalType": "address",
          "name": "TablesControllerAddress",
          "type": "address"
        },
        {
          "internalType": "address",
          "name": "PullReinvestAddress",
          "type": "address"
        }
      ],
      "stateMutability": "nonpayable",
      "type": "constructor"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "ReferalReward",
          "type": "uint256"
        },
        {
          "internalType": "uint256",
          "name": "RefererId",
          "type": "uint256"
        }
      ],
      "name": "AddMemberReferalRewards",
      "outputs": [],
      "stateMutability": "payable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "UserReward",
          "type": "uint256"
        },
        {
          "internalType": "uint256",
          "name": "UserId",
          "type": "uint256"
        }
      ],
      "name": "AddMemberRewards",
      "outputs": [],
      "stateMutability": "payable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint8",
          "name": "table",
          "type": "uint8"
        },
        {
          "internalType": "uint256",
          "name": "refId",
          "type": "uint256"
        }
      ],
      "name": "BuyTable",
      "outputs": [],
      "stateMutability": "payable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "userId",
          "type": "uint256"
        },
        {
          "internalType": "uint256",
          "name": "value",
          "type": "uint256"
        },
        {
          "internalType": "uint8",
          "name": "table",
          "type": "uint8"
        }
      ],
      "name": "BuyTableReInvest",
      "outputs": [],
      "stateMutability": "payable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "newAddress",
          "type": "address"
        }
      ],
      "name": "Change",
      "outputs": [],
      "stateMutability": "payable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "newAddress",
          "type": "address"
        }
      ],
      "name": "ChangePullStorage",
      "outputs": [],
      "stateMutability": "payable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "newAddress",
          "type": "address"
        }
      ],
      "name": "ChangeReinvestAddress",
      "outputs": [],
      "stateMutability": "payable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "newAddress",
          "type": "address"
        }
      ],
      "name": "ChangeTableStorage",
      "outputs": [],
      "stateMutability": "payable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "newAddress",
          "type": "address"
        }
      ],
      "name": "ChangeUserStorage",
      "outputs": [],
      "stateMutability": "payable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "_addressKey",
          "type": "address"
        }
      ],
      "name": "Set",
      "outputs": [],
      "stateMutability": "payable",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "SetKey",
      "outputs": [],
      "stateMutability": "payable",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "getContractBalance",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "refId",
          "type": "uint256"
        }
      ],
      "name": "registerWithReferrer",
      "outputs": [],
      "stateMutability": "payable",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "turnover",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "withDraw",
      "outputs": [],
      "stateMutability": "payable",
      "type": "function"
    },
    {
      "stateMutability": "payable",
      "type": "receive"
    }
  ];
ReinvestAbi =  [
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "pullControllerAddress",
          "type": "address"
        },
        {
          "internalType": "address",
          "name": "userControllerAddress",
          "type": "address"
        },
        {
          "internalType": "address",
          "name": "tableControllerAddress",
          "type": "address"
        },
        {
          "internalType": "address payable",
          "name": "gameAddress",
          "type": "address"
        },
        {
          "internalType": "address",
          "name": "depositeControllerAddres",
          "type": "address"
        }
      ],
      "stateMutability": "nonpayable",
      "type": "constructor"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "newAddress",
          "type": "address"
        }
      ],
      "name": "ChangeDepositeStorage",
      "outputs": [],
      "stateMutability": "payable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "newAddress",
          "type": "address"
        }
      ],
      "name": "ChangePullStorage",
      "outputs": [],
      "stateMutability": "payable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "newAddress",
          "type": "address"
        }
      ],
      "name": "ChangeTableStorage",
      "outputs": [],
      "stateMutability": "payable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "address",
          "name": "newAddress",
          "type": "address"
        }
      ],
      "name": "ChangeUserStorage",
      "outputs": [],
      "stateMutability": "payable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint8",
          "name": "table",
          "type": "uint8"
        },
        {
          "internalType": "address",
          "name": "userAddress",
          "type": "address"
        }
      ],
      "name": "ReinvestTable",
      "outputs": [],
      "stateMutability": "payable",
      "type": "function"
    },
    {
      "inputs": [
        {
          "internalType": "uint256",
          "name": "pullId",
          "type": "uint256"
        }
      ],
      "name": "RewardToPull",
      "outputs": [],
      "stateMutability": "payable",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "getContractBalance",
      "outputs": [
        {
          "internalType": "uint256",
          "name": "",
          "type": "uint256"
        }
      ],
      "stateMutability": "view",
      "type": "function"
    },
    {
      "inputs": [],
      "name": "withDraw",
      "outputs": [],
      "stateMutability": "payable",
      "type": "function"
    },
    {
      "stateMutability": "payable",
      "type": "receive"
    }
  ];

ViewAddress = "";
MatrixAddress = "";
ReinvestAddress = "";

const ViewContract = new web3.eth.Contract(ViewAbi, ViewAddress);
const MatrixContract = new web3.eth.Contract(MatrixAbi, MatrixAddress);
const ReinvesContract = new web3.eth.Contract(ReinvestAbi, ReinvestAddress);




async function connect() 
{
    const accounts = await ethereum.request({ method: "eth_requestAccounts",});
    metaAdress = accounts[0];
    if (typeof window.ethereum !== "undefined") 
    {
        try
        {
            await window.ethereum.request
            ({
                method: "wallet_switchEthereumChain",
                params: [{chainId: "0x38"}]
            });
        } 
        catch (switchError) 
        {
            if (switchError.code === 4902) 
            {
                console.log("4902");
                try 
                {
                    await window.ethereum.request({
                        method: "wallet_addEthereumChain",
                        params: 
                        [{
                            chainId: "0x38",
                            chainName: "Smart Chain",
                            rpcUrls: ["https://bsc-dataseed.binance.org/"],
                        }]
                    });
                } 
                catch (addError) 
                {
                    console.log(addError);
                }
            }
        }
    } 
    else
    {
    }
}



/// Matrix
async function BuyTable(table, sum)
{
    /////await connect();
    const accounts = await ethereum.request({method: "eth_requestAccounts"});
    metaAdress = accounts[0];
    try 
    {
        await MatrixContract.methods.BuyTable(table, refId).send
        ({
            from: metaAdress,
            value: sum,
            gas: gasBuy
        });
    } catch (err) {
        console.log(err);
    }
}


/// Reinvest
async function PullReward(pullId, sum)
{
    /////await connect();
    const accounts = await ethereum.request({method: "eth_requestAccounts"});
    metaAdress = accounts[0];
    try 
    {
        await ReinvestContract.methods.RewardToPull(pullId).send
        ({
            from: metaAdress,
            value: sum,
            gas: gasBuy
        });
    } catch (err) {
        console.log(err);
    }
}

async function Reinvest(table)
{
    /////await connect();
    const accounts = await ethereum.request({method: "eth_requestAccounts"});
    metaAdress = accounts[0];
    try 
    {
        await ReinvestContract.methods.ReinvestTable(table, metaAdress).send
        ({
            from: metaAdress,
            value: 0,
            gas: gasBuy
        });
    } catch (err) {
        console.log(err);
    }
}





//// VIEW
async function GetFullUserInfo()
{
    ////await connect();
    const accounts = await ethereum.request({
        method: "eth_requestAccounts",
    });
    metaAdress = accounts[0];
    let userInfo = await ViewContract.methods.GetFullUserInfo(metaAdress).call({
        from: metaAdress,
    });
    return userInfo;
}

async function GetUserLevels()
{
    //// await.connect();
    const accounts = await ethereum.request({
        method: "eth_requestAccounts",
    });
    metaAdress = accounts[0];
    let userId = await ViewContract.GetUserId(metaAdress).call({
        from:metaAdress
    });
    let levels = await ViewContract.methods.GetUserLevels(userId).call({
        from: metaAdress
    });
    return levels;
}

async function GetPullById(pullId)
{
    ////await connect();
    const accounts = await ethereum.request({
        method: "eth_requestAccounts",
    });
    metaAdress = accounts[0];
    let pullInfo = await ViewContract.methods.GetPullById(pullId).call({
        from: metaAdress,
    });
    return pullInfo;
}

async function GetUserTableProgress()
{
    //// await.connect();
    const accounts = await ethereum.request({
        method: "eth_requestAccounts",
    });
    metaAdress = accounts[0];
    let userId = await ViewContract.GetUserId(metaAdress).call({
        from:metaAdress
    });
    let places = [];
    for (let table = 1; table<=16; table++)
    {
        let position = await ViewContract.methods.GetTablePosition(userId).call({
            from: metaAdress
        });
        if (position[0] === 0)
        {
            places.push(0);
        }
        else
        {
            places.push(position[0]/(position[1]/100));
        }
    }
    return places;
}

async function GetPullsInfo()
{
     ////await connect();
     const accounts = await ethereum.request({
        method: "eth_requestAccounts",
    });
    metaAdress = accounts[0];
    let pullCount = await ViewContract.methods.GetPullCount().call({
        from: metaAdress
    });
    let pullInfo = [];
    for (let pull = 1; pull<= pullCount; pull++)
    {
        let info = await ViewContract.methods.GetPullById(pull).call({
            from: metaAdress,
        });
        pullInfo.push(info)
    }
    return pullInfo;
}

async function GetGlobalStat()
{
     ////await connect();
     const accounts = await ethereum.request({
        method: "eth_requestAccounts",
    });
    metaAdress = accounts[0];
    let stat = await ViewContract.methods.GetGlobalStat().call({
        from: metaAdress,
    });
    return stat;
}
