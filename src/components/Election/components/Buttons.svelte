<script lang="ts">
  export let disabled: boolean = false;

  import { createEventDispatcher } from 'svelte';

  const dispatch = createEventDispatcher();
</script>

<div class="buttons">
  <button {disabled} on:click={() => dispatch('change', 0)}>
    Додати кандидата
  </button>
  <button {disabled} on:click={() => dispatch('change', 1)}>
    Інформація про кандидата
  </button>
</div>

<style lang="scss">
  .buttons {
    display: grid;
    grid-template-columns: 47% 1fr 47%;
  }
</style>
