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