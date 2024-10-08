// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Counters} from "@openzeppelin/contracts/utils/Counters.sol";
import {OwnableImmutable} from "./base/OwnableImmutable.sol";
import {Roles} from "./base/Roles.sol";
import {ReceiptVerifier} from "./base/ReceiptVerifier.sol";
import {Pool} from "./base/Pool.sol";

import {EquitoApp} from "./EquitoApp.sol";
import {bytes64, EquitoMessage} from "./libraries/EquitoMessageLibrary.sol";
import {IRouter} from "./interfaces/IRouter.sol";
import {TransferHelper} from "./libraries/TransferHelper.sol";
import {Errors} from "./libraries/Errors.sol";

error InvalidAddressLength(uint256);

contract Bridge is OwnableImmutable, Roles, ReceiptVerifier, Pool , EquitoApp {
    using Counters for Counters.Counter;
    event Sent(Receipt receipt);
    event Claimed(Receipt receipt);

    Counters.Counter nonce;

    constructor(address _signer, address _owner,address _router)
        Roles(_signer)
        OwnableImmutable(_owner)
        EquitoApp(_router) 
    {}

    function send(
        string calldata _tokenSymbol,
        uint256 _chainTo,
        bytes calldata _recipientAddress,
        uint256 _amount
    ) external {
        _burn(_tokenSymbol, msg.sender, _amount);

        emit Sent(
            Receipt({
                from: abi.encodePacked(msg.sender),
                to: _recipientAddress,
                tokenSymbol: _tokenSymbol,
                amount: _amount,
                chainFrom: block.chainid,
                chainTo: _chainTo,
                nonce: nonce.current()
            })
        );

        nonce.increment();
    }

    function claim(Receipt calldata _receipt, bytes calldata _signature)
        external
    {
        if (_receipt.to.length != 20)
            revert InvalidAddressLength(_receipt.to.length);

        _useReceipt(_receipt, _signature);

        bytes memory unpacked = _receipt.to;
        address to;
        assembly {
            to := mload(add(unpacked, 20))
        }

        _mint(_receipt.tokenSymbol, to, _receipt.amount);

        emit Claimed(_receipt);
    }
}
