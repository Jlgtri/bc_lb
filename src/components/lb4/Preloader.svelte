<script lang="ts">
  import LockedFunds from './LockedFunds/LockedFunds.svelte';
  import SimpleTrustlessEscrow from './SimpleTrustlessEscrow/SimpleTrustlessEscrow.svelte';
  import VendingMachine from './VendingMachine/VendingMachine.svelte';

  $: isFetching = false;
</script>

<div class="preloader {isFetching ? '' : 'hidden'}">
  <div class="preloader__body">Loading...</div>
</div>

<VendingMachine on:load={({ detail: value }) => (isFetching = value)} />
<LockedFunds on:load={({ detail: value }) => (isFetching = value)} />
<SimpleTrustlessEscrow on:load={({ detail: value }) => (isFetching = value)} />

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
