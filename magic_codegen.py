import random
from typing import List, Sequence

import pytest
from eth_utils import decode_hex
from misc_crypto.utils.assembly import Contract
from web3 import EthereumTesterProvider, Web3

n = 0x30644E72E131A029B85045B68181585D97816A916871CA8D3C208C16D87CFD47


def to_32bytes(x: int):
    return x.to_bytes(32, "big")


def get_function_selector(function_signature: str) -> str:
    return Web3.keccak(function_signature.encode()).hex()[:10]


def pymodexp(x: int) -> int:
    return pow(x, (n + 1) // 4, n)


class ImprovedContract(Contract):
    prev_stack_vars: List[str]

    def init_stack_vars(self, init_stack_vars: Sequence[str]) -> None:
        self.prev_stack_vars = []
        for var in init_stack_vars:
            self.prev_stack_vars.append(var)

    # adapted from poseidon contract helper func
    def check_selector(self, signature4bytes: str, dest_label: str) -> None:
        """
        Check if the evm message selects the correct function's 4 bytes signature
        """
        (
            self.push(b"\x01" + b"\x00" * 28)
            .push(0)
            .calldataload()
            .div()
            .push(signature4bytes)
            .eq()
            .jmpi(dest_label)
            .invalid()
        )

    def try_dup(self, var: str):
        distance = list(reversed(self.prev_stack_vars)).index(var)
        if distance > 15:
            raise Exception(
                "unlucky bit pattern, no 'n' within range to DUP. Need to mload, unhandled"
            )
        # add 'n', by duplicating last 'n' value
        self.dup(distance + 1)
        self.prev_stack_vars.append(var)

    @property
    def stack_size(self):
        return len(self.prev_stack_vars)


def code_gen_stack_magic(return_gas=False):
    # VERY experimental, but passing some tests. Gas-golfed by @protolambda.
    # Thanks to @ChihChengLiang for providing the contract bytecode builder util, and a good start (Monster.sol is 7133 gas)
    # Needs some work to utilize in solidity. DUP opcodes are great, but a problem to embed

    # TLDR:
    # - push n and x on stack to get started
    # - lots of DUPN operations, preparing a stack of 472 copies (within max stack size, I think), ordered exactly to repeatedly call mulmod on.
    #   Since there are only two cases: (xx x n) and (xx xx n), with trailing stack items that can be prepared.
    # - keep running mulmod until the stack is back to normal. Sometimes you need to dup the previous result (the xx xx n argument case)
    # - 472*3 (dup cost) + 362*8 (mulmod cost) = 5062 gas. Plus a little for start (put x and n on stack) costs.

    # solidity assembly docs:
    # mulmod(x, y, m) 	  	F 	(x * y) % m with arbitrary precision arithmetic
    # yellow paper:
    # MULMOD = (s_0 * s_1) % s_2

    # case I: mulmod(xx, xx, n)
    # setup: n
    # *prev instructions*
    # pre: n xx
    #      dup1
    #  in: n xx xx
    #      mulmod
    # out: xx

    # case II: mulmod(xx, x, n)
    # setup: n x
    # *prev instructions*
    # pre: n x xx
    #  in: n x xx
    #      mulmod
    # out: xx

    contract = ImprovedContract()

    contract.check_selector(get_function_selector("modexp(uint256)"), "start")

    contract.label("start")

    if return_gas:
        contract.gas()  # stack: <pre-gas>

    # N = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
    # (N + 1) / 4 = 0xc19139cb84c680a6e14116da060561765e05aa45a1c72a34f082305b61f3f52
    bits = bin(0xC19139CB84C680A6E14116DA060561765E05AA45A1C72A34F082305B61F3F52)[2:]

    # load x
    # [Selector (4)] [data1 (32)]
    contract.push(0x04).calldataload()

    # load n
    contract.push(str(hex(n)))

    # stack filling preparation
    contract.init_stack_vars(["x", "n"])

    # prepare stack
    # The last preparations get consumed first, so iterate the bits in reverse order.
    for original_index, bit_value in reversed(list(enumerate(bits))):

        # what is being prepared (works like the "monster" code):
        # if i == "0":
        #     print("xx:= mulmod(xx, xx, n)")
        # else:
        #     print("xx:= mulmod(mulmod(xx, xx, n), x, n)")
        #

        # reverse order: prepare mulmod(result, x, n) before preparing mulmod(xx, xx, n)
        # the last thing gets consumed first.
        if bit_value == "1":
            # prepare case II: push 'n' to the stack, then push 'x' to the stack
            contract.try_dup("n")
            contract.try_dup("x")

        # prepare case I: push 'n' to the stack
        contract.try_dup("n")

    print(f"prepared stack size: {contract.stack_size}")

    # done preparing stack, now write the mulmod and dup operations to interpret this all
    # add initial xx value to the stack
    contract.push(to_32bytes(1))

    # work through stack next:
    for i, v in enumerate(bits):
        # stack is prepared, just need to run the calculations.
        #                    stack: ....... n xx
        contract.dup(1)  # stack: ....... n xx xx
        contract.mulmod()  # stack: ....... xx'
        if v == "1":
            #                    stack: ... n x xx'
            contract.mulmod()  # stack: ... xx''

    # stack: x n xx

    # done working through stack
    # get stack back to normal, with result in stack 0
    contract.swap(2)  # stack: xx n x

    contract.pop().pop()  # stack: xx

    if return_gas:
        # stack is actually: <pre-gas> xx
        contract.gas()  # stack: <pre-gas> <result> <post-gas>
        contract.dup(3)  # stack: <pre-gas> <result> <post-gas> <pre-gas>
        contract.sub()  # stack: <pre-gas> <result> <gas diff>
        contract.swap(2).pop()  # stack: <gas diff> <result>

        contract.push(0)  # stack: <gas diff> <result> 0
        contract.mstore()  # stack: <gas diff>. Memory[0]: <result>

        contract.push(0x20)  # stack: <gas diff> 32
        contract.mstore()  # stack: (empty). Memory[0]: <result>, Memory[1]: <gas diff>

        # Return 64 bytes from memory
        contract.push(0x40)
        contract.push(0x00)
        contract.return_()
    else:
        contract.push(0)  # stack: xx 0
        contract.mstore()  # stack: (empty). Memory[0]: xx
        # Return 32 bytes from memory
        contract.push(0x20)
        contract.push(0x00)
        contract.return_()

    return contract


ABI = [
    {
        "constant": True,
        "inputs": [{"name": "input", "type": "uint256"}],
        "name": "modexp",
        "outputs": [{"name": "", "type": "uint256"}],
        "payable": False,
        "stateMutability": "pure",
        "type": "function",
    }
]

ABI_RETURN_GAS = [
    {
        "constant": True,
        "inputs": [{"name": "input", "type": "uint256"}],
        "name": "modexp",
        "outputs": [
            {"name": "xx", "type": "uint256"},
            {"name": "gas", "type": "uint256"},
        ],
        "payable": False,
        "stateMutability": "pure",
        "type": "function",
    }
]


TEST_COUNT = 30


@pytest.mark.parametrize("debug_gas", (False, True))
def test_build_contract(debug_gas):
    contract = code_gen_stack_magic(debug_gas)
    abi = ABI_RETURN_GAS if debug_gas else ABI

    w3 = Web3(EthereumTesterProvider())
    contract = w3.eth.contract(abi=abi, bytecode=decode_hex(contract.create_tx_data()))
    tx_hash = contract.constructor().transact()
    tx_receipt = w3.eth.waitForTransactionReceipt(tx_hash)
    instance = w3.eth.contract(address=tx_receipt.contractAddress, abi=abi)

    gases = []

    def contract_modexp(x: int) -> int:
        if debug_gas:
            out, gas = instance.functions.modexp(x).call()
            gases.append(gas)
        else:
            out = instance.functions.modexp(x).call()
        return out

    assert (
        contract_modexp(3) == 4407920970296243842837207485651524041948558517760411303933
    )

    rng = random.Random(123)
    random_cases = [rng.randrange(0, 2 ** 256) for _ in range(TEST_COUNT)]

    for x in random_cases:
        assert contract_modexp(x) == pymodexp(x)
    if debug_gas:
        print("Average gas", sum(gases) / len(gases))
