<template>
  <div>
    <h1>Operadoras</h1>

    <input v-model="busca" placeholder="Buscar..." />
    <button @click="buscar">Buscar</button>

    <table border="1">
      <thead>
        <tr>
          <th>CNPJ</th>
          <th>Razão Social</th>
          <th>Ações</th>
        </tr>
      </thead>
      <p>Total carregado: {{ operadoras.length }}</p>
      <p>Total exibido: {{ lista.length }}</p>
      <tbody>
        <tr v-for="op in lista" :key="op.cnpj">
          <td>{{ op.cnpj }}</td>
          <td>{{ op.razao_social }}</td>
          <td>
            <router-link :to="`/operadora/${op.cnpj}`">
              Ver detalhes
            </router-link>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import api from '../services/api'

const operadoras = ref([])
const busca = ref('')
const lista = ref([])

const buscar = () => {
  if (!busca.value.trim()) {
    lista.value = operadoras.value
    return
  }

  const termo = busca.value.toLowerCase()

  lista.value = operadoras.value.filter(op =>
    op.cnpj.includes(termo) ||
    op.razao_social.toLowerCase().includes(termo)
  )
}

onMounted(async () => {
  try {
    const response = await api.get('/api/operadoras')
    console.log('STATUS:', response.status)
    console.log('DATA:', response.data)

    operadoras.value = response.data
    lista.value = response.data
  } catch (error) {
    console.error('Erro ao buscar operadoras', error)
  }
})

</script>
