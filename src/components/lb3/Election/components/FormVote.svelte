<script lang="ts">
  import { getAddress } from 'ethers';
  import { createEventDispatcher } from 'svelte';

  export let disabled: boolean = false;

  const dispatch = createEventDispatcher();

  $: id = '';
  $: address = '';

  async function changeAddress(value: string) {
    try {
      getAddress(value);
      address = value;
    } catch (exception) {
      ('Адрес не вірний');
    }
  }
</script>

<div class="vote">
  <div class="vote__item">
    <input
      type="number"
      placeholder="введіть номер кандидата"
      {disabled}
      value={id}
      on:change={(e) => (id = e.currentTarget.value)} />
    <button {disabled} on:click={() => dispatch('vote', Number(id))}>
      Проголосувати
    </button>
  </div>
  <div class="vote__item">
    <input
      type="text"
      placeholder="введіть адресу користувача"
      {disabled}
      on:change={(e) => changeAddress(e.currentTarget.value)} />
    <button
      disabled={disabled || !address}
      on:click={() => dispatch('check', address)}>
      Перевірка голосування
    </button>
  </div>
</div>

<style lang="scss">
  .vote {
    padding: 10px 0px;

    &__item {
      padding: 5px 0px;
      display: grid;
      grid-template-columns: 60% 1fr;

      input {
        margin-right: 10px;
      }
    }
  }
</style>
