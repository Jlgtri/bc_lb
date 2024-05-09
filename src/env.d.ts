/// <reference path="../.astro/types.d.ts" />
/// <reference types="astro/client" />

import { MetaMaskInpageProvider } from '@metamask/providers';
import { Contract, TransactionResponse } from 'ethers';


declare global {
  interface ImportMetaEnv {
    readonly PUBLIC_CHAIN_ID: string;
  }

  interface ImportMeta {
    readonly env: ImportMetaEnv;
  }

  interface Window {
    readonly ethereum?: MetaMaskInpageProvider;
  }

  interface Counter extends Contract {
    readonly incrementCounter(): Promise<TransactionResponse>;
    readonly decrementCounter(): Promise<TransactionResponse>;
    readonly getCount(): Promise<number>;
  }

  interface SimpleStorage extends Contract {
    readonly set(x: number): Promise<TransactionResponse>;
    readonly get(): Promise<number>;
  }

  interface Candidate {
    id: number?;

    name: string;
    lastName: string;
    patronymic: string;
    info: string;

    voteCount: number?;
  }

  interface Election extends Contract {
    readonly addCandidate(
      _lastName: string,
      _name: string,
      _patronymic: string,
      info: string,
    ): Promise<TransactionResponse>;
    readonly vote(_candidateId: number): Promise<TransactionResponse>;

    readonly candidates(number: number): Promise<Candidate>;
    readonly candidatesCount(): Promise<number>;
    readonly voters(address: string): Promise<boolean>;
    readonly winningProposal(): Promise<number>;
  }

  interface Payment extends Contract {
    readonly payBill(address: string, ...options): Promise<TransactionResponse>;

    readonly getBalance(): Promise<number>;
    readonly transactionAmount(): Promise<bigint>;
    readonly transactionCount(): Promise<number>;
  }

  interface VendingMachine extends Contract {
    readonly purchase(amount: number, ...options): Promise<TransactionResponse>;
    readonly refill(amount: number): Promise<TransactionResponse>;

    readonly cupcakeBalances(address: string): Promise<number>;
    readonly owner(): Promise<string>;
  }

  interface LockedFunds extends Contract {
    readonly deposit(...options): Promise<TransactionResponse>;
    readonly withdraw(): Promise<TransactionResponse>;

    readonly deposits(address: string): Promise<bigint>;
    readonly getBalanceAccount(address: string): Promise<bigint>;
    readonly getDeposit(address: string): Promise<bigint>;
    readonly getTimestamp(): Promise<bigint>;
    readonly lockTime(): Promise<bigint>;
    readonly owner(): Promise<string>;
  }
}
