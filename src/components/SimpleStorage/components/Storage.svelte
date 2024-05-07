<script lang="ts">
  import { createEventDispatcher } from 'svelte';

  export let value: number | null,
    disabled: boolean = false,
    error: string | null = '';

  $: _value = '';

  const dispatch = createEventDispatcher();
</script>

<div class="storage">
  <div class="storage__getValue">{value ?? 'Номер не визначений'}</div>
  <div class="storage__setValue">
    <input
      type="number"
      value={_value}
      {disabled}
      on:change={(e) => (_value = e.currentTarget.value)} />
    <button on:click={() => dispatch('change', _value)} {disabled}>
      set Value
    </button>
  </div>
  <div class="storage__error">{error}</div>
</div>

<style lang="scss">
  .storage {
    border: 1px solid black;
    border-radius: 5px;
    padding: 10px;
    margin-top: 10px;

    &__getValue {
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
