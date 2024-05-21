<script lang="ts">
  import { createEventDispatcher } from 'svelte';
  import Input from '../../components/Input.svelte';
  import { getContract } from '../../utils/web3.svelte';
  import PaymentForm from './components/PaymentForm.svelte';
  import Statistics from './components/Statistics.svelte';

  const dispatch = createEventDispatcher();

  let transactionAmount: bigint | null;
  $: transactionAmount = null;

  let transactionCount: number | null;
  $: transactionCount = null;

  let daiContract: Payment | null;
  $: daiContract = null;

  async function getDaiContract(daiAddress: string) {
    daiContract = await getContract<Payment>('Payment', daiAddress);
    await refresh();
  }

  async function refresh() {
    if (!daiContract) return;
    try {
      transactionAmount = await daiContract.transactionAmount();
      transactionCount = await daiContract.transactionCount();
    } catch {
      daiContract = transactionAmount = transactionCount = null;
      alert('Помилка завантаження');
    }
  }

  async function payBill(address: string, amount: bigint) {
    dispatch('load', true);
    try {
      const tx = await daiContract!.payBill(address, {
        value: amount,
      });
      console.log(await tx.wait());
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
            name="Payment"
            on:change={({ detail: address }) => getDaiContract(address)} />
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
