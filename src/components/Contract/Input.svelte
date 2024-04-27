<script lang="ts">
  import { getAddress } from 'ethers';
  import { createEventDispatcher } from 'svelte';

  export let daiAddress;

  const dispatch = createEventDispatcher();

  $: error = '';
  $: _daiAddress = daiAddress;

  const checkAddress = (address: string) => {
    error = '';
    try {
      dispatch('change', (_daiAddress = getAddress(address)));
    } catch {
      error = 'Адрес не вірний';
    }
  };
</script>

<div class="input">
  <div class="input__title">Введіть адрессу смарт - контракту</div>
  <input
    type="text"
    placeholder="Введіть counter AT"
    value={_daiAddress}
    on:input={(e) => checkAddress(e.currentTarget.value)} />
  <div class="input__error">{error}</div>
</div>

<style lang="scss">
  .input {
    padding: 10px 0px;
    margin-bottom: 20px;
    &__title {
      text-align: center;
      margin-bottom: 20px;
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
