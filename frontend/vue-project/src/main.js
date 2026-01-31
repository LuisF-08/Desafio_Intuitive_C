import { createApp } from 'vue'
import App from './App.vue'
import router from './router'

// starta o server
createApp(App).use(router).mount('#app')
