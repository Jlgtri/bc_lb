<script lang="ts">
  import { getAddress } from 'ethers';
  import { createEventDispatcher } from 'svelte';
  import Input from '../components/Input.svelte';
  import { getContract } from '../utils/web3.svelte';
  import daiAbi from './Payment.json';
  import PaymentForm from './components/PaymentForm.svelte';
  import Statistics from './components/Statistics.svelte';

  const dispatch = createEventDispatcher();

  $: error = '';

  let transactionAmount: bigint | null;
  $: transactionAmount = null;

  let transactionCount: number | null;
  $: transactionCount = null;

  let daiContract: Payment | null;
  $: daiContract = null;

  let daiAddress: string;
  $: daiAddress = '';

  async function getDaiContract(_daiAddress: string | null = null) {
    error = '';
    transactionAmount = transactionCount = null;

    try {
      daiAddress = getAddress(_daiAddress ?? '');
    } catch {
      daiContract = null;
      error = 'Адрес не вірний';
      return;
    }

    daiContract = (await getContract(daiAddress, daiAbi)) as Payment;

    try {
      transactionAmount = await daiContract!.transactionAmount();
      transactionCount = await daiContract!.transactionCount();
    } catch {
      transactionAmount = transactionCount = null;
      daiContract = null;
      error = 'Помилка завантаження';
      return;
    }
  }

  async function payBill(address: string, amount: bigint) {
    dispatch('load', true);
    try {
      const tx = await daiContract!.payBill(address, {
        value: amount,
      });
      console.log(await tx.wait());
      transactionAmount = await daiContract!.transactionAmount();
      transactionCount = await daiContract!.transactionCount();
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
          <Statistics {transactionCount} {transactionAmount} />
          <PaymentForm
            disabled={!window.ethereum || !daiContract}
            on:change={({ detail: { address, amount } }) =>
              payBill(address, amount)} />
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
