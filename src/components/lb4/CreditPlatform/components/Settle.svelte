<script lang="ts">
  import { formatEther, parseEther } from 'ethers';
  import { createEventDispatcher, onMount } from 'svelte';

  export let loan: Loan,
    loanAmount: bigint,
    loanPeriod: bigint,
    interestRateRatio: bigint,
    disabled: boolean = false;

  let amount: bigint | null;
  $: amount = null;
  $: error = '';
  $: totalLoanAmount = loanAmount;
  $: daysLeft = 0;

  async function changeAmount(value: string) {
    error = '';
    try {
      amount = parseEther(value);
      console.log(amount);
    } catch {
      amount = null;
      error = 'Значення не підходить';
    }
  }

  const initialTime = Date.now();
  onMount(() => {
    const interval = setInterval(() => {
      const timeDiff = Date.now() - initialTime;
      let commissionAmount =
        loanAmount * BigInt(loan.interestRate) * BigInt(timeDiff);
      commissionAmount /= BigInt(loanPeriod);
      commissionAmount /= BigInt(interestRateRatio);
      totalLoanAmount = loanAmount + commissionAmount;

      daysLeft = Math.round(
        (Number(loan.expiresAt) - Date.now() / 1000) / 60 / 60 / 24,
      );
    }, 1000);
    return () => clearInterval(interval);
  });

  const dispatch = createEventDispatcher();
  const expiresAt = new Date(Number(loan.expiresAt) * 1000);
</script>

<div class="vending">
  <div class="vending__title">
    Залишилось виплатити приблизно: {formatEther(totalLoanAmount)} ETH
  </div>
  <div class="vending__title">
    Потрібно сплатити кредит до: {expiresAt.toLocaleString()}
    (залишилось {daysLeft} днів)
  </div>
  <div class="vending__setValue">
    <input
      type="number"
      placeholder="Введіть суму виплати (в ETH)"
      {disabled}
      on:change={(e) => changeAmount(e.currentTarget.value)} />
    <button
      disabled={disabled || !amount}
      on:click={() => dispatch('settle', amount)}>
      Виплатити
    </button>
  </div>
  <div class="vending__error">{error}</div>
</div>

<style lang="scss">
  .vending {
    border: 1px solid black;
    border-radius: 5px;
    padding: 10px;
    margin-top: 10px;

    &__title {
      background-color: white;
      text-align: center;
      font-size: 20px;
      font-weight: bold;
      margin-bottom: 10px;
      padding: 7px 25px;
      border: 1px solid black;
      color: black;
    }

    &__setValue {
      display: grid;
      grid-template-columns: 75% 1fr;
    }

    &__error {
      text-align: center;
      font-weight: normal;
      font-size: 16px;
      color: red;
    }

    button {
      cursor: pointer;
      color: white;
      background-color: var(--pinkColor);
      border: none;
      border-radius: 5px;
      margin-left: 10px;
    }

    button[disabled] {
      border: 1px solid #999999;
      background-color: #cccccc;
      color: #666666;
    }
  }
</style>
