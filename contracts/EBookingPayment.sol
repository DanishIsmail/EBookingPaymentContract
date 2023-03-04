// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./Ownable.sol";

contract EBookingPayment is Ownable {
     mapping(address=>address) private _admins;
     mapping(address=> uint256) private _paymentsTransferFrom;
     mapping(address=> uint256) private _paymentsTransferTo;

    event amountTransfered(address indexed _from, address indexed _to,uint256 _amount);
     
    constructor() payable {
        _admins[owner()] = owner();
    }

    modifier onlyOwners() {
        require(_admins[owner()] == msg.sender, "Ownable: caller is not the owner");
        _;
    }

    function tranferPayment(address payable from_, address payable to_, uint256 amount_) public payable{
        require(from_ !=address(0) && to_ !=address(0) , "Addresses should not be null");
        require(amount_ >= 0 && msg.value >= 0 && msg.value >= amount_, "Amount should be greater then 0");
        payable(to_).transfer(amount_);
        _paymentsTransferFrom[from_] = amount_;
        _paymentsTransferFrom[to_] = amount_;
        emit amountTransfered( from_, to_, amount_); 
    }

    function addOwner(address _newOwner) public onlyOwner {
        require(_newOwner !=address(0), "Address should not be null");
        _admins[_newOwner] = _newOwner;
    }

    function isOwner(address userAddress_) public view returns(bool) {
        require(userAddress_ !=address(0), "Address should not be null");
        return _admins[userAddress_] == userAddress_;
    }

    function getUserAccountBalance() public view returns(uint256) {
        return (msg.sender).balance;
    }

}
