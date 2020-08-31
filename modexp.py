n = 0x30644E72E131A029B85045B68181585D97816A916871CA8D3C208C16D87CFD47


def modexp(x):
    """
    >>> modexp(3)
    4407920970296243842837207485651524041948558517760411303933
    """
    return pow(x, (n + 1) // 4, n)


def code_gen():
    for i in bin(0xC19139CB84C680A6E14116DA060561765E05AA45A1C72A34F082305B61F3F52)[2:]:
        if i == "0":
            print("xx:= mulmod(xx, xx, n)")
        else:
            print("xx:= mulmod(mulmod(xx, xx, n), x, n)")


code_gen()
