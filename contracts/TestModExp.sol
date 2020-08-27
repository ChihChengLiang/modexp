// SPDX-License-Identifier: MIT
pragma solidity ^0.6.8;

import { ModExp } from "./ModExp.sol";

contract TestModExp {
    function modexp(uint256 x) public view returns (uint256 xx, uint256 gasCost) {
        gasCost = gasleft();
        xx = ModExp.modexp(x);
        gasCost = gasCost - gasleft();
    }

    function modexp2(uint256 x) public view returns (uint256 xx, uint256 gasCost) {
        gasCost = gasleft();
        xx = ModExp.modexp2(x);
        gasCost = gasCost - gasleft();
    }

    function modexp3(uint256 x) public view returns (uint256 xx, uint256 gasCost) {
        gasCost = gasleft();
        xx = ModExp.modexp3(x);
        gasCost = gasCost - gasleft();
    }

    function modexp4(uint256 x) public view returns (uint256 xx, uint256 gasCost) {
        gasCost = gasleft();
        xx = ModExp.modexp4(x);
        gasCost = gasCost - gasleft();
    }

    function modexp5(uint256 x) public view returns (uint256 xx, uint256 gasCost) {
        gasCost = gasleft();
        xx = ModExp.modexp5(x);
        gasCost = gasCost - gasleft();
    }

    function modexp6(uint256 x) public view returns (uint256 xx, uint256 gasCost) {
        gasCost = gasleft();
        xx = ModExp.modexp6(x);
        gasCost = gasCost - gasleft();
    }

    function modexp7(uint256 x) public view returns (uint256 xx, uint256 gasCost) {
        gasCost = gasleft();
        xx = ModExp.modexp7(x);
        gasCost = gasCost - gasleft();
    }
}
