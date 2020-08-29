from misc_crypto.utils.assembly import Contract
from web3 import Web3, EthereumTesterProvider
from eth_utils import decode_hex
import random


def to_32bytes(x: int):
    return x.to_bytes(32, "big")


# adapted from poseidon contract helper func
def check_selector(contract: Contract, signature4bytes: str, dest_label: str) -> None:
    """
    Check if the evm message selects the correct function's 4 bytes signature
    """
    (
        contract.push(b"\x01" + b"\x00" * 28)
            .push(0)
            .calldataload()
            .div()
            .push(signature4bytes)
            .eq()
            .jmpi(dest_label)
            .invalid()
    )


def code_gen_stack_magic():
    # VERY experimental, untested. Just a code-golf idea. By @protolambda
    # needs some work to utilize in solidity. DUP opcodes are great, but a problem to embed

    # TLDR from telegram:
    # - push n and x on stack to get started
    # - lots of DUPN operations, preparing a stack of 472 copies (within max stack size, I think), ordered exactly to repeatedly call mulmod on.
    #   Since there are only two cases: (xx x n) and (xx xx n), with trailing stack items that can be prepared.
    # - keep running mulmod until the stack is back to normal. Sometimes you need to dup the previous result (the xx xx n argument case)
    # - 472*3 (dup cost) + 362*8 (mulmod cost) = 5062 gas. Plus a little to put the result back in the function return data.

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

    contract = Contract()

    function_signature = 'modexp(uint256)'
    function_selector = Web3.keccak(function_signature.encode()).hex()[:10]
    print(f'function: {function_signature} selector: {function_selector}')
    check_selector(contract, function_selector, "start")

    contract.label("start")

    # N = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47
    # (N + 1) / 4 = 0xc19139cb84c680a6e14116da060561765e05aa45a1c72a34f082305b61f3f52
    bits = bin(0xc19139cb84c680a6e14116da060561765e05aa45a1c72a34f082305b61f3f52)[2:]

    # load x
    # [Selector (4)] [data1 (32)]
    contract.push(0x04).calldataload()

    # load n
    contract.push('0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47')

    # stack filling preparation
    prev_stack_vars = ['x', 'n']

    # prepare stack
    # The last preparations get consumed first, so iterate the bits in reverse order.
    for original_index, bit_value in reversed(list(enumerate(bits))):
        print(f"preparing bit: index: {original_index} value: {bit_value}")

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
            distance_n = list(reversed(prev_stack_vars)).index('n')
            if distance_n > 15:
                raise Exception("unlucky bit pattern, no 'n' within range to DUP. Need to mload, unhandled")
            # add 'n', by duplicating last 'n' value
            contract.dup(distance_n+1)
            prev_stack_vars.append('n')

            distance_x = list(reversed(prev_stack_vars)).index('x')
            if distance_x > 15:
                raise Exception("unlucky bit pattern, no 'x' within range to DUP. Need to mload, unhandled")
            # add 'x', by duplicating last 'x' value
            contract.dup(distance_x+1)
            prev_stack_vars.append('x')

        # prepare case I: push 'n' to the stack
        distance_n = list(reversed(prev_stack_vars)).index('n')
        if distance_n > 15:
            raise Exception("unlucky bit pattern, no 'n' within range to DUP. Need to mload, unhandled")
        # add 'n', by duplicating last 'n' value
        contract.dup(distance_n+1)
        prev_stack_vars.append('n')

    print(f"prepared stack size: {len(prev_stack_vars)}")

    # done preparing stack, now write the mulmod and dup operations to interpret this all
    # add initial xx value to the stack
    contract.push(to_32bytes(1))

    # work through stack next:
    for i, v in enumerate(bits):
        print(f"bit {i}, value {v}")
        # stack is prepared, just need to run the calculations.
        #                    stack: ....... n xx
        contract.dup(1)    # stack: ....... n xx xx
        contract.mulmod()  # stack: ....... xx'
        if v == "1":
            #                    stack: ... n x xx'
            contract.mulmod()  # stack: ... xx''

    # stack: x n xx

    # done working through stack
    # get stack back to normal, with result in stack 0
    contract.swap(2)  # stack: xx n x

    contract.pop().pop()  # stack: xx
    contract.push(0)      # stack: xx 0
    contract.mstore()     # stack: (empty). Memory[0]: xx
    # Return 32 bytes from memory
    contract.push(0x20)
    contract.push(0x00)
    contract.return_()

    print(contract.create_tx_data())
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


def build_contract():
    contract = code_gen_stack_magic()

    w3 = Web3(EthereumTesterProvider())
    contract = w3.eth.contract(abi=ABI, bytecode=decode_hex(contract.create_tx_data()))
    tx_hash = contract.constructor().transact()
    tx_receipt = w3.eth.waitForTransactionReceipt(tx_hash)
    instance = w3.eth.contract(address=tx_receipt.contractAddress, abi=ABI)

    output = instance.functions.modexp(3).call()
    print(f'output: {output}')
    assert output == 4407920970296243842837207485651524041948558517760411303933

    n = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47

    def pymodexp(x: int) -> int:
        return pow(x, (n + 1) // 4, n)

    test_count = 30
    rng = random.Random(123)
    random_cases = [rng.randrange(0, 2**256) for _ in range(test_count)]
    for x in random_cases:
        output = instance.functions.modexp(x).call()
        expected = pymodexp(x)
        print(f'x: {x}\noutput: {output}\nexpected: {expected}\n')
        assert output == expected


build_contract()
