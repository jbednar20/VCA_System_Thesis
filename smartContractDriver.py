#Import dependencies required to run smart contract on Ethereum testnet via web3.py
from eth_utils import address
from web3 import Web3 
import os 
from solcx import compile_standard, install_solc
from dotenv import load_dotenv
import json 
import time

#Open the Solidity code for RSU Application smart contract, load as file
#Then, install solc and generate application binary interface (abi) and Ethereum Virtual Machine (EVM) bytecode
with open("./RSU_Application.sol", "r") as file: 
    RSU_Application = file.read() 

    install_solc("0.8.18")
    compiled_sol = compile_standard(
    {
        "language": "Solidity",
        "sources": {"RSU_Application.sol": {"content": RSU_Application}},
        "settings": {
            "outputSelection": {
                "*": {
                    "*": ["abi", "metadata", "evm.bytecode", "evm.bytecode.sourceMap"]
                }
            }
        },
    },
    solc_version="0.8.18",
)

with open("compiled_code.json", "w") as file:
    json.dump(compiled_sol, file)


# Extract the bytecode from the compiled_sol JSON object
bytecode = compiled_sol["contracts"]["RSU_Application.sol"]["RSU_Application"]["evm"]["bytecode"]["object"]

# Extract the abi from the compiled_sol JSON object
abi = json.loads(compiled_sol["contracts"]["RSU_Application.sol"]["RSU_Application"]["metadata"])["output"]["abi"]

# Establish connection with Ganache on localhost (Virtualized Ethereum PoS Testnet)
w3 = Web3(Web3.HTTPProvider("HTTP://172.29.208.1:7545"))

# Define chain_id (i.e., NetworkID), and declare node addresses/private keys 
# TODO: Rewrite code to remove private keys from final code on any public repo (Github, etc.)
chain_id = 1337
node_addresses = ["0x8120E4AeB4B54CE709280041f6be1204aefF6Db0", "0xa7Aa0698b0D72866f16813Ec9B43749e97E06cfF"]
private_keys = ["0xae328940a41ad1be265e2012c8d1be53c423216c48d4168dd2eea405180425fe", "0xe7d87fd3d59e71409cf4cd413ab49741c2213632b2434d66123ccece6b3db1e6"]

# Instantiate an instance of the RSU Application smart contract on Ganache (Virtualized Ethereum PoS Testnet)
RSU_Application = w3.eth.contract(abi=abi, bytecode=bytecode)
nonce = w3.eth.get_transaction_count(node_addresses[0])

# Send the initial transaction for the RSU Application smart contract instance
# NOTE: This action adds the smart contract itself to the blockchain 
transaction = RSU_Application.constructor().build_transaction({"chainId": chain_id, "from": node_addresses[0], "nonce": nonce})
signed_tx = w3.eth.account.sign_transaction(transaction, private_key=private_keys[0])
tx_hash = w3.eth.send_raw_transaction(signed_tx.rawTransaction)
tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)



#Generate 100 transactions with simulated sensor data readouts to confirm baseline operation of smart contract


for i in range(100):

    #NOTE: This code block sends transactions from Node 1 to Node 2
    #Generate new nonce; each tx requires a unique nonce value 
    nonce = w3.eth.get_transaction_count(node_addresses[0])

    transaction = RSU_Application.functions.create_SensorReadout("Connected_Vehicle", "TIME", False, False, False).build_transaction({"chainId": chain_id, "from": node_addresses[0], "to": node_addresses[1], "nonce": nonce})
    signed_tx = w3.eth.account.sign_transaction(transaction, private_key=private_keys[0])
    tx_hash = w3.eth.send_raw_transaction(signed_tx.rawTransaction)
    tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)

    time.sleep(1) #Sleep for 1 second between transactions 

    #NOTE: This code block sends transactions from Node 2 to Node 1
    #Generate new nonce; each tx requires a unique nonce value 
    nonce = w3.eth.get_transaction_count(node_addresses[1])

    transaction = RSU_Application.functions.create_SensorReadout("Connected_Vehicle", "TIME", False, False, False).build_transaction({"chainId": chain_id, "from": node_addresses[1], "to": node_addresses[0], "nonce": nonce})
    signed_tx = w3.eth.account.sign_transaction(transaction, private_key=private_keys[1])
    tx_hash = w3.eth.send_raw_transaction(signed_tx.rawTransaction)
    tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
