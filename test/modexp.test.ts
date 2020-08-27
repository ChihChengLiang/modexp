import { ethers } from "@nomiclabs/buidler";
import { assert } from "chai";
import { Contract, Signer, BigNumberish } from "ethers";

const MODEXP_3 = "4407920970296243842837207485651524041948558517760411303933";

function reportCost(costs: number[]) {
    const avg: number =
        costs.reduce((a: number, b: number) => {
            return a + b;
        }, 0) / costs.length;
    console.log("Avg cost", avg);
}

describe("ModExp", function () {
    let accounts: Signer[];
    let contract: Contract;
    let randomBytes: Uint8Array[] = [];

    before(async function () {
        for (let i = 0; i < 16; i++) {
            randomBytes.push(ethers.utils.randomBytes(32));
        }
    });

    beforeEach(async function () {
        accounts = await ethers.getSigners();
        const factory = await ethers.getContractFactory("TestModExp", accounts[0]);
        contract = await factory.deploy();
    });

    it("modexp 1", async function () {
        const [result] = await contract.modexp(3);
        assert.equal(result, MODEXP_3);
        const costs: number[] = [];
        for (const input of randomBytes) {
            const [, cost] = await contract.modexp(input);
            costs.push(Number(cost));
        }
        reportCost(costs);
    });

    it("modexp 2", async function () {
        const [result] = await contract.modexp2(3);
        assert.equal(result, MODEXP_3);
        const costs: number[] = [];
        for (const input of randomBytes) {
            const [, cost] = await contract.modexp2(input);
            costs.push(Number(cost));
        }
        reportCost(costs);
    });

    it("modexp 3", async function () {
        const [result] = await contract.modexp3(3);
        assert.equal(result, MODEXP_3);
        const costs: number[] = [];
        for (const input of randomBytes) {
            const [, cost] = await contract.modexp3(input);
            costs.push(Number(cost));
        }
        reportCost(costs);
    });

    it("modexp 4", async function () {
        const [result] = await contract.modexp4(3);
        assert.equal(result, MODEXP_3);
        const costs: number[] = [];
        for (const input of randomBytes) {
            const [, cost] = await contract.modexp4(input);
            costs.push(Number(cost));
        }
        reportCost(costs);
    });

    it("modexp 5", async function () {
        const [result] = await contract.modexp5(3);
        assert.equal(result, MODEXP_3);
        const costs: number[] = [];
        for (const input of randomBytes) {
            const [, cost] = await contract.modexp5(input);
            costs.push(Number(cost));
        }
        reportCost(costs);
    });

    it("modexp 6", async function () {
        const [result] = await contract.modexp6(3);
        assert.equal(result, MODEXP_3);
        const costs: number[] = [];
        for (const input of randomBytes) {
            const [, cost] = await contract.modexp6(input);
            costs.push(Number(cost));
        }
        reportCost(costs);
    });

    it("modexp 7", async function () {
        const [result] = await contract.modexp7(3);
        assert.equal(result, MODEXP_3);
        const costs: number[] = [];
        for (const input of randomBytes) {
            const [, cost] = await contract.modexp7(input);
            costs.push(Number(cost));
        }
        reportCost(costs);
    });
});
