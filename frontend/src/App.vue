<script setup>
import { RouterLink, RouterView, useRouter } from 'vue-router'
import logo from "./assets/images/gh-mark.png";



</script>

<template>
  <nav class="navbar navbar-expand-lg navbar-light bg-light">
    <div class="container-fluid">
      <a class="navbar-brand" href="#">
        <img :src="logo" alt="" width="30" height="24" class="d-inline-block align-text-top" />
        GitHub Mona Gallery
      </a>
    </div>
    <template v-if="this.isLoggedIn">
      <button type="button" @click="logout" class="btn btn-dark">Logout</button>
    </template>

  </nav>

  <RouterView />
</template>

<style scoped></style>

<script>

export default {
  name: "App",
  computed: {
    isLoggedIn() {
      return this.$store.getters.isLoggedIn;
    },
    profile() {
      return this.$store.getters.profile;
    },
  },
  methods: {
    logout() {
      this.$router.push({ path: '/logout' });
    },
  },
};

</script>