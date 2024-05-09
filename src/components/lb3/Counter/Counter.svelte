<script lang="ts">
  import { createEventDispatcher } from 'svelte';
  import Input from '../../components/Input.svelte';
  import { getContract } from '../../utils/web3.svelte';
  import daiAbi from './Counter.json';
  import Buttons from './components/Buttons.svelte';

  const dispatch = createEventDispatcher();

  $: count = 0;

  let daiContract: Counter | null;
  $: daiContract = null;

  async function getDaiContract(daiAddress: string) {
    daiContract = (await getContract(daiAddress, daiAbi)) as Counter;
    await refresh();
  }

  async function refresh() {
    if (!daiContract) return;
    try {
      count = Number(await daiContract.getCount());
    } catch (exception) {
      count = 0;
      daiContract = null;
      alert('Помилка завантаження');
    }
  }

  async function increment() {
    dispatch('load', true);
    try {
      console.log(await (await daiContract!.incrementCounter()).wait());
      await refresh();
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
      await refresh();
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
            name="Counter"
            placeholder="Введіть counter AT"
            on:change={({ detail: address }) => getDaiContract(address)} />
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
