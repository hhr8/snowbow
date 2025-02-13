// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "forge-std/Script.sol";
import "forge-std/console2.sol";
import {SnowbowProduct} from "src/SnowbowProduct.sol";
import {SnowbowFactory} from "src/SnowbowFactory.sol";
import {PriceObserver} from "src/PriceObserver.sol";
import {USD} from "src/mock/USD.sol";
import {WBTC} from "src/mock/WBTC.sol";
import "src/interfaces/IStructDef.sol";

contract Deploy is Script, IStructDef {
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

    function upgradeProduct() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        address owner = vm.addr(deployerPrivateKey);
        vm.startBroadcast(deployerPrivateKey);

        SnowbowProduct snowbowImpl = new SnowbowProduct();
        SnowbowFactory factory = SnowbowFactory(0xbD5a8C111E60867D07D73fcDEd680689D401E2D7);

        factory.setImplementation(address(snowbowImpl));

        vm.stopBroadcast();

        console2.log("factory: ", address(factory), "\n new snowbow impl: ", address(snowbowImpl));
    }

    function createWBTCProduct() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        address owner = vm.addr(deployerPrivateKey);
        vm.startBroadcast(deployerPrivateKey);

        SnowbowFactory factory = SnowbowFactory(0xbD5a8C111E60867D07D73fcDEd680689D401E2D7);

        // create wbtc product
        address product = factory.createProduct(
            ProductInitArgs(
                0x3d56dC8D257Db1085fD4f47F7fCCeCE279FB330b,
                0x007A22900a3B98143368Bd5906f8E17e9867581b,
                4400000000000,
                4000000000000,
                4800000000000,
                1702224000,
                86400,
                1000,
                0x42EFBA52668d124e8c7427aA7cb2c4Fe7212109A,
                0x572dDec9087154dC5dfBB1546Bb62713147e0Ab0,
                0x9C8c4c4ec9346f941724aeb341c587891E336e1d
            )
        );

        vm.stopBroadcast();

        console2.log("factory: ", address(factory));
        console2.log("wbtc product: ", product);
    }

    function buyWBTCShare() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        address owner = vm.addr(deployerPrivateKey);
        vm.startBroadcast(deployerPrivateKey);

        SnowbowProduct product = SnowbowProduct(0xa0967fb211Bf26DBc0b6F7793F2dd3989db72fAb);
        USD usd = USD(0x42EFBA52668d124e8c7427aA7cb2c4Fe7212109A);

        usd.approve(address(product), UINT256_MAX);
        product.buyShare(10 ether);

        vm.stopBroadcast();
    }
}
