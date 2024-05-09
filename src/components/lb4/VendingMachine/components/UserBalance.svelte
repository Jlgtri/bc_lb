<script lang="ts">
  import { getAddress } from 'ethers';
  import { createEventDispatcher } from 'svelte';

  export let disabled: boolean = false;

  const dispatch = createEventDispatcher();

  $: address = '';
  $: error = '';

  async function changeAddress(value: string) {
    error = '';
    try {
      address = getAddress(value);
    } catch {
      address = '';
      error = 'Значення не підходить';
    }
  }
</script>

<div class="balance">
  <span class="balance__setValue">
    <input
      type="text"
      placeholder="Введіть адресу для перевірки балансу"
      {disabled}
      on:change={(e) => changeAddress(e.currentTarget.value)} />
    <button
      disabled={disabled || !address}
      on:click={() => dispatch('change', address)}>
      Check Balance
    </button>
    <div class="balance__error">{(!disabled && error) || ''}</div>
  </span>
</div>

<style lang="scss">
  .balance {
    border: 1px solid black;
    border-radius: 5px;
    padding: 10px;
    margin-top: 10px;

    &__setValue {
      border-radius: 0px 5px 5px 0px;
      overflow: hidden;

      display: grid;
      grid-template-columns: 75% 1fr;

      button {
        cursor: pointer;

        height: 100%;
        background-color: green;
        border: none;
        padding: 0px 20px;
        color: white;
        margin-left: 10px;
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
