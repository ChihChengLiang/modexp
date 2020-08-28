import { ethers } from "@nomiclabs/buidler";
import { assert } from "chai";
import { Contract, Signer } from "ethers";
import BN from "bn.js";

const MODEXP_3 = "4407920970296243842837207485651524041948558517760411303933";
const n = new BN("30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47", 16);
const v = new BN("c19139cb84c680a6e14116da060561765e05aa45a1c72a34f082305b61f3f52", 16);

function modexp(x: Uint8Array) {
    const hex_no0x = ethers.utils.hexlify(x).slice(2);
    const x_bn = new BN(hex_no0x, 16);
    const reductionContext = BN.red(n);
    return x_bn.toRed(reductionContext).redPow(v).fromRed().toString(10);
}

function reportCost(costs: number[]) {
    const avg: number =
        costs.reduce((a: number, b: number) => {
            return a + b;
        }, 0) / costs.length;
    console.log("Avg cost", avg);
}

describe("Ts implementation", function () {
    it("works at some inputs", function () {
        assert.equal(modexp(ethers.utils.arrayify(3)), MODEXP_3);
    });
});

describe("ModExp", function () {
    let accounts: Signer[];
    let contract: Contract;
    let randomBytes: Uint8Array[] = [];

    before(async function () {
        accounts = await ethers.getSigners();
        const factory = await ethers.getContractFactory("TestModExp", accounts[0]);
        contract = await factory.deploy();
        const receipt = await contract.deployTransaction.wait();
        console.log("Deployment gas", receipt.gasUsed.toString());
        for (let i = 0; i < 16; i++) {
            randomBytes.push(ethers.utils.randomBytes(32));
        }
    });

    it("modexp 1: Naive Solidity", async function () {
        const [result] = await contract.modexp(3);
        assert.equal(result, MODEXP_3);
        const costs: number[] = [];
        for (const input of randomBytes) {
            const [output, cost] = await contract.modexp(input);
            assert.equal(output, modexp(input), "Mismatch output");
            costs.push(Number(cost));
        }
        reportCost(costs);
    });

    it("modexp 2: Naive inline assembly", async function () {
        const [result] = await contract.modexp2(3);
        assert.equal(result, MODEXP_3);
        const costs: number[] = [];
        for (const input of randomBytes) {
            const [output, cost] = await contract.modexp2(input);
            assert.equal(output, modexp(input), "Mismatch output");
            costs.push(Number(cost));
        }
        reportCost(costs);
    });

    it("modexp 3: Loop unroll", async function () {
        const [result] = await contract.modexp3(3);
        assert.equal(result, MODEXP_3);
        const costs: number[] = [];
        for (const input of randomBytes) {
            const [output, cost] = await contract.modexp3(input);
            assert.equal(output, modexp(input), "Mismatch output");
            costs.push(Number(cost));
        }
        reportCost(costs);
    });

    it("modexp 4: Minor optimize", async function () {
        const [result] = await contract.modexp4(3);
        assert.equal(result, MODEXP_3);
        const costs: number[] = [];
        for (const input of randomBytes) {
            const [output, cost] = await contract.modexp4(input);
            assert.equal(output, modexp(input), "Mismatch output");
            costs.push(Number(cost));
        }
        reportCost(costs);
    });

    it("modexp 5: Unroll more", async function () {
        const [result] = await contract.modexp5(3);
        assert.equal(result, MODEXP_3);
        const costs: number[] = [];
        for (const input of randomBytes) {
            const [output, cost] = await contract.modexp5(input);
            assert.equal(output, modexp(input), "Mismatch output");
            costs.push(Number(cost));
        }
        reportCost(costs);
    });

    it("modexp 6: Remove if statement", async function () {
        const [result] = await contract.modexp6(3);
        assert.equal(result, MODEXP_3);
        const costs: number[] = [];
        for (const input of randomBytes) {
            const [output, cost] = await contract.modexp6(input);
            assert.equal(output, modexp(input), "Mismatch output");
            costs.push(Number(cost));
        }
        reportCost(costs);
    });

    it("modexp 7: Reproduce historical result", async function () {
        const [result] = await contract.modexp7(3);
        assert.equal(result, MODEXP_3);
        const costs: number[] = [];
        for (const input of randomBytes) {
            const [output, cost] = await contract.modexp7(input);
            assert.equal(output, modexp(input), "Mismatch output");
            costs.push(Number(cost));
        }
        reportCost(costs);
    });
});

describe("ModExp Monster code", function () {
    it("modexp 8: monster code", async function () {
        const accounts = await ethers.getSigners();
        const factory = await ethers.getContractFactory("Monster", accounts[0]);
        const contract = await factory.deploy();
        const receipt = await contract.deployTransaction.wait();
        console.log("Deployment gas", receipt.gasUsed.toString());

        const randomBytes: Uint8Array[] = [];

        for (let i = 0; i < 16; i++) {
            randomBytes.push(ethers.utils.randomBytes(32));
        }

        const [result] = await contract.test_modexp(3);
        assert.equal(result, MODEXP_3);
        const costs: number[] = [];
        for (const input of randomBytes) {
            const [output, cost] = await contract.test_modexp(input);
            assert.equal(output, modexp(input), "Mismatch output");
            costs.push(Number(cost));
        }
        reportCost(costs);
    });
});

describe("Addchain", function () {
    it("modexp 9: use addchain", async function () {
        const accounts = await ethers.getSigners();
        const factory = await ethers.getContractFactory("AddChain", accounts[0]);
        const contract = await factory.deploy();
        const receipt = await contract.deployTransaction.wait();
        console.log("Deployment gas", receipt.gasUsed.toString());

        const randomBytes: Uint8Array[] = [];

        for (let i = 0; i < 16; i++) {
            randomBytes.push(ethers.utils.randomBytes(32));
        }

        const [result] = await contract.test_modexp(3);
        assert.equal(result, MODEXP_3);
        const costs: number[] = [];
        for (const input of randomBytes) {
            const [output, cost] = await contract.test_modexp(input);
            assert.equal(output, modexp(input), "Mismatch output");
            costs.push(Number(cost));
        }
        reportCost(costs);
    });
});
