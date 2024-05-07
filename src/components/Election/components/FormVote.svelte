<script lang="ts">
  export let address: string = '',
    disabled: boolean = false;

  import { createEventDispatcher } from 'svelte';

  const dispatch = createEventDispatcher();

  $: id = '';
  $: _address = address;
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
      value={_address}
      on:change={(e) => (_address = e.currentTarget.value)} />
    <button {disabled} on:click={() => dispatch('check', _address)}>
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
