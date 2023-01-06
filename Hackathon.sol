// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract Hackathon {
    struct Project {
        string title;
        uint[] ratings;
    }
    
    Project[] projects;

    function findWinner() external view returns (Project memory){
        uint highestAverageRating;
        Project memory contenderProject;
        for(uint i = 0; i < projects.length; i++){
            Project memory project = projects[i];
            uint averageRating;
            uint[] memory ratings = project.ratings;
            for(uint j = 0; j < ratings.length; j++){
                averageRating += ratings[j];
            }
            averageRating = averageRating / ratings.length;
            if(averageRating > highestAverageRating){
                highestAverageRating = averageRating;
                contenderProject = project;
            }
        }
        return contenderProject;
    }

    function newProject(string calldata _title) external {
        // creates a new project with a title and an empty ratings array
        projects.push(Project(_title, new uint[](0)));
    }

    function rate(uint _idx, uint _rating) external {
        // rates a project by its index
        projects[_idx].ratings.push(_rating);
    }
}
