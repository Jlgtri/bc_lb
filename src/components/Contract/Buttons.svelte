<script lang="ts">
  export let count: number, daiContract: Counter | null;

  import { createEventDispatcher } from 'svelte';

  const dispatch = createEventDispatcher();

  async function increment() {
    dispatch('change', true);
    try {
      console.log(await (await daiContract!.incrementCounter()).wait());
    } catch {
      alert('Транзакція відхилена');
    } finally {
      dispatch('change', false);
    }
  }

  async function decrement() {
    dispatch('change', true);
    try {
      console.log(await (await daiContract!.decrementCounter()).wait());
    } catch {
      alert('Транзакція відхилена');
    } finally {
      dispatch('change', false);
    }
  }

  $: disabled = !window.ethereum || !daiContract;
</script>

<div class="interface">
  <div class="btn btn_dec">
    <button on:click={decrement} {disabled}>decrement</button>
  </div>
  <div class="count">{count}</div>
  <div class="btn">
    <button on:click={increment} {disabled}>increment</button>
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
