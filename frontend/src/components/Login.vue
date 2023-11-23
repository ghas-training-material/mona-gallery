<template>
  <div>
    <div id="carouselExampleControls" class="carousel slide carousel-fade" data-bs-ride="carousel">
      <div class="carousel-inner ">
        <div class="carousel-item active" data-bs-interval="2500">

          <img src="../assets/images/NUX_Octodex.gif" class="d-block vh-auto" alt="...">

          <div class="carousel-caption">
            <div>
              <img src="../assets/images/gh-mark.png" alt="" class="dp-container container " />
            </div>
            <a href="#" @click="login" class="btn btn-dark">Login with GitHub</a>
          </div>
        </div>
        <div class="carousel-item" data-bs-interval="2500">
          <img src="../assets/images/mona-lovelace.jpg" class="d-block vh-auto" alt="...">
          <div class="carousel-caption">
            <div>
              <img src="../assets/images/gh-mark.png" alt="" class="dp-container container " />
            </div>
            <a href="#" @click="login" class="btn btn-dark">Login with GitHub</a>
          </div>
        </div>
        <div class="carousel-item" data-bs-interval="2500">
          <img src="../assets/images/justicetocat.jpg" class="d-block vh-auto" alt="...">
          <div class="carousel-caption">
            <div>
              <img src="../assets/images/gh-mark.png" alt="" class="dp-container container " />
            </div>
            <a href="#" @click="login" class="btn btn-dark">Login with GitHub</a>
          </div>

        </div>

      </div>
      <button class="carousel-control-prev" type="button" data-bs-target="#carouselExampleControls" data-bs-slide="prev">
        <span class="carousel-control-prev-icon" aria-hidden="true"></span>
        <span class="visually-hidden">Previous</span>
      </button>
      <button class="carousel-control-next" type="button" data-bs-target="#carouselExampleControls" data-bs-slide="next">
        <span class="carousel-control-next-icon" aria-hidden="true"></span>
        <span class="visually-hidden">Next</span>
      </button>
    </div>
    <div v-if="hasError">
      <p v-html="error"></p>
    </div>
  </div>
</template>




<script>
export default {
  name: "Login",
  computed: {
    hasError() {
      const params = new URLSearchParams(window.location.search)
      return params.has('error')
    },
    error() {
      const params = new URLSearchParams(window.location.search)
      return params.get('error')
    },
  },
  methods: {
    login() {
      // const returnUrl = this.$route.query.returnUrl || "/";

      // this.$store.dispatch("nonce").then(nonce => {
      //   const state = btoa(`${nonce}:${returnUrl}`);
      //   window.location =
      //     `https://github.com/login/oauth/authorize?client_id=aad2f5434c1efdb25ce6&return_url=${window.location.origin}/login/callback&state=${state}`;
      // });

      const client_id = "web";
      const issuer = "http://localhost:9998/";
      const redirect_uri = `${window.location.origin}/login/callback`;
      const response_type = "code";
      const scope = "openid profile";
      const url = encodeURI(`${issuer}auth?client_id=${client_id}&redirect_uri=${redirect_uri}&response_type=${response_type}&scope=${scope}`);
      window.location = url;
    },
  },
};
</script>

<style scoped>
.carousel-inner {
  position: relative;
}

.btn-dark {
  position: relative;
  bottom: 150px;
  right: -300px;
  font-size: x-large;

  width: 305px;
  height: 60px;
}


.dp-container {
  position: relative;
  width: 400px;
  height: 400px;
  border: 2px solid black;
  padding: 1px;
  z-index: 1000;
  background-color: rgb(220, 220, 220);
  bottom: 200px;
  right: -300px;

}
</style>