import { createRouter, createWebHistory } from 'vue-router'
import store from '../stores/store'
import NotFoundView from '../views/NotFoundView.vue'
import LoginView from '../views/LoginView.vue'
import LogoutView from '../views/LogoutView.vue'
import AuthorizationCallback from '../views/AuthorizationCallbackView.vue'
import Gallery from '../views/GalleryView.vue'


// const router = new VueRouter({
//   mode: 'history',
//   routes: [
//     { path: '/', redirect: '/gallery'},
//     { path: '/login', name: 'Login', component: Login },
//     { path: '/login/callback', name: "AuthorizationCallback", component: AuthorizationCallback },
//     { path: '/logout', name: 'Logout', component: Logout},
//     { path: '/gallery', name: 'Gallery', component: Gallery, meta: { requiresAuth: true } },
//     { path: '*', component: NotFound }
//   ]
// })


const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    { path: '/', redirect: '/login'},
    { path: '/login/callback', name: "AuthorizationCallback", component: AuthorizationCallback },
    { path: '/gallery', name: 'Gallery', component: Gallery, meta: { requiresAuth: true } },
    { path: '/logout', name: 'Logout', component: LogoutView },
    //  {
    //    path: '/login/callback',
    //   name: 'home',
    //   component: HomeView
    // },
    // {
    //   path: '/about',
    //   name: 'about',
    //   // route level code-splitting
    //   // this generates a separate chunk (About.[hash].js) for this route
    //   // which is lazy-loaded when the route is visited.
    //   component: () => import('../views/AboutView.vue')
    // },
    {
      path: '/login',
      name: 'Login',
      component: LoginView
    },
    {
      path:  '/:pathMatch(.*)*', name: 'NotFound', component: NotFoundView
    }
 

  ]
})

const jwt = {
  decode(token) {
    if (!token) return {}
    const claimset = token.split('.', 3)[1]
    return JSON.parse(atob(claimset))
  },
  isExpired(token){
    const claimset = this.decode(token)
    console.log("Claimset:", claimset)
    const exp = claimset['exp']
    if (exp === undefined) {
      return false
    }
    console.log("Token expiration time since epoch:", exp)
    const nowLocal = new Date()
    const nowLocalInSecondsSincEpoch = Math.floor(nowLocal.getTime()/1000)
    console.log("Local time since epoch:", nowLocal.getTime())
    const nowUTCInSecondsSincEpoch = nowLocalInSecondsSincEpoch + nowLocal.getTimezoneOffset() * 60
    console.log("UTC time since epoch:", nowUTCInSecondsSincEpoch)
    console.log("Expiration delta: ", nowUTCInSecondsSincEpoch - exp)
    return exp <= nowUTCInSecondsSincEpoch
  }
}


router.beforeEach((to, from, next) => {
  console.log('beforeEach', to, from)
  if (to.matched.some(record => record.meta.requiresAuth)) {
    if (store.getters.isLoggedIn && !jwt.isExpired(store.getters.token)) {
      next()
      return
    }
    next({ path: '/login', query: { returnUrl: to.path } })
  }
  else {
    next()
  }
})

export default router


