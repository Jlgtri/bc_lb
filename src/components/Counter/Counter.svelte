<script lang="ts">
  import { getAddress } from 'ethers';
  import { createEventDispatcher } from 'svelte';
  import Input from '../components/Input.svelte';
  import { getContract } from '../utils/web3.svelte';
  import daiAbi from './Counter.json';
  import Buttons from './components/Buttons.svelte';

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
      count = 0;
      daiAddress = getAddress(_daiAddress ?? '');
    } catch {
      daiContract = null;
      error = 'Адрес не вірний';
      return;
    }

    daiContract = (await getContract(daiAddress, daiAbi)) as Counter;
    try {
      count = Number(await daiContract!.getCount());
    } catch (exception) {
      daiContract = null;
      error = 'Помилка завантаження';
      return;
    }
  }

  async function increment() {
    dispatch('load', true);
    try {
      console.log(await (await daiContract!.incrementCounter()).wait());
      count = Number(await daiContract!.getCount());
    } catch {
      alert('Транзакція відхилена');
    } finally {
      dispatch('load', false);
    }
  }

  async function decrement() {
    dispatch('load', true);
    try {
      console.log(await (await daiContract!.decrementCounter()).wait());
      count = Number(await daiContract!.getCount());
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
