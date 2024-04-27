<script lang="ts">
  import { createEventDispatcher } from 'svelte';

  export let daiAddress: string,
    placeholder: string = 'Введіть значення',
    error: string = '';

  const dispatch = createEventDispatcher();
</script>

<div class="input">
  <div class="input__title">Введіть адрессу смарт - контракту</div>
  <input
    type="text"
    {placeholder}
    value={daiAddress}
    on:input={(e) => dispatch('change', e.currentTarget.value)} />
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
