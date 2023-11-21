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


}
