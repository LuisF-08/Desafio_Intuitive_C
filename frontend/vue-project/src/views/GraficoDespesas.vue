<template>
  <div class="grafico-container">
    <h2>Distribuição de Despesas por UF</h2>
    
    <div v-if="carregando">Carregando gráfico...</div>
    
    <div v-else-if="chartData.labels.length > 0" class="chart-wrapper">
      <!-- O componente do gráfico -->
      <Bar :data="chartData" :options="chartOptions" />
    </div>
    
    <div v-else>Não há dados para exibir.</div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import api from '../services/api'
import { Bar } from 'vue-chartjs'
import { Chart as ChartJS, Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale } from 'chart.js'
ChartJS.register(Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale)

const carregando = ref(true)
const chartData = ref({ labels: [], datasets: [] })

// Configurações visuais do gráfico
const chartOptions = {
  responsive: true,
  maintainAspectRatio: false,
  plugins: {
    legend: { position: 'top' }
  }
}

onMounted(async () => {
  try {
    const response = await api.get('/api/estatisticas/despesas-por-uf')
    const dadosAPI = response.data 

    // Transformando dados da API para o formato do Chart.js
    const ufs = dadosAPI.map(item => item.uf)         // ['SP', 'RJ']
    const valores = dadosAPI.map(item => item.total)  // [1000, 500]

    chartData.value = {
      labels: ufs,
      datasets: [
        {
          label: 'Total de Despesas (R$)',
          backgroundColor: '#42b983', // Cor das barras (Verde Vue)
          data: valores
        }
      ]
    }
    
  } catch (error) {
    console.error("Erro ao carregar gráfico", error)
  } finally {
    carregando.value = false
  }
})
</script>

<style scoped>
.grafico-container {
  padding: 20px;
  background: #f9f9f9;
  border-radius: 8px;
  margin-top: 20px;
}
.chart-wrapper {
  height: 400px;
  position: relative;
}
</style>