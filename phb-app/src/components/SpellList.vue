<template lang="pug">
  v-expansion-panel(popout,expand).mb-2
    v-expansion-panel-content(
      v-for="spell in sorted_spells(spells)"
      v-bind:spell="spell"
      v-bind:key="spell.id"
      hide-actions)
      div(slot="header")
        v-layout.spell-header
          v-flex.xs4.sm3.lg2
            spell-type(:spell="spell")
          v-flex.xs8.sm9.lg2
            strong {{ spell.name }}
          v-flex.hidden-md-and-down.lg2
            spell-duration(:spell="spell")
          v-flex.hidden-md-and-down.lg2
            spell-range-area(:spell="spell")
          v-flex.hidden-md-and-down.lg2 {{ spell.attack_type[0] }}
            span(v-if="spell.attack_type.length > 1") (...)
          v-flex.hidden-md-and-down.lg2
            spell-damage-effect(:spell="spell")
      v-card
        v-card-text.grey.lighten-3
          spell-info(:spell="spell").mt-2
          v-btn(small primary dark :to="`/spells/${spell.id}`") Spell Page

</template>

<script>
  import SpellType from "./SpellType.vue";
  import SpellDuration from "./SpellDuration.vue";
  import SpellRangeArea from "./SpellRangeArea.vue";
  import SpellDamageEffect from "./SpellDamageEffect.vue";
  import SpellInfo from "./SpellInfo.vue";

  export default {
    components: {
      SpellType, SpellDuration, SpellRangeArea, SpellDamageEffect, SpellInfo
    },
    name: 'SpellList',
    props: ['spells'],
    methods: {
      sorted_spells: function(spells) {
        spells = spells.slice();
	spells.sort(function(a, b) {
	  if (a.type < b.type)
	    return -1;
	  if (a.type > b.type)
	    return 1;

	  if (a.level < b.level)
	    return -1
	  if (a.level > b.level)
	    return 1;

          if (a.name < b.name)
	    return -1
	  if (a.name > b.name)
	    return 1;

          return 0;
	});
        return spells;
      }
    },
  };
</script>

