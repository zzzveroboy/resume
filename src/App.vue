<template>
  <div class="app">
    <div class="window">
      <h1>open-api</h1>
      <open-api />
    </div>
  </div>
</template>

<script>
import OpenApi from './OpenApi.vue';

export default {
  name: 'App',

  components: {
    'open-api': OpenApi
  }
}
</script>

<style>
* {
  padding: 0;
  margin: 0;
  box-sizing: border-box;
}

#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
}

.app {
  display: flex;
}

.window {
  max-width: 50vw;
  min-width: 50vw;
  border: 5px solid black;
}
</style>