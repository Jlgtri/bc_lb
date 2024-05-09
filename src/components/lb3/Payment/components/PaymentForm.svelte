<script lang="ts">
  import { getAddress, parseEther } from 'ethers';
  import { createEventDispatcher } from 'svelte';

  export let disabled: boolean = false;

  $: errorAmount = '';
  $: errorAddress = '';

  $: payAddress = '';
  $: payAmount = '';

  const dispatch = createEventDispatcher();

  async function changeAddress(value: string) {
    errorAddress = '';
    try {
      payAddress = getAddress(value);
    } catch {
      payAddress = '';
      errorAddress = 'Значення не підходить';
    }
  }

  async function changeAmount(value: string) {
    errorAmount = '';
    try {
      parseEther(value);
      payAmount = value;
    } catch {
      payAmount = '';
      errorAmount = 'Значення не підходить';
    }
  }
</script>

<div class="storage">
  <span class="storage__setValue">
    <div>
      <input
        type="text"
        placeholder="Введіть адрессу отримувача"
        value={payAddress}
        {disabled}
        on:change={(e) => changeAddress(e.currentTarget.value)} />
      <span class="storage__error">{errorAddress}</span>
    </div>

    <div>
      <input
        type="number"
        placeholder="Введіть суму"
        value={payAmount}
        {disabled}
        on:change={(e) => changeAmount(e.currentTarget.value)} />
      <span class="storage__error">{errorAmount}</span>
    </div>
    <button
      disabled={!payAddress || !payAmount}
      on:click={() =>
        dispatch('change', {
          address: payAddress,
          amount: parseEther(payAmount),
        })}>
      Pay Bill
    </button>
  </span>
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
      width: 20%;
      text-align: center;
      font-weight: normal;
      font-size: 16px;
      color: red;
    }
  }
</style>
