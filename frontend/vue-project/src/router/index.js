import { createRouter, createWebHistory } from 'vue-router'
import Home from '../views/Home.vue'
import Detalhes from '../views/Detalhes.vue'

// Localização das rotas usadas
const routes = [
  { path: '/', component: Home },
  { path: '/operadora/:cnpj', component: Detalhes }
]

export default createRouter({
  history: createWebHistory(),
  routes
})
