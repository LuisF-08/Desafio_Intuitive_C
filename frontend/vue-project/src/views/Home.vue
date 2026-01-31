<template>
  <div>
    <h1>Operadoras</h1>

    <input v-model="busca" placeholder="Buscar por CNPJ" />
    <div style="margin: 10px 0;">
      <p>Total carregado: {{ operadoras.length }}</p>
      <p>Total exibido: {{ listaFiltrada.length }}</p>
    </div>
    <GraficoDespesas />
    
    <hr>
    <table border="1">
      <thead>
        <tr>
          <th>CNPJ</th>
          <th>Razão Social</th>
          <th>Ações</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="op in listaFiltrada" :key="op.cnpj">
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
import { ref, onMounted, computed } from 'vue'
import OperadoraService from '../services/OperadoraService'
import GraficoDespesas from '../views/GraficoDespesas.vue'

const operadoras = ref([])
const busca = ref('')

const listaFiltrada = computed(() => {
  if (!busca.value.trim()) {
    return operadoras.value
  }
  const termo = busca.value.toLowerCase()
  const termoSoNumeros = termo.replace(/\D/g, '')

  return operadoras.value.filter(op => {
    const cnpjLimpo = String(op.cnpj).replace(/\D/g, '')
    const razaoSocial = op.razao_social ? op.razao_social.toLowerCase() : ''

    return cnpjLimpo.includes(termoSoNumeros) || 
            razaoSocial.includes(termo)
  })
})

onMounted(async () => {
  // criei uma rota comum de teste sendo a api.js mas com o
  // OperadoraService se for expandir facilita posssíveis implementações
  const response = await OperadoraService.listar(1000)
  operadoras.value = response.data
})
</script>