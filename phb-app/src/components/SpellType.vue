<template lang="pug">
  span
    div.spell-icon
      me-icon(type="spells" v-bind:name="spell.type")
    span(v-if="spell.type === 'biotic'").hidden-xs-only  {{ level }}
</template>

<script>
  import MeIcon from "./MeIcon.vue";

  export default {
    components: {
      MeIcon
    },
    name: 'SpellRangeArea',
    props: ['spell'],
    created () {
      if(this.spell.type === 'biotic'){
        switch(this.spell.level){
          case '0':
            this.level = 'cantrip';
            break;
          case '1':
            this.level = '1st-level';
            break;
          case '2':
            this.level = '2nd-level';
            break;
          case '3':
            this.level = `3rd-level`;
            break;
          default:
            this.level = `${this.spell.level}th-level`;
        }
      }
    },
    data () {
      return {
        level: ''
      }
    }
  };
</script>

<style lang="stylus">
  .spell-icon
    width: 25px;
    display: inline-block;
    vertical-align: middle;
</style>

