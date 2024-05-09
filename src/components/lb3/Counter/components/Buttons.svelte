<script lang="ts">
  export let count: number,
    disabled: boolean = false;

  import { createEventDispatcher } from 'svelte';

  const dispatch = createEventDispatcher();
</script>

<div class="interface">
  <div class="btn btn_dec">
    <button on:click={() => dispatch('decrement')} {disabled}>
      decrement
    </button>
  </div>
  <div class="count">{count}</div>
  <div class="btn">
    <button on:click={() => dispatch('increment')} {disabled}>
      increment
    </button>
  </div>
</div>

<style lang="scss">
  /* style for interface */
  .interface {
    display: flex;
    text-align: center;
    justify-content: center;
  }

  .count {
    background-color: white;
    color: var(--grayColor);
    padding: 10px 20px;
  }

  .btn {
    border-radius: 0px 5px 5px 0px;
    overflow: hidden;

    button {
      cursor: pointer;
      width: 100%;
      height: 100%;
      background-color: green;
      border: none;
      padding: 0px 20px;
      color: white;
    }

    button[disabled] {
      border: 1px solid #999999;
      background-color: #cccccc;
      color: #666666;
    }
  }

  .btn_dec {
    border-radius: 5px 0px 0px 5px;

    button {
      cursor: pointer;
      width: 100%;
      height: 100%;
      background-color: var(--pinkColor);
    }
  }
</style>
