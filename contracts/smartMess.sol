// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MessFeeLedger {

    address public admin;

    event FeeRecorded(
        uint256 indexed studentId,
        string indexed receiptId,
        uint256 amount,
        uint256 timestamp,
        bytes32 methodHash
    );

    constructor() {
        admin = msg.sender;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not authorized");
        _;
    }

    function recordFee(
        uint256 studentId,
        string calldata receiptId,
        uint256 amount,
        string calldata method
    ) external onlyAdmin {
        require(amount > 0, "Invalid amount");

        emit FeeRecorded(
            studentId,
            receiptId,
            amount,
            block.timestamp,
            keccak256(bytes(method))
        );
    }

    function transferAdmin(address newAdmin) external onlyAdmin {
        require(newAdmin != address(0), "Invalid address");
        admin = newAdmin;
    }

    function getContractInfo() external pure returns (string memory) {
        return "Smart Mess System Fee Ledger v1";
    }
}
