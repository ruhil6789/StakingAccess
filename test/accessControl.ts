import {ethers} from "hardhat";
import { AccessControl, AccessControl__factory, Token, Token__factory } from "../typechain-types";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";


describe("contrsct",async()=>{

    let Access :AccessControl;
    let Token: Token;
let owner:SignerWithAddress;
let signers:SignerWithAddress[];

beforeEach("contracts",async()=>{
 signers = await ethers.getSigners();
 owner = signers[0];
Token = await  new Token__factory(owner).deploy("A","a");
Access = await new  AccessControl__factory(owner).deploy(Token.address);

})
it("should mint the token" ,async()=>{
await Token.connect(owner).mint(Token.address,100);
console.log("balance",await Token.balanceOf(owner.address));
})


it("should  stake the token",async()=>{
await Token.connect(owner).mint(owner.address,100);
await Token.connect(owner).approve(Access.address,100);
await Access.connect(owner).stake(3);


})


})

