<script lang="ts">
  import {
    BrowserProvider,
    Contract,
    getAddress,
    getDefaultProvider,
    type Eip1193Provider,
  } from 'ethers';
  import { createEventDispatcher } from 'svelte';
  import daiAbi from '../../abis/SimpleStorage.json';
  import Input from '../components/Input.svelte';
  import Storage from '../components/Storage.svelte';

  const dispatch = createEventDispatcher();

  $: error = '';
  $: errorStorage = '';

  let storageValue: number | null;
  $: storageValue = null;

  let daiContract: SimpleStorage | null;
  $: daiContract = null;

  let daiAddress: string;
  $: daiAddress = '';

  async function getDaiContract(_daiAddress: string | null = null) {
    try {
      error = '';
      daiAddress = getAddress(_daiAddress || '');
    } catch {
      daiContract = null;
      storageValue = null;
      error = 'Адрес не вірний';
      return;
    }

    if (!window.ethereum) {
      alert(
        'MetaMask не встановлено; ' +
          'використовуючи значення за замовчуванням лише для читання',
      );
      let provider = getDefaultProvider('goerli');
      daiContract = new Contract(
        daiAddress,
        daiAbi,
        provider,
      ) as SimpleStorage;
    }

    let provider = new BrowserProvider(window.ethereum as Eip1193Provider);
    const signer = await provider.getSigner();
    daiContract = new Contract(daiAddress, daiAbi, signer) as SimpleStorage;
    storageValue = await daiContract!.get();
  }

  async function change(value: string) {
    errorStorage = '';
    if (isNaN(Number.parseInt(value))) {
      errorStorage = 'Значення не підходить';
      return;
    }
    storageValue = Number.parseInt(value);

    dispatch('load', true);
    try {
      console.log(await (await daiContract!.set(storageValue)).wait());
      storageValue = Number(await daiContract!.get());
    } catch {
      alert('Транзакція відхилена');
    } finally {
      dispatch('load', false);
    }
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
            on:change={({ detail: value }) => getDaiContract(value)} />
          <Storage
            value={storageValue}
            disabled={!window.ethereum || !daiContract}
            error={errorStorage}
            on:change={({ detail: value }) => change(value)} />
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
