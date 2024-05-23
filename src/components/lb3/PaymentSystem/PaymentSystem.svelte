<script lang="ts">
  import type { EventLog } from 'ethers';
  import { createEventDispatcher } from 'svelte';
  import Input from '../../components/Input.svelte';
  import { getContract } from '../../utils/web3.svelte';
  import DepositForm from './components/DepositForm.svelte';
  import PaymentForm from './components/PaymentForm.svelte';
  import Statistics from './components/Statistics.svelte';

  const dispatch = createEventDispatcher();

  let balance: bigint | null;
  let transactionAmount: bigint | null, transactionCount: number | null;
  let daiContract: PaymentSystem | null;
  $: transactionAmount = null;
  $: daiContract = null;

  async function getDaiContract(daiAddress: string) {
    daiContract = await getContract<PaymentSystem>(
      'PaymentSystem',
      daiAddress,
    );
    daiContract.on('Transfer', refresh);
    await refresh();
  }

  async function refresh() {
    if (!daiContract) return;
    try {
      let userAddress = window.ethereum!.selectedAddress!.toLowerCase();
      balance = await daiContract!.getBalance(userAddress);

      const transfers = await daiContract.queryFilter('Transfer');
      transactionCount = transfers.length;
      transactionAmount = (transfers as EventLog[]).reduce(
        (total, event) => total + event.args[2],
        BigInt(0),
      );
    } catch {
      balance = transactionAmount = transactionCount = daiContract = null;
      alert('Помилка завантаження');
    }
  }

  async function deposit(amount: bigint) {
    dispatch('load', true);
    try {
      const tx = await daiContract!.deposit({ value: amount });
      console.log(await tx.wait());
      await refresh();
    } catch {
      alert('Транзакція відхилена');
    } finally {
      dispatch('load', false);
    }
  }

  async function transfer(address: string, amount: bigint) {
    dispatch('load', true);
    try {
      const tx = await daiContract!.transfer(address, amount);
      console.log(await tx.wait());
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
            name="Payment"
            on:change={({ detail: address }) => getDaiContract(address)} />
          <Statistics {transactionCount} {transactionAmount} />
          <DepositForm
            {balance}
            disabled={!window.ethereum || !daiContract}
            on:deposit={({ detail: amount }) => deposit(amount)} />
          {#if balance}
            <PaymentForm
              disabled={!window.ethereum || !daiContract}
              on:transfer={({ detail: { address, amount } }) =>
                transfer(address, amount)} />
          {/if}
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
    background-image: url('minimalizm_nebo_oblaka_95458_1920x1080.jpg');
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
