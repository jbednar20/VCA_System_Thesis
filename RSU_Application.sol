//SPDX-License-Identifier: MIT 
pragma solidity >=0.8.18; 

contract RSU_Application {

    //Define Sensor_Data_Readout struct --> CV, AV sensor readout format defined in Thesis Chapter 2 
    struct Sensor_Data_Readout {
        string ENTITY_ID; 
        string TIMESTAMP; 
        bool EMERGENCY_STOP; 
        bool SLOW_CAUTION;
        bool STOP_VRU; 
    }

    //Map input addresses to Sensor_Data_Readout struct, define as _sensorReadout mapping
    mapping(address => Sensor_Data_Readout) public _sensorReadout; 

    //Map input address to uint256, define as reputationScore mapping 
    mapping(address => uint256) public reputationScore; 

    //Define RSU_Ethereum_Addresses --> Array of Ethereum addresses for simulated RSU devices
    address[] public RSU_Ethereum_Addresses;

    //Declare constructor() --> Blank placeholder for future development (if needed) 
    constructor() {
        //Placeholder for future development
    }

    //function create_SensorReadout() --> Writes a CV, AV, or RSU sensor readout format message to the blockchain
    function create_SensorReadout(string memory entity_id, string memory timestamp, bool emergency_stop, bool slow_caution, bool stop_vru) external {
        _sensorReadout[msg.sender].ENTITY_ID = entity_id; 
        _sensorReadout[msg.sender].TIMESTAMP = timestamp;
        _sensorReadout[msg.sender].EMERGENCY_STOP = emergency_stop;
        _sensorReadout[msg.sender].SLOW_CAUTION = slow_caution;
        _sensorReadout[msg.sender].STOP_VRU = stop_vru;
    }//end create_SensorReadout()

    //function initialize_reputationScore() --> Initializes reputation score of each RSU device to 100 (we assume initial deployment)
    function initialize_reputationScore(address[] memory _RSU_Ethereum_Addresses) public {
        RSU_Ethereum_Addresses = _RSU_Ethereum_Addresses;
        for (uint256 i = 0; i < _RSU_Ethereum_Addresses.length; i++) {
            reputationScore[_RSU_Ethereum_Addresses[i]] = 100;
        }    
    }//end initialize_reputationScore()

    //function get_reputationScores() --> Print the requested reputation score (single score/indexed value)
    function get_reputationScore(uint i) public view returns (uint) {
        address index = RSU_Ethereum_Addresses[i];
        return reputationScore[index];
    }//end get_reputationScores()

    //function increase_reputationScore() --> Increase reputation score by 5 units with a maximum cap of 100 units
    function increase_reputationScore(uint i) public returns (uint) {
        address index = RSU_Ethereum_Addresses[i]; 
        uint current_reputationScore = reputationScore[index];
        current_reputationScore = current_reputationScore + 5;

        if (current_reputationScore > 100) {
            current_reputationScore  = 100; 
            reputationScore[index] = current_reputationScore;
        } else {
            reputationScore[index] = current_reputationScore;
        }

        return reputationScore[index];
    }//end increase_reputationScore() 

    //function  decrease_reputationScore() --> Decrease reputation score by 30 (called upon for bad RSU message, etc.) 
    function decrease_reputationScore(uint i) public returns (uint) {
        address index = RSU_Ethereum_Addresses[i];
        uint current_reputationScore = reputationScore[index]; 
        current_reputationScore = current_reputationScore - 30; 
        reputationScore[index] = current_reputationScore;
        return reputationScore[index];
    }//end decrease_reputationScore()

} //end contract RSU_Application
