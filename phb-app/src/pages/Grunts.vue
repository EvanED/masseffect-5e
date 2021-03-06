<template lang="pug">
  div
    h2.display-3 Grunt Generator
    p.
      Grunts are disposable NPCs based on the Mass Effect archetypes. The #[em Monster Manual] outlines adjusting
      the provided NPC Archetypes with various races, weapons, and abilities. But this can be rather time consuming.
    p.
      This generator enables you to quickly create random grunts with a given Challenge Rating (CR). CRs only go up to 12
      because higher CRs are represent much more powerful monsters. As a point of reference, a Banshee has a CR of 10, so
      a grunt with a CR of 12 would represent a very experienced and deadly NPC.
    v-card.mt-3
      v-card-text
        v-layout(row wrap)
          v-flex(xs12)
            p.display-1 Options
          v-flex(xs12 sm6 md4).px-2
            v-select(
              v-bind:items="crs"
              v-model="cr"
              label="Select a Challenge Rating"
              item-text="cr"
              item-value="cr"
              return-object
              single-line
              bottom
              hint="Challenge Rating"
              persistent-hint
            )
          v-flex(xs12 sm6 md4).px-2
            v-select(
              v-bind:items="classOptions"
              v-model="sc"
              label="Select a Class"
              item-text="name"
              item-value="id"
              return-object
              single-line
              bottom
              hint="Class"
              persistent-hint
            )
          v-flex(xs12 sm6 md4).px-2
            v-select(
              v-bind:items="raceOptions"
              v-model="race"
              label="Select a Race"
              item-text="name"
              item-value="id"
              return-object
              single-line
              bottom
              hint="Race"
              persistent-hint
            )
          v-flex(xs8 offset-xs2).mt-3
            v-btn(@click="getGrunt()" block color="primary") Generate
    v-container.text-xs-center
      v-btn(v-if="savedGrunts.length > 0" large to="encounter") View saved grunts ({{savedGrunts.length}})
    v-container
      v-layout
        v-flex(xs12 sm10 offset-sm1 lg8 offset-lg2)
          stat-block(v-if="grunt" v-bind:stats="grunt")
            template(slot="actions")
              v-btn(
                absolute
                dark
                fab
                top
                right
                @click="saveGrunt(grunt)"
                color="primary"
              ).mr-2
                v-icon save
</template>

<script>
  import {GruntGenerator} from '../mixins/grunt_generator';
  import { mapState } from 'vuex';
  import StatBlock from '../components/StatBlock.vue';

  export default {
    components: {StatBlock},
    name: 'Grunts',
    data() {
      return {
        crs: [],
        races: [],
        classes: [],
        grunt: false
      };
    },
    mixins: [GruntGenerator],
    created() {
      let getRaces = this.$http.get('../data/races.json').then(response => response.json());
      let getClasses = this.$http.get('../data/classes.json').then(response => response.json());
      let getStatsByCr = this.$http.get('../data/stats_by_cr.json').then(response => response.json());
      Promise.all([getRaces, getClasses, getStatsByCr]).then(response => {
        this.crs = response[2];

        // Setup races
        this.races = response[0].data.map((race) => {
          // expand available classes
          race.available_classes = race.available_classes.split(',').map((v) => v.trim());
          return race;
        });

        // Setup classes
        this.classes = response[1].data;
      });
    },
    computed: {
      classOptions: function() {
        let class_options = this.filterClasses(this.race.id);
        class_options.sort(this.compare);
        class_options.unshift({ id: 'random', name: 'Random' });
        class_options.push({ id: 'none', name: 'None' });
        if(!class_options.map( (co) => co.id).includes(this.sc.id)){
          this.sc = class_options[0];
        }
        return class_options;
      },
      raceOptions: function() {
        let race_options = this.filterRaces(this.sc.id);
        race_options.sort(this.compare);
        race_options.unshift({ id: 'random', name: 'Random' });
        if(!race_options.map( (ro) => ro.id).includes(this.race.id)){
          this.race = race_options[0];
        }
        return race_options;
      },
      race: {
        get () {
          return this.$store.state.gruntConfig.race;
        },
        set (value) {
          this.$store.commit('updateGruntConfigRace', value);
        }
      },
      sc: {
        get () {
          return this.$store.state.gruntConfig.sc;
        },
        set (value) {
          this.$store.commit('updateGruntConfigClass', value);
        }
      },
      cr: {
        get () {
          return this.$store.state.gruntConfig.cr;
        },
        set (value) {
          this.$store.commit('updateGruntConfigCr', value);
        }
      },
      savedGrunts: function(){
        return this.$store.state.encounter.npcs.list;
      }
    },
    methods: {
      saveGrunt (grunt) {
        this.$store.commit('addEncounterNpc', grunt);
      },
      filterClasses(race_id){
        return this.classes.filter(a_class => {
          if(race_id === 'random'){
            return true;
          }
          return this.races.find((race) => { return race.id === race_id }).available_classes.includes(a_class.name);
        });
      },
      filterRaces(class_id){
        return this.races.filter(race => {
          if(class_id === 'random') {
            return true;
          }
          const regex = new RegExp(class_id, 'gi');
          return regex.test(race.available_classes)
        });
      },
      compare(a, b) {
        let comparison = 0;
        if(a.name > b.name){
          comparison = 1;
        } else if (b.name > a.name) {
          comparison = -1;
        }
        return comparison;
      },
      getGrunt(){
        // Get the race
        let race = {};
        if(this.race.id === 'random') {
          if (this.sc.id === 'random' || this.sc.id === 'none') {
            race = this.randomValue(this.races);
          } else {
            const races = this.filterRaces(this.sc.id);
            race = this.randomValue(races);
          }
        } else {
          race = this.race;
        }

        // Get the class
        let sc = {};
        if (this.sc.id === 'random') {
          const classes = this.filterClasses(race.id);
          sc = this.randomValue(classes);
        } else {
          sc = this.sc;
        }

        this.grunt = this.generateGrunt(this.cr, race, sc);
      },
    }
  };
</script>
