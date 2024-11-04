import RootView from '@/views/RootView.vue'
import LoginView from '@/views/LoginView.vue'
import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '@/views/HomeView.vue'
import CreateRequestView from '@/views/CreateRequestView.vue'
import ListRequestsView from '@/views/ListRequestsView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/login',
      name: 'Login',
      component: LoginView,
    },
    {
      path: '/',
      name: 'Dashboard',
      component: RootView,
      children: [
        {
          path: '',
          name: 'Home',
          component: HomeView,
        },
        {
          path: '/create',
          name: 'CreateRequest',
          component: CreateRequestView,
        },
        {
          path: '/listrequest',
          name: 'ListRequests',
          component: ListRequestsView,
        },
      ],
    },
  ],
})

export default router
