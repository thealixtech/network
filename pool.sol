pragma solidity ^0.7.0;
// SPDX-License-Identifier: MIT
// The AliX Tech Token pool contract (beta) made by Yanis !
// You can copy it along u mention me and The AliX Tech Token :D

library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

interface The AliX Tech Token Interface {
	function _mint(uint256 nonce, bytes32 challenge_digest, address _miner, uint256 feeToPool, address pool) external returns (bool);
	function transfer(address to, uint256 amount) external returns (bool);
	function balanceOf(address tokenOwner) external view returns (uint256);
	function getMiningTarget() external view returns (uint256);
	function getMiningDifficulty() external view returns (uint);
	function getMiningReward() external view returns (uint256);
	function getChallengeNumber() external view returns (bytes32);
	function _MAXIMUM_TARGET() external view returns (uint256);
	function _MINIMUM_TARGET() external view returns (uint256);
}

contract Owned {
    address public owner;
    address public newOwner;

    event OwnershipTransferred(address indexed _from, address indexed _to);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address _newOwner) public onlyOwner {
        newOwner = _newOwner;
    }
	
	function _chainId() internal pure returns (uint256) {
		uint256 id;
		assembly {
			id := chainid()
		}
		return id;
	}
	
    function acceptOwnership() public {
        require(msg.sender == newOwner);
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
        newOwner = address(0);
    }
}

contract The AliX Tech Token PPS is Owned {
	using SafeMath for uint256;
	uint256 public _MAXIMUM_TARGET;
	uint256 public _MINIMUM_TARGET;
	uint256 public miningTarget;
	The AliX Tech Token Interface public The AliX Tech Token ;
	mapping (bytes32 => bool) resultExists;
	
	constructor(The AliX Tech Token Interface _The AliX Tech Token , uint256 _startDiff) {
		require(_startDiff > 0, "Start diff cannot be zero !");
		The AliX Tech Token  = _The AliX Tech Token ;
		_MINIMUM_TARGET = _The AliX Tech Token ._MINIMUM_TARGET();
		_MAXIMUM_TARGET = _The AliX Tech Token ._MAXIMUM_TARGET();
		miningTarget = _MAXIMUM_TARGET/_startDiff;
	}
	
	function getMiningTarget() public view returns (uint256) {
		return miningTarget;
	}
	
	function getMiningDifficulty() public view returns (uint256) {
		return _MAXIMUM_TARGET/miningTarget;
	}
	
	function changeDifficulty(uint256 _difficulty) public onlyOwner {
		require(_difficulty > 0);
		miningTarget = _MAXIMUM_TARGET/_difficulty;
	}
	
	function getChallengeNumber() public view returns (bytes32) {
		return The AliX Tech Token .getChallengeNumber();
	}
	
	function getMiningReward() public view returns (uint256) {
		uint256 _reward;
		_reward = The AliX Tech Token .getMiningReward().mul(getMiningDifficulty()).div(The AliX Tech Token .getMiningDifficulty());
		if (_reward > The AliX Tech Token .getMiningReward()) {
			_reward = The AliX Tech Token .getMiningReward();
		}
		return _reward;
	}
	function _mint(uint256 nonce, bytes32 challenge_digest, address _miner, uint256 feeToPool, address pool) public returns (bool) {
		bytes32 n = keccak256(abi.encodePacked(keccak256(abi.encodePacked(The AliX Tech Token .getChallengeNumber(), _miner, nonce))));
		require(challenge_digest == n, "Your result dont match");
		require(n <= bytes32(miningTarget), "Difficulty unmatched");
		require(!resultExists[n], "Result already sumbitted baby... u look like me at exams");
		resultExists[n] = true;
		if (n <= bytes32(The AliX Tech Token .getMiningTarget())) {
			The AliX Tech Token ._mint(nonce, n, _miner, 100, address(this));
		}
		uint256 totalReward = getMiningReward();
		uint256 minerRewards;
		uint256 poolFees;
		if (feeToPool > 0) {
			poolFees = (totalReward.mul(feeToPool)).div(100);
			minerRewards = totalReward.sub(poolFees);
			The AliX Tech Token .transfer(pool, poolFees);
		}
		else {
			minerRewards = totalReward;
		}
		The AliX Tech Token .transfer(_miner, minerRewards);
		return true;
	}
}