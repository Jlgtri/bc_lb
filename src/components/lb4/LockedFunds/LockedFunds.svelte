<script lang="ts">
  import { createEventDispatcher } from 'svelte';
  import Input from '../../components/Input.svelte';
  import { getContract } from '../../utils/web3.svelte';
  import daiAbi from './LockedFunds.json';
  import DepositForm from './components/DepositForm.svelte';
  import Deposits from './components/Deposits.svelte';

  const dispatch = createEventDispatcher();

  let currentBalance: bigint | null;
  let balance: bigint | null, total: bigint | null;
  let timestamp: number | null, lockTime: number | null;
  let owner: string | null, isOwner: boolean | null;
  $: total = null;
  $: currentBalance = null;
  $: balance = null;
  $: timestamp = null;
  $: lockTime = null;
  $: owner = null;
  $: isOwner = null;

  let daiContract: LockedFunds | null;
  $: daiContract = null;

  window.ethereum?.on('accountsChanged', refresh);

  async function getDaiContract(daiAddress: string) {
    timestamp = lockTime = null;
    owner = null;
    daiContract = (await getContract(daiAddress, daiAbi)) as LockedFunds;
    await refresh();
  }

  async function deposit(amount: bigint) {
    dispatch('load', true);
    try {
      const tx = await daiContract!.deposit({
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

  async function withdraw() {
    if (!isOwner) return alert('Виводити може тільки власник контракту!');
    if (!lockTime || lockTime > Date.now() / 1000)
      return alert('Виводити кошти ще неможливо!');

    dispatch('load', true);
    try {
      console.log(await (await daiContract!.withdraw()).wait());
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
      timestamp ??= Number(await daiContract.getTimestamp());
      lockTime ??= Number(await daiContract.lockTime());
      owner ??= (await daiContract.owner()).toLowerCase();
      if (window.ethereum?.selectedAddress) {
        currentBalance = await daiContract.getBalanceAccount(
          window.ethereum?.selectedAddress,
        );
      }

      isOwner = owner == window.ethereum?.selectedAddress;
      if (owner) {
        total = await daiContract.deposits(owner);
      }

      if (isOwner) {
        balance = total;
      } else {
        const address = window.ethereum?.selectedAddress;
        if (address) {
          balance = await daiContract.deposits(address);
        }
      }
    } catch {
      daiContract = null;
      currentBalance = balance = total = null;
      isOwner = null;
      timestamp = lockTime = null;
      owner = null;
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
            on:change={({ detail: address }) => getDaiContract(address)} />
          <Deposits {currentBalance} {balance} {total} />
          <DepositForm
            {lockTime}
            withdraw={isOwner ?? false}
            disabled={!window.ethereum ||
              !daiContract ||
              (!!isOwner && !balance)}
            on:deposit={({ detail: amount }) => deposit(amount)}
            on:withdraw={withdraw} />
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
