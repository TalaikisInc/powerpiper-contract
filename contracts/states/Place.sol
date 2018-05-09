pragma solidity ^0.4.23;


contract PLaceState {

    enum State {
        Available,
        NotAvailable,
        InDebt
    }

    State public placeState = State.Available;

}
