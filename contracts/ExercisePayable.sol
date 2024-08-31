// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

contract ExercisePayable {
    mapping(address => uint) public balances;
    uint fee;
    uint public treasury = 0;

    function addValueToUser() public{
        balances[msg.sender] = 1000;
    }

    function getValueFromUser() public view returns(uint){
        return balances[msg.sender];
    }

    // Tengo que ponerle cuanto Wei voy a mandar
    function sendValueToUser() public payable {
        balances[msg.sender] += msg.value;
    }

    //Revisar uso de 'this' en Solidity
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    function withdrawBalance(uint _amount) public {
        require(balances[msg.sender] >= _amount , "Insufficient funds");
        uint feeAmount = _amount * fee / 100;
        payable(msg.sender).transfer(_amount);
        balances[msg.sender] -= _amount; // actualizar el saldo de la cuenta
        treasury += feeAmount;
    }

    function getFee () private pure returns (uint256){
        return 2;
    }

    //mapping
    //payable
    //modifiers

    //funcion para enviar ether al contrato
    //asigna esos fondos a un usuario
    //guardamos en mapping el address -> balance actual del usuario
    //modifier chequear que msg.value > 0

    //withdrawUserFunds
    //required fundsForUser[msg.value] >= _fundsToWithdraw
    

}