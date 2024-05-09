<script lang="ts">
  import { formatEther } from 'ethers';

  export let transactionCount: number | null = null,
    transactionAmount: bigint | null = null;
</script>

<div class="storage">
  <span>Кількість транзакцій</span>
  <span class="storage__getValue">
    {transactionCount ?? 'Не визначена'}
  </span>
  <span>Cума транзакцій</span>
  <span class="storage__getValue">
    {transactionAmount !== null
      ? formatEther(transactionAmount) + ' ETH'
      : 'Не визначена'}
  </span>
</div>

<style lang="scss">
  .storage {
    border: 1px solid black;
    border-radius: 5px;
    padding: 10px;
    margin-top: 10px;

    &__getValue {
      background-color: white;
      text-align: center;
      font-size: 20px;
      font-weight: bold;
      margin-bottom: 10px;
      padding: 7px 25px;
      border: 1px solid black;
      color: black;
    }
  }
</style>
