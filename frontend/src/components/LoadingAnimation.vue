<template>
    <div v-if="isVisible" id="loading-spinner" class="spinner-overlay">
      <div class="spinner">
        <img :src="require('@/assets/loading.gif')" alt="loadinganimation">  </div>
    </div>
</template>

<script>
  export default {
      name: 'LoadingComponent',
      props: {
        isVisible: {
            type: Boolean,
            default: false,
        }
      }
  };
</script>

<style scoped>
.spinner-overlay{
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    z-index: 9999;
    display: flex;
    justify-content: center;
    align-items: center;
    background-color: rgba(0, 0, 0, 0.8);
}
.spinner img{
    width: 30px;
    height: 30px;
}
</style>
