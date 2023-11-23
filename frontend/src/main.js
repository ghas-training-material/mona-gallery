//import './assets/main.css'
import 'bootstrap/dist/css/bootstrap.css'
import "bootstrap/dist/js/bootstrap.js"
import {  createApp } from 'vue'
import { createStore } from 'vuex'
import { createPinia, defineStore } from 'pinia'
import Axios from 'axios'


import App from './App.vue'
import router from './router'
import store from './stores/store'

const app = createApp(App)


Axios.interceptors.request.use(function (config) {
    const token = store.getters.token
    if (token != '') {
      config.headers.Authorization = `Bearer ${token}`
    } else {
      config.headers.Authorization = ''
    }
      
    return config;
  });
  

app.use(createPinia())
app.use(store)
app.use(router)


app.mount('#app')

