<script lang="ts">
  export let candidatesCount: number,
    winner: string = '';
</script>

<div class="result">
  <div class="result__item">Кандидатів - {candidatesCount}</div>
  <div class="result__item">Переможець - {winner || 'не обрано'}</div>
</div>

<style lang="scss">
  .result {
    border: 1px solid black;
    display: flex;
    justify-content: space-between;
    color: black;
    padding: 10px 20px;
    background-color: white;

    &__item {
      color: black;
    }
  }
</style>
