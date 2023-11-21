// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DecentralizedTicketing is Ownable {
    using SafeERC20 for IERC20;

    IERC20 public ticketToken;

    uint256 public ticketPrice;
    uint256 public totalTickets;
    uint256 public ticketsSold;

    mapping(address => uint256) public ticketsPurchased;

    event TicketPurchased(address indexed buyer, uint256 numTickets);

    modifier enoughTicketsAvailable(uint256 _numTickets) {
        require(ticketsSold + _numTickets <= totalTickets, "Not enough tickets available");
        _;
    }

    constructor(address _ticketToken, uint256 _ticketPrice, uint256 _totalTickets) {
        require(_ticketToken != address(0), "Invalid token address");
        require(_ticketPrice > 0, "Ticket price must be greater than 0");
        require(_totalTickets > 0, "Total tickets must be greater than 0");

        ticketToken = IERC20(_ticketToken);
        ticketPrice = _ticketPrice;
        totalTickets = _totalTickets;
    }
function purchaseTickets(uint256 _numTickets) external enoughTicketsAvailable(_numTickets) {
        require(_numTickets > 0, "Number of tickets must be greater than 0");

        uint256 totalCost = ticketPrice * _numTickets;

        // Transfer ticket tokens from the buyer to the contract
        ticketToken.safeTransferFrom(msg.sender, address(this), totalCost);

        // Update buyer's ticket count
        ticketsPurchased[msg.sender] += _numTickets;

        // Update total tickets sold
        ticketsSold += _numTickets;

        emit TicketPurchased(msg.sender, _numTickets);
    }
function getTicketsPurchased(address _buyer) external view returns (uint256) {
        return ticketsPurchased[_buyer];
    }
function getTicketDetails() external view returns (uint256, uint256, uint256, uint256) {
        return (ticketPrice, totalTickets, ticketsSold, block.timestamp);
    }
}
