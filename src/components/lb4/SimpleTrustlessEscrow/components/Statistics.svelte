<script lang="ts">
  import { formatEther } from 'ethers';

  export let currentBalance: bigint | null = null,
    balance: bigint | null = null,
    total: bigint | null = null,
    depositedAmount: bigint | null = null,
    releasedAmount: bigint | null = null;
</script>

<div class="balance">
  <span>У вас на рахунку</span>
  <span class="balance__amount">
    {currentBalance !== null
      ? formatEther(currentBalance) + ' ETH'
      : 'немає даних'}
  </span>
</div>

<div class="balance">
  <span>Ваш депозит</span>
  <span class="balance__amount">
    {depositedAmount !== null
      ? formatEther(depositedAmount) + ' ETH'
      : 'немає даних'}
  </span>
  <span>Загальний депозит</span>
  <span class="balance__amount">
    {total !== null ? formatEther(total) + ' ETH' : 'немає даних'}
  </span>
  <span>На балансі контракту</span>
  <span class="balance__amount">
    {balance !== null ? formatEther(balance) + ' ETH' : 'немає даних'}
  </span>
  <span>Усього виведено</span>
  <span class="balance__amount">
    {releasedAmount !== null
      ? formatEther(releasedAmount) + ' ETH'
      : 'немає даних'}
  </span>
</div>

<style lang="scss">
  .balance {
    border: 1px solid black;
    border-radius: 5px;
    padding: 10px;
    margin-top: 10px;

    &__amount {
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
