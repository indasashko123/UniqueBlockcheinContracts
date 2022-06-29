let refId = 1;


// Set Data
window.addEventListener("load", () => {
    setData();
});


async function setData() {
    try
    {
        let currentUser = await GetFullUserInfo();
        await SetUserInfo(currentUser);
    }
    finally
    {
        let tables = await GetUserLevels();
       // let stats = await getGlobalStatistic();
       //  await setGlobalStats(stats);
       let progress = await GetUserTableProgress();
        await SetOnlineTables(tables);
        await SetProgress(progress);
        // Баки
       // let fuelsState = await getUserTables();
      //  await setFuel(fuelsState);
    }
}

let progress = document.querySelector("#progress");
let payout = document.querySelector("#payouts");
let tableReward = document.querySelector("#tableReward");


async function SetUserInfo()
{
    
}

async function SetOnlineTables(tables)
{
    payout.innerHTML = tables[1][1];
}

async function SetProgress(progress)
{
   progress.innerHTML = progress[1];
}