<template lang="pug">
  v-card
    v-card-title(primary-title)
      div
        spell-info(:spell="spell")
</template>

<script>
  import SpellInfo from "../components/SpellInfo.vue";

  export default {
    name: 'Spell',
    data() {
      return {
        spell: {}
      };
    },
    created() {
      return this.$http
        .get('../data/spells.json')
        .then(response => response.json())
        .then(response => {
          this.spell = response.data.find((value) => {
            return value.id == this.$route.params.id;
          });
        });
    },
    components: {
      SpellInfo
    }
  };
</script>
