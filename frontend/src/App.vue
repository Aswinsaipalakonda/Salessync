<template>
  <div id="app">
    <router-view />
  </div>
</template>

<script>
import router from './router';

export default {
  router
};
</script>
<style>
  #app{
    width: 100%;
  }
</style>