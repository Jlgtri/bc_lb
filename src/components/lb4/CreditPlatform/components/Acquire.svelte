<script lang="ts">
  import { parseEther } from 'ethers';
  import { createEventDispatcher } from 'svelte';

  export let interestRate: bigint,
    interestRateRatio: bigint,
    loanPeriod: bigint,
    disabled: boolean = false;

  let amount: bigint | null = null;
  let duration: bigint | null = null;
  let collateral: string | null = null;
  $: isDisabled = disabled || !amount || !duration || !collateral;
  $: errorAmount = '';
  $: errorDuration = '';
  $: errorCollateral = '';

  async function changeAmount(value: string) {
    errorAmount = '';
    try {
      console.log((amount = parseEther(value)));
    } catch {
      amount = null;
      errorAmount = 'Значення не підходить';
    }
  }

  async function changeDuration(value: string) {
    errorDuration = '';
    try {
      console.log((duration = BigInt(Number(value) * 60 * 60 * 24)));
    } catch {
      duration = null;
      errorDuration = 'Значення не підходить';
    }
  }

  async function changeCollateral(value: string) {
    if (!value) {
      collateral = null;
      errorCollateral = 'Значення не підходить';
    } else {
      collateral = value;
    }
  }

  const dispatch = createEventDispatcher();
  const rate = !interestRateRatio
    ? 0
    : (Number(interestRate) / Number(interestRateRatio)) * 100;
  const loanDays = Number(loanPeriod) / 60 / 60 / 24;
</script>

<div class="vending">
  <div class="vending__title">У вас наразі немає активного кредиту.</div>
  <div class="vending__title">
    Процент за новим кредитом: {rate}% / {loanDays} днів
  </div>
  <div class="vending__setValue">
    <input
      type="number"
      placeholder="Введіть суму для кредиту (в ETH)"
      {disabled}
      on:change={(e) => changeAmount(e.currentTarget.value)} />
    <div class="vending__error">{errorAmount}</div>

    <input
      type="number"
      placeholder="Введіть строк кредиту (в днях)"
      {disabled}
      on:change={(e) => changeDuration(e.currentTarget.value)} />
    <div class="vending__error">{errorDuration}</div>

    <input
      type="text"
      placeholder="Введіть залог у кредит"
      {disabled}
      on:change={(e) => changeCollateral(e.currentTarget.value)} />
    <div class="vending__error">{errorCollateral}</div>

    <button
      disabled={isDisabled}
      on:click={() =>
        dispatch('acquire', {
          amount,
          duration,
          collateral,
        })}>
      Взяти кредит
    </button>
  </div>
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
