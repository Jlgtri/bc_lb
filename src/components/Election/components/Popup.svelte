<script lang="ts">
  import { createEventDispatcher } from 'svelte';

  const dispatch = createEventDispatcher();
</script>

<div class="popup">
  <button
    type="button"
    class="popup__background"
    on:click={() => dispatch('change')}>
  </button>
  <div class="popup__body">
    <slot />
  </div>
</div>

<style lang="scss">
  .popup {
    position: absolute;
    top: 0;
    left: 0;
    border-radius: 5px;
    width: 100%;
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: center;

    &__background {
      width: 100%;
      height: 100%;
      position: absolute;
      top: 0;
      left: 0;
      background-color: rgba(0, 0, 0, 0.5);
    }

    &__body {
      position: relative;
      z-index: 10;
      display: grid;
      grid-template-columns: repeat(2, 50%);
      background-color: #e3e3e3;
      padding: 20px;
      border-radius: 5px;
    }
  }
</style>
