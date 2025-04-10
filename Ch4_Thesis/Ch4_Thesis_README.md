# Ch4_Thesis README 
Chapter 4 of the thesis focuses on the creation of a proof-of-concept prototype for an Ethereum-based smart contract for continuous RSU authentication. The Truffle Suite Ganache tool was used to locally emulate an Ethereum blockchain, which allowed for execution of the smart contract. The intent of this README is to provide a brief overview of the codebase, along with basic instructions for how to use it. For detailed, step-by-step usage see Chapter 4, Section 3 of the thesis (full text available in root directory of this repo).

## Overview of Files
The code for this project consists of two files: the Solidity smart contract and the Python smart contract driver script. 

1. **RSU_Application.sol** defines the smart contract logic using the Solidity programming language. This code should not be modified if one wants to run the prototype as executed in the thesis. For details on the smart contract logic see Chapter 4, Section 3 of the thesis.

2. **smartContractDriver.py** provides a driver Python script for both the Ganache-based Ethereum blockchain emulation and execution of the smart contract defined by **RSU_Application.sol**. This code should not be modified if one wants to run the prototype as executed in the thesis. However, minor tweaks (such as the number of nodes) can be explored if one wants to do so.

Additionally, **Geth_Clique_PoA_CLI_Commands.txt** details how to set up a Proof of Authority (PoA) to create a local Ethereum testnet. However, use of this approach falls outside the scope of this README. 

## Instructions 
To execute the Ethereum smart contract, please follow the below steps: 

1. Ensure the machine you are using has the following Pyhton libraries installed: eth_utils, web3, os, solcx, dotenv, web3_import_decoder, json, time. The "pip install" command is a reliable way to accomplish this task. Download the code files for this project to the same directory.

2. Install Truffle Suite Ganache, which is available at: https://archive.trufflesuite.com/ganache/

3. Create a local Ethereum testnet using Ganache, follwing the Truffle Quickstart tutorial available at: https://archive.trufflesuite.com/docs/truffle/quickstart/

4. Record the chain ID, node addresses and associated private keys for the local Ethereum testnet.

5. Update **smartContractDriver.py** with the chain ID (line 47), node addresses (line 48), and private keys (line 49) associated with the local Ethereum testnet.

6. Place the **RSU_Application.sol** contract in the Ganache contracts directory and execute the following commands in a terminal window: truffle init, truffle compile

7. Launch Ganache (if it is not running already) and confirm that the Ethereum testnet is operational

8. Execute **smartContractDriver.py**, which starts the execution of the smart contract on the Ethereum testnet. The smart contract will continue to execute until the model RSU is deauthenticated.

Ganache documentation: https://archive.trufflesuite.com/docs/ganache/
