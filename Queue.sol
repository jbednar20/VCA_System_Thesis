//SPDX-License-Identifier: MIT 
pragma solidity >=0.8.18; 


//Sample Queue contract based on the example provided by: https://ethereum.stackexchange.com/questions/129668/how-to-efficiently-implement-a-fifo-array-queue-in-solidity
contract Queue { 

  //  mapping (uint256 => uint256) queue;
  //  uint256 first = 1;
  //  uint256 last = 1;

    struct queue {
        uint[] data;
        uint first;
        uint last;
    }

    queue public reputationScores = queue([100, 100, 100, 100, 100], 1, 1); 

    function enqueue(uint256 data) public {
        last += 1;
        queue[last] = data;
    }

    function dequeue(uint256 data) public returns (uint256) {
        require(last > first);
        data = queue[first];
        delete queue[first];
        first += 1;
        return data;
    }
    
    function length() public view returns (uint256) {
        return last - first;
    }

    function showQueueEntry(uint256 index) public view returns (uint256) {
        index = index + first; 
        return queue[index];
    }

    function initialize_reputationScores() public {
        for (uint256 i = 0; i < 5; i++) {
            enqueue(100);
        }
    }

    //function average_reputationScore() --> Calculates the rolling average reputation score based on last 5 events 
    function average_reputationScore() public view returns (uint256) {
        uint avg_reputationScore; 
        uint sum = 0; 

        for (uint i = 0; i < 5; i++) {
            sum += queue[i]; 
        }

        avg_reputationScore = sum / 5; 

        return avg_reputationScore;

    }


} //end contract Queue
