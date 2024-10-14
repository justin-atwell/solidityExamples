## Introducing Linea

This quick tutorial is designed to get you up and running on the Linea network with as little work as possible. In the three secionts below I hope you'll see just how easy it is to get up and running on Linea. 

1. Create an Ethereum account and setup Metamask for Remix
2. Configure Remix
3. Deploy a short smart contract deployment with Remix and Metamask.

## What the code does

This code is a play on the "Seventh Caller" to a radio station. Each account needs to submit exactly 1 Ether to be a "caller". The seventh account that deposits 1 Ether will declared the winner.

### Step 1: Metamask Setup

1. Install the Metamask [Chrome Extension](https://chromewebstore.google.com/detail/metamask/nkbihfbeogaeaoehlefnkodbefgpgknn?hl=en)

2. Follow instructions to create a new Ethereum account or import an existing account (Existing accounts are easier since some faucets require Ethereum mainnnet transactions as a protection against spam.)

3. After your account is created, Click the network dropdown on the top left and select "Linea Sepolia"

4. If you are using a brand new account, you will need to find some Linea Sepolia Testnet Eth or bridge from Ethereum.

5. If you are using an existing account, the fastest way to get .5 ETH is by using the [Infura Faucet](https://www.infura.io/faucet/linea). For other methods, please check out the [Linea Support Page(https://support.linea.build/getting-started/how-to-get-linea-goerli-testnet-eth)].


### Step 2: Remix Setup

1. Remix is a powerful web-based IDE. One of the strongest features it has is managing various plugins and accounts which are often used in web3 (Metamask, Github, etc). Please note: There are many ways to deploy Smart Contracts. This guide is meant to connect you in as little time as possible. For other options, please check out the [Linea Support page](https://docs.linea.build/developers/quickstart/deploy-smart-contract) for Smart Contract Deployment.

2. Follow the Remix setup steps.

3. Create a new Basic Workspace.

4. Delete the existing .sol files.

5. Navigate to Solidity Compiler on the left hand navigation bar and select 0.8.19 as the compiler version. This is the London build of the EVM that is utilized by Linea. 

6. Navigate to the "Deploy & Run Transactions" navigation bar. In the "Environment" drop down, change the option to `Injected Provider - Metamask`. This does two important things: First, it abstracts private keys from code. This is critical for security. Secondly, it allows you to interact with your smart contract in real time by using the RPC url embedded in Metamask (In our case, Linea Sepolia).

6. If you wish to add changes to Github, Click the Git tab and follow the instructions to setup source control. 


### Step 3. Running the code

1. Paste the following code into `SeventCaller.sol`:

```
// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract SeventhCaller {
    uint256 public seventhCaller = 7 ether;
    address public winner;

    //need to create a balance state variable to prevent forcefully sending ether
    uint256 public increment;

    function deposit() public payable {
        require(msg.value == 1 ether, "You can only send 1 Ether");

        increment += msg.value;
        require(increment <= seventhCaller, "Game is over");

        //if the counter is 7, they're the winner
        if (increment == seventhCaller) {
            winner = msg.sender;
        }
    }

    function claimReward() public {
        require(msg.sender == winner, "Not a winner");

        //this will send all the ether in this contract to the winner
        (bool sent, ) = msg.sender.call{value: address(this).balance}("");
        require(sent, "Failed to send Ether");
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
```

2. Hit the `Play` button on the top left or navigate to "Solidity Compiler" on the left hand navigation and click "Compile Seventh Caller". 

3. Move back over to the Deploy and Run Transactions tab and ensure you are using the same account you used to acquire Linea ETH from the steps above. This will ensure you are interacting with a live Smart Contract on Metamask instead of the integrated IDE.

4. Click "Deploy". 

5. Move over to the Metamask Chrome Extension and click "Approve"

6. You'll see the various functions and variables in the "Deployed Contracts" secion. 

7. On the top right in the "Value" box, make the value 1 and change the dropdown to Ether. The function we are going to invoke is a payable function which accepts payment with the function call. Notice Line 12 in the solidity contract. This requires us to put a value of 1 in the box.

8. Click the "Deposit" button. This confirms the contract is deployed to the EVM



### Easy mode for simulating multiple accounts in Remix

1. In the Environment dropdown, change the value to "Remix VM (London)". This will givey ou accounts with Ether that are virtual.

2. Click "Deploy".

3. Go through seven different accounts, depositing exactly 1 Ether for each. On any of the first six deposits, click the `winner` function and you should see an empty contract. On the seventh deposit function, click the `winner` function and you should see the seventh account that submitted 1 Ether.