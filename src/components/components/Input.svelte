<script lang="ts">
  import { getAddress } from 'ethers';
  import { createEventDispatcher } from 'svelte';

  export let name: string = 'смарт - контракту',
    placeholder: string = 'Введіть значення';

  const dispatch = createEventDispatcher();

  $: error = '';

  async function change(value: string) {
    try {
      error = '';
      dispatch('change', getAddress(value).toLowerCase());
    } catch {
      error = 'Адрес не вірний';
    }
  }
</script>

<div class="input">
  <div class="input__title">
    Введіть адресу <span class="input__title__bold">{name}</span>
  </div>
  <input
    type="text"
    {placeholder}
    on:input={(e) => change(e.currentTarget.value)} />
  <div class="input__error">{error}</div>
</div>

<style lang="scss">
  .input {
    padding: 10px 0px;
    margin-bottom: 20px;

    &__title {
      text-align: center;
      margin-bottom: 20px;

      &__bold {
        font-weight: bold;
        filter: brightness(90%);
      }
    }

    &__error {
      text-align: center;
      font-weight: normal;
      font-size: 16px;
      color: red;
    }

    input {
      width: 100%;
      box-sizing: border-box;
      padding: 5px 10px;
      text-align: center;
    }
  }
</style>
