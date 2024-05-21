<script lang="ts">
  import { formatEther, getAddress, parseEther } from 'ethers';
  import { createEventDispatcher } from 'svelte';

  export let balance: bigint,
    loan: Loan | null,
    disabled: boolean = false;

  const dispatch = createEventDispatcher();

  let amount: bigint | null, address: string | null;
  $: amount = null;
  $: address = null;
  $: error = '';
  $: errorAddress = '';

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

  async function changeAddress(value: string) {
    errorAddress = '';
    try {
      console.log((address = getAddress(value).toLowerCase()));
      dispatch('address', address);
    } catch {
      address = null;
      errorAddress = 'Значення не підходить';
      dispatch('address', null);
    }
  }
</script>

<div class="form">
  <div class="form__title">
    На балансі: {formatEther(balance)} ETH
  </div>
  <input
    type="number"
    placeholder="Введіть суму"
    {disabled}
    on:change={(e) => changeAmount(e.currentTarget.value)} />
  <div class="form__error">{error}</div>
  <div class="form__setValue">
    <button
      disabled={disabled || !amount}
      on:click={() => dispatch('deposit', amount)}>
      Поповнити
    </button>
    <button
      disabled={disabled || !amount}
      on:click={() => dispatch('withdraw', amount)}>
      Вивести
    </button>
  </div>

  <div class="form__setAddress">
    <input
      type="text"
      placeholder="Введіть адрес гаманьця для виводу залогу"
      {disabled}
      on:change={(e) => changeAddress(e.currentTarget.value)} />

    <button
      disabled={disabled || !loan}
      on:click={() => dispatch('settle', address)}>
      Вивести залог
    </button>
  </div>

  {#if loan}
    <div class="form__title" style="margin-top: 10px">
      Залишилось виплатити: {formatEther(loan.amount)} ETH

      <br />
      Потрібно сплатити до: {new Date(
        Number(loan.expiresAt) * 1000,
      ).toLocaleString()}
    </div>
  {/if}

  <div class="form__error">{errorAddress}</div>
</div>

<style lang="scss">
  .form {
    border: 1px solid black;
    border-radius: 5px;
    padding: 10px;
    margin-top: 10px;

    input {
      width: 100%;
      margin-bottom: 5px;
    }

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

    &__setAddress {
      display: grid;
      grid-template-columns: 75% 1fr;
      margin-top: 12px;
    }

    &__setValue {
      display: grid;
      grid-template-columns: 50% 1fr;
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
