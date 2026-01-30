<template>
  <div>
    <h1>Detalhes da Operadora</h1>

    <ul>
      <li v-for="d in despesas" :key="d.id">
        {{ d.ano }} - {{ d.mes }} : R$ {{ d.valor }}
      </li>
    </ul>

    <router-link to="/">Voltar</router-link>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import api from '../services/api'

const route = useRoute()
const despesas = ref([])

onMounted(async () => {
  const cnpj = route.params.cnpj
  const response = await api.get(`/api/operadoras/${cnpj}/despesas`)
  despesas.value = response.data
})
</script>
