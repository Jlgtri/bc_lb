<script lang="ts">
  import { EventLog, parseEther } from 'ethers';
  import { createEventDispatcher } from 'svelte';
  import Input from '../../components/Input.svelte';
  import { getContract } from '../../utils/web3.svelte';
  import EscrowForm from './components/EscrowForm.svelte';
  import Statistics from './components/Statistics.svelte';

  const dispatch = createEventDispatcher();

  let depositor: string | null, beneficiary: string | null;
  let isDepositor: boolean | null, isBeneficiary: boolean | null;
  let currentBalance: bigint | null, balance: bigint | null;
  let total: bigint | null, releaseTime: number | null;
  let depositedAmount: bigint | null, releasedAmount: bigint | null;

  $: depositor = null;
  $: beneficiary = null;
  $: isBeneficiary = null;
  $: isDepositor = null;

  $: currentBalance = null;
  $: balance = null;
  $: total = null;
  $: releaseTime = null;
  $: depositedAmount = null;
  $: releasedAmount = null;

  let daiContract: SimpleTrustlessEscrow | null;
  $: daiContract = null;

  async function getDaiContract(daiAddress: string) {
    depositor = beneficiary = releaseTime = balance = null;
    daiContract = await getContract<SimpleTrustlessEscrow>(
      'SimpleTrustlessEscrow',
      daiAddress,
    );
    daiContract.on('Deposited', refresh);
    daiContract.on('Released', refresh);
    await refresh();
  }

  async function receive(amount: bigint) {
    if (!isDepositor) return alert('Поповнити рахунок може тільки вкладник!');
    dispatch('load', true);
    try {
      const tx = await daiContract!.runner!.sendTransaction!({
        from: depositor!,
        to: await daiContract!.getAddress(),
        value: amount,
      });
      console.log(await tx.wait());
      await refresh();
    } catch (exception) {
      console.error((exception as Error).message);
      alert('Транзакція відхилена');
    } finally {
      dispatch('load', false);
    }
  }

  async function release() {
    if (!releaseTime || releaseTime > Date.now() / 1000)
      return alert('Виводити кошти ще неможливо!');

    dispatch('load', true);
    try {
      console.log(await (await daiContract!.release()).wait());
      await refresh();
    } catch {
      alert('Транзакція відхилена');
    } finally {
      dispatch('load', false);
    }
  }

  async function refresh() {
    if (!daiContract) return;

    try {
      releaseTime ??= Number(await daiContract.releaseTime());
      depositor ??= (await daiContract.depositor()).toLowerCase();
      beneficiary ??= (await daiContract.beneficiary()).toLowerCase();
      isDepositor = depositor == window.ethereum?.selectedAddress;
      isBeneficiary = beneficiary == window.ethereum?.selectedAddress;

      currentBalance =
        await daiContract.runner!.provider!.getBalance(depositor);

      const deposited = await daiContract.queryFilter('Deposited');
      depositedAmount = (deposited as EventLog[])
        .filter(
          (event) =>
            event.args[0].toLowerCase() == window.ethereum?.selectedAddress,
        )
        .reduce((total, event) => total + event.args[1], parseEther('0'));

      const released = await daiContract.queryFilter('Released');
      releasedAmount = (released as EventLog[])
        .filter((event) => event.args[0].toLowerCase() == beneficiary)
        .reduce((total, event) => total + event.args[1], parseEther('0'));

      balance = total = (deposited as EventLog[]).reduce(
        (total, event) => total + event.args[1],
        parseEther('0'),
      );
      balance -= (released as EventLog[]).reduce(
        (total, event) => total + event.args[1],
        parseEther('0'),
      );
    } catch {
      daiContract = null;
      depositor = beneficiary = releaseTime = balance = total = null;
      currentBalance = depositedAmount = releasedAmount = null;
      alert('Помилка завантаження');
    }
  }
</script>

<div class="content">
  <main class="main">
    <div class="indecResult">
      <div class="container">
        <div class="indecResult__content">
          <Input
            name="SimpleTrustlessEscrow"
            on:change={({ detail: address }) => getDaiContract(address)} />
          <Statistics
            {currentBalance}
            {balance}
            {total}
            {depositedAmount}
            {releasedAmount} />
          <EscrowForm
            lockTime={releaseTime}
            withdraw={!!isBeneficiary}
            disabled={!window.ethereum || !daiContract}
            on:deposit={({ detail: amount }) => receive(amount)}
            on:withdraw={release} />
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
    background-image: url('/minimalizm_nebo_oblaka_95458_1920x1080.jpg');
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
