<template>
  <div>
    <!-- Exibe dados da operadora se já carregou -->
    <div v-if="operadora">
      <h1>{{ operadora.razao_social }}</h1>
      <p><strong>CNPJ:</strong> {{ operadora.cnpj }}</p>
      <p><strong>Registro ANS:</strong> {{ operadora.registro_ans }}</p>
    </div>
    <div v-else>
      <h1>Carregando dados da operadora...</h1>
    </div>
    <hr />
    <h2>Histórico de Despesas</h2>
    <div v-if="despesas.length > 0">
      <ul style="list-style: none; padding: 0;">
        <li v-for="d in despesas" :key="d.id || d.trimestre + d.ano" style="margin-bottom: 10px; border-bottom: 1px solid #ccc;">
          <!-- Ajuste aqui conforme os campos reais da DespesasConsolidadas) -->
          <strong>Ano:</strong> {{ d.ano }} | 
          <strong>Trimestre:</strong> {{ d.trimestre }} | 
          <strong>Valor:</strong> R$ {{ d.valor_despesa }}
        </li>
      </ul>
    </div>
    <p v-else>Nenhuma despesa encontrada para esta operadora.</p>

    <router-link to="/">
      <button>Voltar para Lista</button>
    </router-link>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import api from '../services/api'

const route = useRoute()
const despesas = ref([])
const operadora = ref(null) // Variável para guardar os dados do cabeçalho

onMounted(async () => {
  const cnpj = route.params.cnpj

  try {
    // Essa rota no backend como: @app.get("/api/operadoras/{cnpj}")
    const respOperadora = await api.get(`/api/operadoras/${cnpj}`)
    operadora.value = respOperadora.data

    //  Busca as Despesas (Lista)
    const respDespesas = await api.get(`/api/operadoras/${cnpj}/despesas`)
    despesas.value = respDespesas.data

  } catch (error) {
    console.error("Erro ao carregar detalhes:", error)
    alert("Erro ao buscar dados. Verifique o console.")
  }
})
</script>