/// <reference path="../.astro/types.d.ts" />
/// <reference types="astro/client" />

import { MetaMaskInpageProvider } from '@metamask/providers';
import { Contract, TransactionResponse } from 'ethers';

declare global {
  interface Window {
    ethereum?: MetaMaskInpageProvider;
  }

  interface Counter extends Contract {
    incrementCounter(): Promise<TransactionResponse>;
    decrementCounter(): Promise<TransactionResponse>;
    getCount(): Promise<number>;
  }

  interface SimpleStorage extends Contract {
    get(): Promise<number>;
    set(x: number): Promise<TransactionResponse>;
  }
}
