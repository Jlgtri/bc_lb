<script lang="ts">
  import { getAddress } from 'ethers';
  import { createEventDispatcher } from 'svelte';
  import Input from '../components/Input.svelte';
  import { getContract } from '../utils/web3.svelte';
  import daiAbi from './Election.json';
  import AddCandidate from './components/AddCandidate.svelte';
  import Buttons from './components/Buttons.svelte';
  import FormVote from './components/FormVote.svelte';
  import GetCandidate from './components/GetCandidate.svelte';
  import Popup from './components/Popup.svelte';
  import ResultTable from './components/ResultTable.svelte';

  const dispatch = createEventDispatcher();

  $: candidatesCount = 0;
  $: winner = '';

  $: popupMode = false;
  $: popupBody = 0;

  $: error = '';

  const emptyCandidate = {} as Candidate;
  $: candidate = emptyCandidate;

  let daiContract: Election | null;
  $: daiContract = null;

  let daiAddress: string;
  $: daiAddress = '';

  async function getDaiContract(_daiAddress: string | null = null) {
    try {
      candidatesCount = 0;
      winner = '';
      popupMode = false;
      popupBody = 0;
      error = '';
      daiAddress = getAddress(_daiAddress ?? '');
    } catch {
      daiContract = null;
      error = 'Адрес не вірний';
      return;
    }

    daiContract = (await getContract(daiAddress, daiAbi)) as Election;
    try {
      await getTableInfo();
    } catch {
      daiContract = null;
      error = 'Помилка завантаження';
      return;
    }
  }

  async function addCandidate(candidate: Candidate) {
    dispatch('load', true);
    try {
      let tx = await daiContract!.addCandidate(
        candidate.name,
        candidate.lastName,
        candidate.patronymic,
        candidate.info,
      );
      console.log(await tx.wait());
    } catch (_) {
      alert('Транзакція відхилена');
    } finally {
      dispatch('load', false);
    }
  }

  async function getVoter(address: string) {
    try {
      getAddress(address);
    } catch (exception) {
      return alert('Адрес не вірний');
    }

    try {
      const rez = await daiContract!.voters(address);
      alert(address + '-' + (rez ? '' : 'не') + 'голосував');
    } catch (exception) {
      alert('Помилка під час завантаження даних');
      console.error((exception as Error).message);
    }
  }

  async function setVote(id: number) {
    dispatch('load', true);
    try {
      console.log(await (await daiContract!.vote(id)).wait());
      await getTableInfo();
    } catch (_) {
      alert('Транзакція відхилена');
    } finally {
      dispatch('load', false);
    }
  }

  async function getTableInfo() {
    candidatesCount = await daiContract!.candidatesCount();
    const id = await daiContract!.winningProposal();
    winner = (await daiContract!.candidates(id))?.lastName ?? '';
  }
</script>

<div class="content">
  <main class="main">
    <div class="centerForm">
      <Input
        {daiAddress}
        {error}
        on:change={({ detail: value }) => getDaiContract(value)} />

      <div class="mainForm">
        <ResultTable {candidatesCount} {winner} />
        <FormVote
          disabled={!window.ethereum || !daiContract}
          on:check={({ detail: value }) => getVoter(value)}
          on:vote={({ detail: value }) => setVote(value)} />
        <Buttons
          disabled={!window.ethereum || !daiContract}
          on:change={({ detail: value }) => {
            popupMode = true;
            popupBody = value;
          }} />
      </div>
      {#if popupMode}
        <Popup on:change={() => (popupMode = false)}>
          {#if !popupBody}
            <AddCandidate
              on:change={({ detail: value }) => addCandidate(value)} />
          {:else}
            <GetCandidate
              {candidate}
              on:change={async ({ detail: value }) =>
                (candidate =
                  (await daiContract?.candidates(Number(value))) ??
                  emptyCandidate)} />
          {/if}
        </Popup>
      {/if}
    </div>
  </main>
</div>

<style lang="scss">
  .main {
    min-height: 100vh;
    background-image: url('https://images.wallpaperscraft.ru/image/single/minimalizm_nebo_oblaka_95458_1920x1080.jpg');
    background-repeat: no-repeat;
    background-position: center;
    background-size: cover;
    display: flex;
    align-items: center;
    justify-content: center;
    position: relative;
  }
  .centerForm {
    border: 1px solid black;
    background-color: rgba(255, 255, 255, 0.7);
    border-radius: 5px;
    padding: 10px;
    min-width: 400px;
    color: var(--grayColor);
  }
</style>
