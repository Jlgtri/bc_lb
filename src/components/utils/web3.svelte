<script lang="ts" context="module">
  import {
    BrowserProvider,
    Contract,
    Interface,
    getDefaultProvider,
    toBeHex,
    type Eip1193Provider,
    type InterfaceAbi,
  } from 'ethers';

  export async function switchChain(
    chainId: string = import.meta.env.PUBLIC_CHAIN_ID,
  ) {
    if (!window.ethereum || window.ethereum.networkVersion == chainId) return;

    try {
      await window.ethereum.request({
        method: 'wallet_switchEthereumChain',
        params: [{ chainId: toBeHex(chainId) }],
      });
    } catch (exception) {
      // This error code indicates that the chain has not been added to MetaMask
      if (exception !== 4902) {
        return console.log((exception as Error).message);
      }

      await window.ethereum.request({
        method: 'wallet_addEthereumChain',
        params: [
          {
            chainName: 'Sepolia',
            chainId: toBeHex(chainId),
            nativeCurrency: {
              name: 'ETH',
              decimals: 18,
              symbol: 'ETH',
            },
            rpcUrls: ['https://rpc.sepolia.org'],
          },
        ],
      });
    }
  }

  export async function getContract(
    address: string,
    abi: Interface | InterfaceAbi,
  ) {
    if (!window.ethereum || !window.ethereum.isConnected()) {
      alert(
        'MetaMask не встановлено; ' +
          'використовуючи значення за замовчуванням лише для читання',
      );
      let provider = getDefaultProvider('sepolia');
      return new Contract(address, abi, provider);
    }

    await switchChain();
    let provider = new BrowserProvider(window.ethereum as Eip1193Provider);
    const signer = await provider.getSigner();
    return new Contract(address, abi, signer);
  }
</script>
