<script lang="ts">
  import { parseEther } from 'ethers';
  import { createEventDispatcher } from 'svelte';

  export let lockTime: number | null = null,
    withdraw: boolean = false,
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

<div class="vending">
  <div class="vending__title">
    {!lockTime
      ? 'Немає даних щодо виводу'
      : lockTime > Date.now() / 1000
        ? 'Депозит зможе бути виведений: ' +
          new Date(lockTime * 1000).toLocaleString()
        : 'Депозит може бути виведений'}
  </div>
  <div class={withdraw ? 'vending__withdraw' : 'vending__setValue'}>
    {#if withdraw}
      <button {disabled} on:click={() => dispatch('withdraw')}>Вивести</button>
    {:else}
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
    {/if}
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

    &__withdraw {
      display: grid;
      grid-template-columns: 100% 1fr;

      button {
        background-color: var(--grayColor);
      }
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
