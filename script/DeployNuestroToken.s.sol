// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console2} from "forge-std/Script.sol";
import {NuestroToken} from "../src/NuestroToken.sol";

contract DeployNuestroToken is Script {
    uint256 public constant INITIAL_SUPPLY = 1_000_000 ether; // 1 million tokens con 18 decimales

    function run() external returns (NuestroToken) {
        vm.startBroadcast();
        NuestroToken ourToken = new NuestroToken(INITIAL_SUPPLY);
        vm.stopBroadcast();
        return ourToken;
    }
}