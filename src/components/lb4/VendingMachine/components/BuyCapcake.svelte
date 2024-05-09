<script lang="ts">
  import { createEventDispatcher } from 'svelte';

  export let refill: boolean = false,
    disabled: boolean = false;

  $: amount = 0;
  $: error = '';

  async function changeAmount(value: string) {
    error = '';
    if (isNaN(Number.parseInt(value))) {
      amount = 0;
      error = 'Значення не підходить';
    } else {
      amount = Number.parseInt(value);
    }
  }

  const dispatch = createEventDispatcher();
</script>

<div class="vending">
  <div class="vending__title">Вартість кексу 0.01 ETH</div>
  <div class="vending__setValue">
    <input
      type="number"
      placeholder="Введіть кількість кексів"
      {disabled}
      on:change={(e) => changeAmount(e.currentTarget.value)} />
    <button
      disabled={disabled || !amount}
      on:click={() => dispatch('change', amount)}>
      {refill ? 'Поповнити' : 'Купити'}
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

    &__setValue button {
      cursor: pointer;
      color: white;
      background-color: var(--pinkColor);
      border: none;
      border-radius: 5px;
      margin-left: 10px;
    }

    &__setValue button[disabled] {
      border: 1px solid #999999;
      background-color: #cccccc;
      color: #666666;
    }
  }
</style>
