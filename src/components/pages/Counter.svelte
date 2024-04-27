<script lang="ts">
  import {
    BrowserProvider,
    Contract,
    TransactionResponse,
    getAddress,
    getDefaultProvider,
    type Eip1193Provider,
  } from 'ethers';
  import daiAbi from '../../abis/Counter.json';

  import { createEventDispatcher } from 'svelte';
  import Buttons from '../components/Buttons.svelte';
  import Input from '../components/Input.svelte';

  const dispatch = createEventDispatcher();

  $: count = 0;
  $: error = '';

  let daiContract: Counter | null;
  $: daiContract = null;

  let daiAddress: string;
  $: daiAddress = '';

  async function getDaiContract(_daiAddress: string | null = null) {
    try {
      error = '';
      daiAddress = getAddress(_daiAddress || '');
    } catch {
      daiContract = null;
      count = 0;
      error = 'Адрес не вірний';
      return;
    }

    if (!window.ethereum) {
      alert(
        'MetaMask не встановлено; ' +
          'використовуючи значення за замовчуванням лише для читання',
      );
      let provider = getDefaultProvider('goerli');
      daiContract = new Contract(daiAddress, daiAbi, provider) as Counter;
    }

    let provider = new BrowserProvider(window.ethereum as Eip1193Provider);
    const signer = await provider.getSigner();
    daiContract = new Contract(daiAddress, daiAbi, signer) as Counter;

    count = Number(await daiContract!.getCount());
  }

  async function transaction(tx: TransactionResponse) {
    dispatch('load', true);
    try {
      console.log(await tx.wait());
      count = Number(await daiContract!.getCount());
    } catch {
      alert('Транзакція відхилена');
    } finally {
      dispatch('load', false);
    }
  }

  async function increment() {
    await transaction(await daiContract!.incrementCounter());
  }

  async function decrement() {
    await transaction(await daiContract!.decrementCounter());
  }
</script>

<div class="content">
  <main class="main">
    <div class="indecResult">
      <div class="container">
        <div class="indecResult__content">
          <Input
            {daiAddress}
            {error}
            placeholder="Введіть counter AT"
            on:change={({ detail: value }) => getDaiContract(value)} />
          <Buttons
            {count}
            disabled={!window.ethereum || !daiContract}
            on:increment={increment}
            on:decrement={decrement} />
        </div>
      </div>
    </div>
  </main>
</div>

<style lang="scss">
  .main {
    height: 100%;
  }
  .indecResult {
    height: 100%;
    background-image: url('https://images.wallpaperscraft.ru/image/single/minimalizm_nebo_oblaka_95458_1920x1080.jpg');
    background-repeat: no-repeat;
    background-position: center;
    background-size: cover;
    display: flex;
    align-items: center;
    justify-content: center;

    &__content {
      border-radius: 5px;
      border: 1px solid black;
      background-color: rgba(255, 255, 255, 0.7);
      padding: 20px;
      font-size: 20px;
      font-weight: bold;
      min-width: 400px;
      color: var(--grayColor);
    }
  }
</style>
