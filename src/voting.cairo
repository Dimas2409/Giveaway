#[contract]
mod Vote {
    // Core Library Imports
    use starknet::ContractAddress;
    use starknet::get_caller_address;
    use array::ArrayTrait;

    // ------
    // Storage
    // ------
    struct Storage {
        yes_votes: u8,
        no_votes: u8,
        can_vote: LegacyMap::<ContractAddress, bool>,
        registered_voter: LegacyMap::<ContractAddress, bool>,
    }

    // ------
    // Constructor
    // ------

    // @dev constructor with a fixed number of registered voters (3)
    // @param voter_1 (ContractAddress): address of the first registered voter
    // @param voter_2 (ContractAddress): address of the second registered voter
    // @param voter_3 (ContractAddress): address of the third registered voter
    #[constructor]
    fn constructor(voter_1: ContractAddress, voter_2: ContractAddress, voter_3: ContractAddress) {
        // Register all voters by calling the _register_voters function
        _register_voters(voter_1, voter_2, voter_3);

        // Initialize the vote count to 0
        yes_votes::write(0_u8);
        no_votes::write(0_u8);
    }

    // ------
    // Getter functions
    // ------

    // @dev Return the number of yes and no votes
    // @return status (u8, u8): current status of the vote (yes votes, no votes)
    #[view]
    fn get_vote_status() -> (u8, u8) {
        // Read the number of yes votes and no votes from storage
        let n_yes = yes_votes::read();
        let n_no = no_votes::read();

        // Return the current voting status
        return (n_yes, n_no);
    }

    // @dev Returns if a voter can vote or not
    // @param user_address (ContractAddress): address of the voter
    // @return status (bool): true if the voter can vote, false otherwise
    #[view]
    fn voter_can_vote(user_address: ContractAddress) -> bool {
        // Read the voting status of the user from storage
        can_vote::read(user_address)
    }

    // @dev Return if an address is a voter or not (registered or not)
    // @param address (ContractAddress): address of possible voter
    // @return is_voter (bool): true if the address is a registered voter, false otherwise
    #[view]
    fn is_voter_registered(address: ContractAddress) -> bool {
        // Read the registration status of the address from storage
        registered_voter::read(address)
    }