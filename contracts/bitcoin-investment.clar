;; Title: Decentralized Autonomous Organization (DAO) Contract
;; 
;; Summary:
;; A comprehensive DAO implementation that enables decentralized governance through
;; token staking, proposal creation, and voting mechanisms. Members can stake STX
;; tokens to participate in governance, create proposals, and vote on them.
;;
;; Description:
;; This contract implements core DAO functionality including:
;; - Member management through token staking/unstaking
;; - Proposal lifecycle (creation, voting, execution)
;; - Configurable parameters (quorum, proposal duration, minimum proposal amount)
;; - Secure voting with proper access controls
;; - Treasury management for proposal execution

;; Error Codes
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-INVALID-AMOUNT (err u101))
(define-constant ERR-PROPOSAL-NOT-FOUND (err u102))
(define-constant ERR-ALREADY-VOTED (err u103))
(define-constant ERR-PROPOSAL-EXPIRED (err u104))
(define-constant ERR-INSUFFICIENT-BALANCE (err u105))
(define-constant ERR-PROPOSAL-NOT-ACTIVE (err u106))
(define-constant ERR-INVALID-STATUS (err u107))
(define-constant ERR-INVALID-OWNER (err u108))
(define-constant ERR-INVALID-TITLE (err u109))
(define-constant ERR-INVALID-DESCRIPTION (err u110))
(define-constant ERR-INVALID-RECIPIENT (err u111))

;; Governance Parameters
(define-data-var dao-owner principal tx-sender)
(define-data-var total-staked uint u0)
(define-data-var proposal-count uint u0)
(define-data-var quorum-threshold uint u500) ;; 50% in basis points
(define-data-var proposal-duration uint u144) ;; ~24 hours in blocks
(define-data-var min-proposal-amount uint u1000000) ;; Minimum STX required for proposal creation

;; Data Structures
;; Tracks member participation and rewards
(define-map members 
    principal 
    {
        staked-amount: uint,
        last-reward-block: uint,
        rewards-claimed: uint
    }
)

;; Stores proposal details and current state
(define-map proposals 
    uint 
    {
        proposer: principal,
        title: (string-ascii 100),
        description: (string-ascii 500),
        amount: uint,
        recipient: principal,
        start-block: uint,
        end-block: uint,
        yes-votes: uint,
        no-votes: uint,
        status: (string-ascii 20),
        executed: bool
    }
)

;; Records member votes on proposals
(define-map votes 
    {proposal-id: uint, voter: principal} 
    {vote: bool}
)

;; Authorization Functions
(define-private (is-dao-owner)
    (is-eq tx-sender (var-get dao-owner))
)

(define-private (is-member (address principal))
    (match (map-get? members address)
        member (> (get staked-amount member) u0)
        false
    )
)

;; Validation Functions
(define-private (validate-string-ascii (input (string-ascii 500)))
    (and 
        (not (is-eq input ""))
        (<= (len input) u500)
    )
)

(define-private (validate-principal (address principal))
    (and
        (not (is-eq address tx-sender))
        (not (is-eq address (as-contract tx-sender)))
    )
)