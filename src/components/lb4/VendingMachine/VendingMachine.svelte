<script lang="ts">
  import { parseEther } from 'ethers';
  import { createEventDispatcher } from 'svelte';
  import Input from '../../components/Input.svelte';
  import { getContract } from '../../utils/web3.svelte';
  import daiAbi from './VendingMachine.json';
  import Balances from './components/Balances.svelte';
  import BuyCapcake from './components/BuyCapcake.svelte';
  import UserBalance from './components/UserBalance.svelte';

  const dispatch = createEventDispatcher();

  let balance: number | null, total: number | null;
  let owner: string | null, isOwner: boolean | null;
  $: balance = null;
  $: total = null;
  $: owner = null;
  $: isOwner = null;

  let daiContract: VendingMachine | null;
  $: daiContract = null;

  async function getDaiContract(daiAddress: string) {
    owner = null;
    daiContract = (await getContract(daiAddress, daiAbi)) as VendingMachine;
    await refresh();
  }

  async function refill(amount: number) {
    dispatch('load', true);
    try {
      console.log(await (await daiContract!.refill(amount)).wait());
      await refresh();
    } catch {
      alert('Транзакція відхилена');
    } finally {
      dispatch('load', false);
    }
  }

  async function purchase(amount: number) {
    dispatch('load', true);
    try {
      const tx = await daiContract!.purchase(amount, {
        value: parseEther((amount * 0.01).toString()),
      });
      console.log(await tx.wait());
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
      owner ??= (await daiContract.owner()).toLowerCase();
      isOwner = owner == window.ethereum?.selectedAddress;
      if (owner) {
        total = await daiContract.cupcakeBalances(owner);
      }

      if (isOwner) {
        balance = total;
      } else {
        const address = window.ethereum?.selectedAddress;
        if (address) {
          balance = await daiContract.cupcakeBalances(address);
        }
      }
    } catch {
      daiContract = null;
      balance = total = null;
      owner = null;
      isOwner = null;
      alert('Помилка завантаження');
    }
  }

  async function checkBalance(address: string) {
    if (!daiContract) return;
    try {
      let balance = await daiContract.cupcakeBalances(address);
      alert(`Баланс ${address} = ${balance} кексів`);
    } catch {
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
            name="VendingMachine"
            on:change={({ detail: address }) => getDaiContract(address)} />
          <Balances {balance} {total}></Balances>
          <BuyCapcake
            refill={!!isOwner}
            disabled={!window.ethereum || !daiContract}
            on:change={({ detail: amount }) =>
              isOwner ? refill(amount) : purchase(amount)} />
          <UserBalance
            disabled={!window.ethereum || !daiContract}
            on:change={({ detail: address }) => checkBalance(address)} />
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
