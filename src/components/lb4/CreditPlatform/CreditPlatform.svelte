<script lang="ts">
  import { formatEther } from 'ethers';
  import { ErrorDecoder } from 'ethers-decode-error';
  import { createEventDispatcher } from 'svelte';
  import Input from '../../components/Input.svelte';
  import { getContract } from '../../utils/web3.svelte';
  import Acquire from './components/Acquire.svelte';
  import OwnerForm from './components/OwnerForm.svelte';
  import Settle from './components/Settle.svelte';

  const dispatch = createEventDispatcher();
  const errorDecoder = ErrorDecoder.create();

  let daiContract: CreditPlatform | null;
  let loanPeriod: bigint | null, minimumAcquireAmount: bigint | null;
  let interestRate: bigint | null, interestRateRatio: bigint | null;
  let loan: Loan | null, loanAmount: bigint | null;
  let balance: bigint | null, currentBalance: bigint | null;
  let owner: string | null, isOwner: boolean | null;

  $: loanPeriod = null;
  $: minimumAcquireAmount = null;
  $: interestRate = null;
  $: interestRateRatio = null;
  $: loan = null;
  $: loanAmount = null;

  $: balance = null;
  $: owner = null;
  $: isOwner = null;
  $: daiContract = null;

  async function getDaiContract(daiAddress: string) {
    loanPeriod = minimumAcquireAmount = owner = isOwner = null;
    daiContract = await getContract<CreditPlatform>(
      'CreditPlatform',
      daiAddress,
    );
    await refresh();
    if (isOwner) {
      daiContract?.on('Default', (recepient: string, collateral: string) => {
        alert(`Ви успішно отримали залог для "${recepient}": ${collateral}`);
      });
      daiContract?.on('Deposit', refresh);
      daiContract?.on('Withdraw', refresh);
    }
    daiContract?.on('Acquire', refresh);
    daiContract?.on('Settle', refresh);
  }

  async function deposit(amount: bigint) {
    if (!isOwner) return alert('Депозитити може тільки власник контракту!');
    dispatch('load', true);
    try {
      const tx = await daiContract!.deposit({
        value: amount,
      });
      console.log(await tx.wait());
    } catch {
      alert('Транзакція відхилена');
    } finally {
      dispatch('load', false);
    }
  }

  async function withdraw(amount: bigint) {
    if (!isOwner) return alert('Виводити може тільки власник контракту!');
    if ((balance ?? 0) < amount)
      return alert('Недостатньо коштів на балансі!');

    dispatch('load', true);
    try {
      console.log(await (await daiContract!.withdraw(amount)).wait());
    } catch {
      alert('Транзакція відхилена');
    } finally {
      dispatch('load', false);
    }
  }

  async function acquire(
    amount: bigint,
    duration: bigint,
    collateral: string,
  ) {
    if (isOwner) return alert('Власник не може брати кредит!');
    if ((balance ?? 0) < amount)
      return alert('У контракті недостатньо коштів для видачі!');
    if (amount < (minimumAcquireAmount ?? 1))
      return alert(
        `Сума кредиту повинна бути більше ${formatEther(minimumAcquireAmount ?? 0)} ETH!`,
      );

    dispatch('load', true);
    try {
      const tx = await daiContract!.acquire(amount, duration, collateral);
      console.log(await tx.wait());
    } catch {
      alert('Транзакція відхилена');
    } finally {
      dispatch('load', false);
    }
  }

  async function settle(amount: bigint) {
    if (isOwner) return alert('Власник не може повертати кредит!');
    if ((currentBalance ?? 0) < amount)
      return alert('У вас недостатньо коштів!');

    dispatch('load', true);
    try {
      const tx = await daiContract!.settle({ value: amount });
      console.log(await tx.wait());
    } catch {
      alert('Транзакція відхилена');
    } finally {
      dispatch('load', false);
    }
  }

  async function settleDefault(address: string) {
    if (!isOwner) return alert('Тільки власник може забирати залог!');

    dispatch('load', true);
    try {
      const tx = await daiContract!.settleDefault(address);
      console.log(await tx.wait());
    } catch (err) {
      const decodedError = await errorDecoder.decode(err);
      switch (decodedError.reason) {
        case 'The loan is already settled or non-existent!':
          alert('У цього юзера немає кредиту, або він вже вичерпаний.');
          break;
        case 'The loan can not be settled as default yet.':
          alert('Залог за цим кредитом ще не може бути витягнутий.');
          break;
        default:
          alert('Транзакція відхилена.');
      }
    } finally {
      dispatch('load', false);
    }
  }

  async function refresh(userAddress: string | null = null) {
    if (!daiContract) return;

    try {
      userAddress ??= window.ethereum!.selectedAddress!.toLowerCase();
      loanPeriod ??= await daiContract.loanPeriod();
      interestRateRatio ??= await daiContract.interestRateRatio();
      owner ??= (await daiContract.owner()).toLowerCase();
      isOwner ??= owner == window.ethereum!.selectedAddress!.toLowerCase();

      balance = await daiContract.getBalance();
      currentBalance =
        await daiContract.runner!.provider!.getBalance(userAddress);

      interestRate = await daiContract.interestRate();
      minimumAcquireAmount = await daiContract.minimumAcquireAmount();
      if (!isOwner) loanAmount = await daiContract.getLoanAmount();
      if (userAddress) {
        loan = await daiContract.activeLoans(userAddress);
        if (!loan.amount) loan = null;
      }
    } catch (_) {
      loanPeriod = minimumAcquireAmount = null;
      interestRate = interestRateRatio = loan = loanAmount = null;
      balance = owner = isOwner = daiContract = null;
      alert('Помилка завантаження');
      console.error(_);
    }
  }
</script>

<div class="content">
  <main class="main">
    <div class="indecResult">
      <div class="container">
        <div class="indecResult__content">
          <Input
            name="CreditPlatform"
            on:change={({ detail: address }) => getDaiContract(address)} />
          {#if isOwner && balance != null}
            <OwnerForm
              {balance}
              {loan}
              on:deposit={({ detail: amount }) => deposit(amount)}
              on:withdraw={({ detail: amount }) => withdraw(amount)}
              on:address={({ detail: address }) => refresh(address)}
              on:settle={({ detail: address }) => settleDefault(address)} />
          {:else if loan && loanAmount && loanPeriod != null && interestRateRatio != null}
            <Settle
              {loan}
              {loanAmount}
              {loanPeriod}
              {interestRateRatio}
              on:settle={({ detail: amount }) => settle(amount)} />
          {:else if interestRate != null && loanPeriod != null && interestRateRatio != null}
            <Acquire
              {interestRate}
              {interestRateRatio}
              {loanPeriod}
              on:acquire={({ detail: { amount, duration, collateral } }) =>
                acquire(amount, duration, collateral)} />
          {:else}
            <Acquire
              interestRate={BigInt(0)}
              interestRateRatio={BigInt(0)}
              loanPeriod={BigInt(60 * 60 * 24 * 365)}
              disabled={true} />
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
