//SPDX License-Identifier:MIT

pragma solidity >=0.6.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "hardhat/console.sol";

contract accessControl is Ownable, AccessControl {
    IERC20 public immutable token;
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE"); // for minter Role

    bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");

    constructor(address _token) onlyOwner {
        token = IERC20(_token);
        _setupRole(MINTER_ROLE, msg.sender);
    }

    struct Staker {
        uint amount;
        uint timestamp;
    }

    mapping(address => Staker) public stakers;
    mapping(address => uint) public balances;

    modifier onlyMinter() {
        require(hasRole(MINTER_ROLE, msg.sender), " cannot mint ");
        _;
    }

    modifier onlyBurner(bytes32 role) {
        require(hasRole(BURNER_ROLE, msg.sender));
        _;
    }

    function stake(uint amount) public onlyMinter {
        balances[msg.sender] = amount;
        token.balanceOf(address(this));
        token.transferFrom(msg.sender, address(this), 100);
        stakers[msg.sender].amount = amount;
        stakers[msg.sender].timestamp = block.timestamp;
    }

    // function burn(address owner) public onlyBurner {
    //     Token.balanceOf(address(this));
    //     token.burn(msg.sender, 100);
    // }
}

contract Token is ERC20 {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        _mint(msg.sender, 100);
    }

    function mint(address to, uint amount) public {
        _mint(to, amount);
    }
}
