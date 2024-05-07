<script lang="ts">
  export let candidate: Candidate | null;

  import { createEventDispatcher } from 'svelte';

  const dispatch = createEventDispatcher();
</script>

<div class="inform">
  <div class="inform__input">
    <input
      type="number"
      placeholder="Введіть номер кандидата"
      value={candidate?.id}
      on:change={(e) => dispatch('change', e.currentTarget.value)} />
  </div>

  <div class="inform__items">
    <div class="inform__items_item">
      <div class="">Прізвище</div>
      <div class="inform__items_item_text">{candidate?.lastName ?? ''}</div>
    </div>
    <div class="inform__items_item">
      <div class="">Ім'я</div>
      <div class="inform__items_item_text">{candidate?.name ?? ''}</div>
    </div>
    <div class="inform__items_item">
      <div class="">Побатькові</div>
      <div class="inform__items_item_text">{candidate?.patronymic ?? ''}</div>
    </div>
    <div class="inform__items_item">
      <div class="">Інформація</div>
      <div class="inform__items_item_text">{candidate?.info ?? ''}</div>
    </div>
  </div>
</div>

<style lang="scss">
  .inform {
    width: 300px;
    &__input {
      padding: 10px 0px;

      input {
        width: 100%;
      }
    }

    &__items_item {
      border: 1px solid var(--blueColor);
      padding: 5px 5px;
      margin-bottom: 10px;
      border-radius: 3px;
      display: grid;
      grid-template-columns: repeat(2, 50%);

      &_text {
        color: black;
      }
    }
  }
</style>
