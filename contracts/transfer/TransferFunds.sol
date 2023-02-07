// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;


contract TransferFunds {

    function transferFundsTransfer(address payable _to) public payable {
        _to.transfer(msg.value);
    }

    function transferFundsSend(address payable _to) public payable {
        bool sent = _to.send(msg.value);
        require(sent, "Send failed");
    }

    function transferFundsCall(address payable _to) public payable {
        // call() forwards all gas by default
        (bool sent, ) = _to.call{ value: msg.value }("");
        require(sent, "Send failed");
    }

    /*
    function assemblyTransferErc20(address token, address from, address to, uint256 amount) internal {
        assembly {
            if iszero(extcodesize(token)) {
            revert(0,0)
            }
            let ptr := mload(0x40)
            mstore(0, ERC20_transferFrom_signature)
            mstore(0x04, from)
            mstore(0x24, to)
            mstore(0x44, amount)

            let callStatus := call(
            gas(),
            token,
            0,
            0, // ptr to the signature
            0x64, // length of the signature
            0, // ptr to store the output
            0x20 // length of the output
            )
            if iszero(returndatasize()) {
            revert(0,0)
            }
            if iszero(callStatus) {
            returndatacopy(ptr, 0, returndatasize())
            revert(ptr, returndatasize())
            }
            
            }
        }
    */
}