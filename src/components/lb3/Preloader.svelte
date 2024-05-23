<script lang="ts">
  import Counter from './Counter/Counter.svelte';
  import Election from './Election/Election.svelte';
  import Payment from './PaymentSystem/PaymentSystem.svelte';
  import SimpleStorage from './SimpleStorage/SimpleStorage.svelte';

  $: isFetching = false;
</script>

<div class="preloader {isFetching ? '' : 'hidden'}">
  <div class="preloader__body">Loading...</div>
</div>
<Counter on:load={({ detail: value }) => (isFetching = value)} />
<SimpleStorage on:load={({ detail: value }) => (isFetching = value)} />
<Election on:load={({ detail: value }) => (isFetching = value)} />
<Payment on:load={({ detail: value }) => (isFetching = value)} />

<style lang="scss">
  .preloader {
    display: flex;
    position: fixed;

    height: 100vh;
    z-index: 9999;

    background-color: white;

    left: 0;
    right: 0;
    margin-left: auto;
    margin-right: auto;

    align-items: center;
    justify-content: center;

    &__body {
      text-align: center;
      font-size: 30px;
      font-weight: bold;
    }
  }

  .hidden {
    display: none;
  }
</style>
