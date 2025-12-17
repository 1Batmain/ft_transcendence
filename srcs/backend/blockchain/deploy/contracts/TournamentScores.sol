// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TournamentScores {
    address public owner;

    struct Result {
        bool exists;
        uint256 finalizedAt;
        string tournamentId;
        string winnerAlias;
        uint16 scoreLeft;
        uint16 scoreRight;
    }

    mapping(bytes32 => Result) private results;

    event TournamentFinalized(
        bytes32 indexed tournamentKey,
        string tournamentId,
        string winnerAlias,
        uint16 scoreLeft,
        uint16 scoreRight,
        uint256 finalizedAt
    );

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function _key(string memory tournamentId) internal pure returns (bytes32) {
        return keccak256(bytes(tournamentId));
    }

    function finalizeTournament(
        string calldata tournamentId,
        string calldata winnerAlias,
        uint16 scoreLeft,
        uint16 scoreRight
    ) external onlyOwner {
        bytes32 key = _key(tournamentId);
        require(!results[key].exists, "Already finalized");

        results[key] = Result({
            exists: true,
            finalizedAt: block.timestamp,
            tournamentId: tournamentId,
            winnerAlias: winnerAlias,
            scoreLeft: scoreLeft,
            scoreRight: scoreRight
        });

        emit TournamentFinalized(
            key,
            tournamentId,
            winnerAlias,
            scoreLeft,
            scoreRight,
            block.timestamp
        );
    }

    function getTournament(string calldata tournamentId)
        external
        view
        returns (
            bool exists,
            uint256 finalizedAt,
            string memory winnerAlias,
            uint16 scoreLeft,
            uint16 scoreRight
        )
    {
        bytes32 key = _key(tournamentId);
        Result storage r = results[key];
        return (r.exists, r.finalizedAt, r.winnerAlias, r.scoreLeft, r.scoreRight);
    }
}
