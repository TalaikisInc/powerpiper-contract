pragma solidity ^0.4.23;

import "./Ownable.sol";
import "../states/ICO.sol";


contract ICOManagement is Ownable, ICOState {

    event RunIco();
    event PauseIco();
    event FinishIco();

    function startIco() external onlyOwner {
        require(icoState == State.Created || icoState == State.Paused);
        icoState = State.Running;
        emit FinishIco();
    }

    function pauseIco() external onlyOwner {
        require(icoState == State.Running);
        icoState = State.Paused;
        emit PauseIco();
    }

    function finishIco() external onlyOwner {
        require(icoState == State.Running || icoState == State.Paused);

        // defrost();

        icoState = State.Finished;
        emit FinishIco();
    }

}
