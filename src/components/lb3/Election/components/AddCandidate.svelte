<script lang="ts">
  $: candidate = {} as Candidate;

  import { createEventDispatcher } from 'svelte';

  const dispatch = createEventDispatcher();
</script>

<div class="addCandidate">
  <div class="addCandidate__item">
    <input
      type="text"
      placeholder="введіть ім'я"
      value={candidate.name ?? ''}
      on:change={(e) => (candidate.name = e.currentTarget.value)} />
  </div>
  <div class="addCandidate__item">
    <input
      type="text"
      placeholder="введіть прізвище"
      value={candidate.lastName ?? ''}
      on:change={(e) => (candidate.lastName = e.currentTarget.value)} />
  </div>
  <div class="addCandidate__item">
    <input
      type="text"
      placeholder="введіть побатькові"
      value={candidate.patronymic ?? ''}
      on:change={(e) => (candidate.patronymic = e.currentTarget.value)} />
  </div>
  <div class="addCandidate__item">
    <input
      type="text"
      placeholder="введіть інфориацію"
      value={candidate.info ?? ''}
      on:change={(e) => (candidate.info = e.currentTarget.value)} />
  </div>
  <div class="addCandidate__btn">
    <button on:click={() => dispatch('change', candidate)}>
      Додати кандидата
    </button>
  </div>
</div>

<style lang="scss">
  .addCandidate {
    width: 300px;

    &__item {
      padding: 10px 0px;

      input {
        width: 100%;
      }
    }

    &__btn {
      margin-top: 10px;
      width: 100%;

      button {
        width: 100%;
      }
    }
  }
</style>
