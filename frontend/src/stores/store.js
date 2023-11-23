import { createStore } from 'vuex'
import Axios from 'axios'

const store = createStore({
    id: 'gallery',
      state: () => ({
        token: localStorage.getItem("token") || '',
        nonce: null,
        gallery: null
      }),
      mutations: {
        token(state, token) {
          state.token = token
        },
        nonce(state, nonce) {
          state.nonce = nonce
        }
      },
      actions: {
        // authenticate({ commit }, {code, state}) {
        authenticate({ commit }, {code}) {
          return new Promise((resolve, reject) => {
            Axios.get(`http://localhost:5000/authenticate/${code}`).then((response) => {
              if (response.data.token) {
                const token = response.data.token
                console.log("Authenticated with token", token)
                commit('token', token )
                localStorage.setItem('token', token)
      
                // const [nonce, returnUrl] = atob(state).split(':', 2)
                // console.log("Received authentication state with nonce", nonce, "and return url", returnUrl)
                const returnUrl = "http://localhost:5173/gallery"; //change back to 8080
                resolve(returnUrl)
              } else {
                reject(response.data.error)
              }
            }).catch((e) => {
              reject(e)
            })
          })
        },
        logout({ commit }) {
          return new Promise((resolve) => {
            console.log("Logout")
            commit('token', null)
            localStorage.removeItem('token')
            resolve()
          })
        },
        nonce({commit}) {
          return new Promise((resolve) => {
            var stateArray = new Uint8Array(16);
            window.crypto.getRandomValues(stateArray);
            // First convert a typed array to normal array before transforming into a hex string.
            // Otherwise, we will loose randomness due to the wrapping of Uint8.
            const nonce = Array.from(stateArray)
              .map((i) => ("0" + i.toString(16)).slice(-2))
              .join("");
    
            commit('nonce', nonce)
            resolve(nonce)
          })
        }
       
      },
      getters: {
        isLoggedIn: state => !!state.token,
        profile: state => jwt.decode(state.token)['profile'],
        token: state => state.token,
        nonce: state => state.nonce,
  
      }
    })

 export default store