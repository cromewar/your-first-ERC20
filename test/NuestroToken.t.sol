//SPDX-License-Identifier: MIT

pragma solidity 0.8.26;

import {DeployNuestroToken} from "../script/DeployNuestroToken.s.sol";
import {NuestroToken} from "../src/NuestroToken.sol";
import {Test, console} from "forge-std/Test.sol";

interface MintableToken{
    function mint(address to, uint256 amount) external;
}

contract NuestroTokenTest is Test {
    uint256 CROME_STARTING_AMOUNT = 100 ether;
    uint256 public constant INITIAL_SUPPLY = 1_000_000 ether; // 1 million tokens con 18 decimales


    // Declarar el Token
    NuestroToken public nuestroToken;
    DeployNuestroToken public deployer;
    address public deployerAddress;
    address crome;
    address war;

    // Funcion setup que se ejecuta siempre que se corre el test

    function setUp() public {

        // Deplegar el token y enviar el initial supply a la wallet que mintea
        deployer = new DeployNuestroToken();
        nuestroToken = new NuestroToken(INITIAL_SUPPLY);
        nuestroToken.transfer(msg.sender, INITIAL_SUPPLY);

        // crear dos wallet
        crome = makeAddr("crome");
        war = makeAddr("war");

        vm.prank(msg.sender);
        nuestroToken.transfer(crome, CROME_STARTING_AMOUNT);
    }
    
    //Funciones especificas para testear el token

    function testIniitialSupply() public view {
        assertEq(nuestroToken.totalSupply(), INITIAL_SUPPLY);
    }

    function testUserCanMint() public {
        vm.expectRevert();
        MintableToken(address(nuestroToken)).mint(address(this), 1);
    }

    function testAllowances() public {
        uint256 initialAllowance = 1000;

        // Crome aprueba a war para gastar 1000 tokens en su nombre

        vm.prank(crome);
        nuestroToken.approve(war, initialAllowance);
        uint256 transferAmount = 500;

        vm.prank(war);
        nuestroToken.transferFrom(crome, war, transferAmount);
        assertEq(nuestroToken.balanceOf(war), transferAmount);
        assertEq(nuestroToken.balanceOf(crome), CROME_STARTING_AMOUNT - transferAmount);

    }

    //RETO: Crear el resto de funciones para testear el token

}