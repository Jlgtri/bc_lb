<script lang="ts">
  export let balance: number | null = null,
    total: number | null = null;
</script>

<div class="balance">
  <span>У вас на рахунку</span>
  <span class="balance__amount">
    {balance != null ? balance + ' кексів' : 'немає кексів'}
  </span>
  <span>Усього залишилось</span>
  <span class="balance__amount">
    {total !== null ? total + ' кексів' : 'жодних кексів'}
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
