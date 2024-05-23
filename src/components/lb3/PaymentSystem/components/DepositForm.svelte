<script lang="ts">
  import { formatEther, parseEther } from 'ethers';
  import { createEventDispatcher } from 'svelte';

  export let balance: bigint | null = null,
    disabled: boolean = false;

  let amount: bigint | null;
  $: amount = null;
  $: error = '';

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

  const dispatch = createEventDispatcher();
</script>

<div class="deposit">
  <div class="deposit__title">
    <span>У вас на рахунку:</span>
    <span class="stats__amount">
      {balance !== null ? formatEther(balance) + ' ETH' : 'немає даних'}
    </span>
  </div>
  <div class="deposit__setValue">
    <input
      type="number"
      placeholder="Введіть суму депозиту"
      {disabled}
      on:change={(e) => changeAmount(e.currentTarget.value)} />
    <button
      disabled={disabled || !amount}
      on:click={() => dispatch('deposit', amount)}>
      Поповнити
    </button>
  </div>
  <div class="deposit__error">{error}</div>
</div>

<style lang="scss">
  .deposit {
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
