//SPDX-License-Identifier: MIT 
pragma solidity >=0.8.18;

//Sample Array contract based on the example provided by: https://solidity-by-example.org/array/
contract Array {

    //Initialize reputationScores array 
    uint[] public reputationScores = [100, 100, 100, 100, 100];

    // Fixed sized array, all elements initialize to 0
    //uint[10] public myFixedSizeArr;

    //function get_reputationScores() --> Print the requested reputation score (single score/indexed value)
    function get_reputationScore(uint i) public view returns (uint) {
        return reputationScores[i];
    }

    // Solidity can return the entire array.
    // But this function should be avoided for
    // arrays that can grow indefinitely in length.

    //function show_all_reputationScores() --> Output the entire reputationScores array (all values)
    function show_all_reputationScores() public view returns (uint[] memory) {
        return reputationScores;
    }

    //function push() --> Add new reputation score to the reputationScores array (increases length of array by 1)
    function push(uint i) public {
        reputationScores.push(i);
    }

    //function pop() --> Remove old reputation score from the reputationScores array (decreases length of array by 1)
    function pop() public {
        reputationScores.pop(); 
    }

    //function get_Length() --> Returns the current length of the reputationScores array 
    function get_Length() public view returns (uint) {
        return reputationScores.length;
    }

    //function average_reputationScore() --> Calculates the rolling average reputation score based on last 5 events 
    function average_reputationScore() public view returns (uint) {
        uint avg_reputationScore; 
        uint sum = 0; 

        for (uint i = 0; i < reputationScores.length; i++) {
            sum += reputationScores[i];
        }

        avg_reputationScore = sum / reputationScores.length;

        return avg_reputationScore; 

    }

}
