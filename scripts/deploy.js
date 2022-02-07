const main = async () => {
  const nftContractFactory = await hre.ethers.getContractFactory('MyEpicNFT');
  const nftContract = await nftContractFactory.deploy();
  await nftContract.deployed();
  console.log("Contact is deployed to: ", nftContract.address);


  //call create NFT function
  let txn = await nftContract.makeAnEpicNFT()
  await txn.wait()
  console.log("Minted NFT #1")

  //create another for funzies
  txn = await nftContract.makeAnEpicNFT()
  await txn.wait();
  console.log("Minted NFT #2")
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.error("There was an error deploying", error);
    process.exit(1);
  }
};

runMain();