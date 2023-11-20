//SPDX-License-Identifier: MIT 
pragma solidity 0.8.18; 

//contract Ownable based on open source documentation: https://docs.openzeppelin.com/contracts/2.x/access-control
contract Ownable {

    //Declare address contractOwner - private variable (Note: global variable in Ownable scope) 
    address private contractOwner; 

    //constructor() --> Define contract_owner address for ownable contract
    constructor() {
        contractOwner = msg.sender; 
    }//end constructor()

    //modifer only_contractOwner --> Only contract_onwer can create an instance of the Ownable contract (Access Control)
    modifier only_contractOwner {require(isOwner(), "Input address is not contractOwner"); _;}

    //function getOwner() --> Return the Ethereum address of contractOwner
    function getOwner() public view returns(address) {
        return contractOwner; 
    }//end getOwner()

    //function isOwner --> Return Boolean - True if sender address is contractOwner, false otherwise
    function isOwner() public view returns(bool) {
        return msg.sender == contractOwner; 
    }//end isOwner()
}//end contract Ownable 

//contract RSU_continuousAuth --> Smart contract for continuous authentication of RSU devices 
contract RSU_continuousAuth is Ownable {

    //Define Sensor_Data_Readout struct --> CV, AV sensor readout format defined in Thesis Chapter 2 
    struct Sensor_Data_Readout {
        string ENTITY_ID; 
        string TIMESTAMP; 
        bool EMERGENCY_STOP; 
        bool SLOW_CAUTION;
        bool STOP_VRU; 
    }

    //Map input addresses to Sensor_Data_Readout struct, define as _sensorReadout mapping (NOTE: Global mapping in contract context)
    mapping(address => Sensor_Data_Readout) private _sensorReadout; 

    //Map input address to int, define as reputationScore mapping (Note: Global mapping in contract context)
    mapping(address => int) private reputationScore; 

    //Define RSU_Ethereum_Addresses --> Array of Ethereum addresses for simulated RSU devices
    address[] private RSU_Ethereum_Addresses;

    //Define revoke_authToken() event --> Emits bool signal to web3.py application to revoke authentication token if true, else do nothing
    event revoke_authToken(address RSU_Address, bool _revoke_authToken);

    //function initialize_reputationScore() --> Initializes reputation score of each RSU device to 100 (we assume initial deployment)
    function initialize_reputationScore(address[] memory _RSU_Ethereum_Addresses) public {
        RSU_Ethereum_Addresses = _RSU_Ethereum_Addresses;
        for (uint256 i = 0; i < _RSU_Ethereum_Addresses.length; i++) {
            reputationScore[_RSU_Ethereum_Addresses[i]] = 100;
        }    
    }//end initialize_reputationScore()

    //function get_reputationScores() --> Print the requested reputation score (single score/indexed value)
    function get_reputationScore() public view returns (int) {
        return reputationScore[msg.sender];
    }//end get_reputationScores()

    //function increase_reputationScore() --> Increase reputation score by 5 units with a maximum cap of 100 units
    function increase_reputationScore() private returns (int) {
        int current_reputationScore = reputationScore[msg.sender];
        current_reputationScore = current_reputationScore + 5;

        if (current_reputationScore > 100) {
            current_reputationScore = 100; 
            reputationScore[msg.sender] = current_reputationScore;
        } else {
            reputationScore[msg.sender] = current_reputationScore;
        }

        return reputationScore[msg.sender];
    }//end increase_reputationScore() 

    //function  decrease_reputationScore() --> Decrease reputation score by 30 (called upon for bad RSU message, etc.) 
    function decrease_reputationScore() private returns (int) {
        int current_reputationScore = reputationScore[msg.sender]; 
        current_reputationScore = current_reputationScore - 20; 

        if (current_reputationScore <= 0) {
            current_reputationScore = 0; 
            reputationScore[msg.sender] = current_reputationScore;
        } else {
            reputationScore[msg.sender] = current_reputationScore;

        }

        return reputationScore[msg.sender];
    }//end decrease_reputationScore()

    //function evaluate_reputationScore() --> If reputationScore >= 60, return bool True; else, return bool False
    function evaluate_reputationScore() public view returns (bool) {
        if (reputationScore[msg.sender] >= 60) {
            return true;
        } else {
            return false; 
        }
    }//end evalutate(reputationScore()

    function is_messageValid() public view returns (bool) {

         bool isValid;
        
        //Logic to evaluate validity of CV messages 
        if (keccak256(bytes(_sensorReadout[msg.sender].ENTITY_ID)) == keccak256(bytes("Connected_Vehicle"))) {

            if (_sensorReadout[msg.sender].EMERGENCY_STOP == false  && _sensorReadout[msg.sender].SLOW_CAUTION == false && _sensorReadout[msg.sender].STOP_VRU == false) {

            //Message valid, set isValid to true
            isValid = true;

            } else if (_sensorReadout[msg.sender].EMERGENCY_STOP == false && _sensorReadout[msg.sender].SLOW_CAUTION == false && _sensorReadout[msg.sender].STOP_VRU == true) {

            //Message valid, set isValid to true
            isValid = true;

            } else {

            //Message invalid, set isValid to false
            isValid = false;

            }

        }//end if statement --> Connected_Vehicle

        //Logic to evaluate validity of AV messages 
        if (keccak256(bytes(_sensorReadout[msg.sender].ENTITY_ID)) == keccak256(bytes("Autonomous_Vehicle"))) {

            if (_sensorReadout[msg.sender].EMERGENCY_STOP == false  && _sensorReadout[msg.sender].SLOW_CAUTION == false && _sensorReadout[msg.sender].STOP_VRU == false) {

            //Message valid, set isValid to true
            isValid = true;

            } else if (_sensorReadout[msg.sender].EMERGENCY_STOP == false && _sensorReadout[msg.sender].SLOW_CAUTION == false && _sensorReadout[msg.sender].STOP_VRU == true) {

            //Message valid, set isValid to true
            isValid = true;

            } else {

             //Message invalid, set isValid to false
            isValid = false;

            }

        }//end if statement --> Autonomous_Vehicle


        //Logic to evaluate validity of RSU messages 
        if (keccak256(bytes(_sensorReadout[msg.sender].ENTITY_ID)) == keccak256(bytes("Roadside_Unit"))) {

            if (_sensorReadout[msg.sender].EMERGENCY_STOP == true  && _sensorReadout[msg.sender].SLOW_CAUTION == false && _sensorReadout[msg.sender].STOP_VRU == false) {

            //Message valid, set isValid to true
            isValid = true;

            } else if (_sensorReadout[msg.sender].EMERGENCY_STOP == false && _sensorReadout[msg.sender].SLOW_CAUTION == true && _sensorReadout[msg.sender].STOP_VRU == false) {

            //Message valid, set isValid to true
            isValid = true;

            } else {

             //Message invalid, set isValid to false
            isValid = false;

            }

        }//end if statement --> Autonomous_Vehicle

        return isValid;

    }//end is_messageValid()

    //function create_sensorReadout() --> Writes a CV, AV, or RSU sensor readout format message to the blockchain
    function create_sensorReadout(string memory entity_id, string memory timestamp, bool emergency_stop, bool slow_caution, bool stop_vru) private {
        _sensorReadout[msg.sender].ENTITY_ID = entity_id; 
        _sensorReadout[msg.sender].TIMESTAMP = timestamp;
        _sensorReadout[msg.sender].EMERGENCY_STOP = emergency_stop;
        _sensorReadout[msg.sender].SLOW_CAUTION = slow_caution;
        _sensorReadout[msg.sender].STOP_VRU = stop_vru;
    }//end create_sensorReadout()

    //function publish_sensorReadout() --> Creates _sensorReadout message, evalutes message validity and increases/decreases reputationScore,
    //                                     then applies evalutate_reputationScore() test and enforces reputation-based continuous authentication
    function publish_sensorReadout(string memory entity_id, string memory timestamp, bool emergency_stop, bool slow_caution, bool stop_vru) public {

        create_sensorReadout(entity_id, timestamp, emergency_stop, slow_caution, stop_vru);

        if (is_messageValid() == true) {
            increase_reputationScore();
        } else {
            decrease_reputationScore();
        }

        if (evaluate_reputationScore() == true) {
            //Valid reputationScore, do nothing wrt authentication status 
        } else {
            //Emit revoke_authToken() event --> revokes authentication token for app-side de-authentication process 
            emit revoke_authToken(msg.sender, true);
        }
    }//end publish_sensorReadout() 

} //end contract RSU_continuousAuth
