//SPDX-License-Identifier: MIT 
pragma solidity >=0.8.18; 

contract RSU_Application {

    struct Sensor_Data_Readout {
        string ENTITY_ID; 
        string TIMESTAMP; 
        bool EMERGENCY_STOP; 
        bool SLOW_CAUTION;
        bool STOP_VRU; 
    }

    constructor() {
        //Placeholder for future development
    }

    mapping(address => Sensor_Data_Readout) public _sensorReadout; 

    function create_SensorReadout(string memory entity_id, string memory timestamp, bool emergency_stop, bool slow_caution, bool stop_vru) external {
        _sensorReadout[msg.sender].ENTITY_ID = entity_id; 
        _sensorReadout[msg.sender].TIMESTAMP = timestamp;
        _sensorReadout[msg.sender].EMERGENCY_STOP = emergency_stop;
        _sensorReadout[msg.sender].SLOW_CAUTION = slow_caution;
        _sensorReadout[msg.sender].STOP_VRU = stop_vru;
    }

}
