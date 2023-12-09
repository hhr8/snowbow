// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "forge-std/Script.sol";
import "forge-std/console2.sol";
import {SnowbowProduct} from "src/SnowbowProduct.sol";
import {SnowbowFactory} from "src/SnowbowFactory.sol";
import {PriceObserver} from "src/PriceObserver.sol";
import {USD} from "src/mock/USD.sol";
import {WBTC} from "src/mock/WBTC.sol";

contract Deploy is Script {
    function deploy() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        address owner = vm.addr(deployerPrivateKey);
        vm.startBroadcast(deployerPrivateKey);

        SnowbowProduct snowbowImpl = new SnowbowProduct();
        SnowbowFactory factory = new SnowbowFactory(owner);
        // for mock, observe every 5 minutes
        PriceObserver observer = new PriceObserver(300, 1701993600);

        factory.setImplementation(address(snowbowImpl));

        USD usd = new USD();
        WBTC wbtc = new WBTC();

        vm.stopBroadcast();

        console2.log("factory: ", address(factory), "\n  snowbow impl: ", address(snowbowImpl));
        console2.log("observer: ", address(observer));
        console2.log("usd:", address(usd));
        console2.log("wbtc: ", address(wbtc));
    }
}
