
n = 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47

def modexp(x):
    """
    >>> modexp(3)
    4407920970296243842837207485651524041948558517760411303933
    """
    return pow(x, (n + 1) // 4, n)



def code_gen():
    for i in bin(0xc19139cb84c680a6e14116da060561765e05aa45a1c72a34f082305b61f3f52)[2:]:
        if i == "0":
            print("xx:= mulmod(xx, xx, n)")
        else:
            print("xx:= mulmod(mulmod(xx, xx, n), x, n)")

code_gen()