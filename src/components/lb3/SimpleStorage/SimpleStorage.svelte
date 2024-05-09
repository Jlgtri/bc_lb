<script lang="ts">
  import { createEventDispatcher } from 'svelte';
  import Input from '../../components/Input.svelte';
  import { getContract } from '../../utils/web3.svelte';
  import daiAbi from './SimpleStorage.json';
  import Storage from './components/Storage.svelte';

  const dispatch = createEventDispatcher();

  let storageValue: number | null;
  $: storageValue = null;

  let daiContract: SimpleStorage | null;
  $: daiContract = null;

  async function getDaiContract(daiAddress: string) {
    daiContract = (await getContract(daiAddress, daiAbi)) as SimpleStorage;
    await refresh();
  }

  async function refresh() {
    if (!daiContract) return;
    try {
      storageValue = await daiContract.get();
    } catch {
      daiContract = storageValue = null;
      alert('Помилка завантаження');
    }
  }

  async function change(value: number) {
    dispatch('load', true);
    try {
      console.log(await (await daiContract!.set(value)).wait());
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
          <Input on:change={({ detail: value }) => getDaiContract(value)} />
          <Storage
            {storageValue}
            disabled={!window.ethereum || !daiContract}
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
