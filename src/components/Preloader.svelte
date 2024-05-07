<script lang="ts">
  import Counter from './Counter/Counter.svelte';
  import Election from './Election/Election.svelte';
  import SimpleStorage from './SimpleStorage/SimpleStorage.svelte';

  $: isFetching = false;
</script>

{#if isFetching}
  <div class="preloader">
    <div class="preloader__body">Loading...</div>
  </div>
{:else}
  <Counter on:load={({ detail: value }) => (isFetching = value)} />
  <SimpleStorage on:load={({ detail: value }) => (isFetching = value)} />
  <Election on:load={({ detail: value }) => (isFetching = value)} />
{/if}

<style lang="scss">
  .preloader {
    height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;

    &__body {
      text-align: center;
      font-size: 30px;
      font-weight: bold;
    }
  }
</style>
