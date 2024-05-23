<script lang="ts">
  import { getAddress, parseEther } from 'ethers';
  import { createEventDispatcher } from 'svelte';

  export let disabled: boolean = false;

  $: errorAmount = '';
  $: errorAddress = '';

  let address: string | null, amount: bigint | null;
  $: address = null;
  $: amount = null;

  const dispatch = createEventDispatcher();

  async function changeAddress(value: string) {
    errorAddress = '';
    try {
      address = getAddress(value);
    } catch {
      address = '';
      errorAddress = 'Значення не підходить';
    }
  }

  async function changeAmount(value: string) {
    errorAmount = '';
    try {
      amount = parseEther(value);
    } catch {
      amount = null;
      errorAmount = 'Значення не підходить';
    }
  }
</script>

<div class="storage">
  <span class="storage__setValue">
    <input
      type="text"
      placeholder="Введіть адресу отримувача"
      value={address}
      {disabled}
      on:change={(e) => changeAddress(e.currentTarget.value)} />

    <input
      type="number"
      placeholder="Введіть суму"
      value={amount}
      {disabled}
      on:change={(e) => changeAmount(e.currentTarget.value)} />

    <button
      disabled={!address || !amount}
      on:click={() =>
        dispatch('transfer', {
          address,
          amount,
        })}>
      Перевести
    </button>
  </span>
  <span class="storage__error">{errorAddress}</span>
  <span class="storage__error">{errorAmount}</span>
</div>

<style lang="scss">
  .storage {
    border: 1px solid black;
    border-radius: 5px;
    padding: 10px;
    margin-top: 10px;

    &__setValue {
      border-radius: 0px 5px 5px 0px;
      overflow: hidden;
      display: grid;
      grid-template-columns: 40% 30% 20%;
      gap: 20px;

      input {
        width: 100%;
      }

      button {
        cursor: pointer;

        height: 100%;
        background-color: green;
        border: none;
        padding: 0px 20px;
        color: white;
      }

      button[disabled] {
        border: 1px solid #999999;
        background-color: #cccccc;
        color: #666666;
      }
    }

    &__error {
      text-align: center;
      font-weight: normal;
      font-size: 16px;
      color: red;
    }
  }
</style>
