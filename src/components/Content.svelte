<script lang="ts">
  import {
    BrowserProvider,
    Contract,
    getDefaultProvider,
    type Eip1193Provider,
  } from 'ethers';
  import daiAbi from '../abis/Counter.json';
  import Buttons from './Contract/Buttons.svelte';
  import Input from './Contract/Input.svelte';
  import Preloader from './Preloader.svelte';

  $: isFetching = false;
  $: count = Number(0);

  let daiContract: Counter | null;
  $: daiContract;

  let daiAddress: string | null;
  $: daiAddress = null;
  async function getDaiContract(daiAddress: string | null = null) {
    if (daiAddress == null) {
      daiContract = null;
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
    await getCount();
  }

  async function getCount() {
    count = Number(await daiContract!.getCount());
  }
</script>

{#await getDaiContract()}
  <Preloader />
{:then}
  {#if isFetching}
    <Preloader />
  {:else}
    <div class="content">
      <main class="main">
        <div class="indecResult">
          <div class="container">
            <div class="indecResult__content">
              <Input
                {daiAddress}
                on:change={({ detail: value }) =>
                  getDaiContract((daiAddress = value))} />
              <Buttons
                {count}
                {daiContract}
                on:change={({ detail: value }) =>
                  (isFetching = value) || getCount()} />
            </div>
          </div>
        </div>
      </main>
    </div>
  {/if}
{:catch someError}
  System error: {someError.stack}.
{/await}

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
