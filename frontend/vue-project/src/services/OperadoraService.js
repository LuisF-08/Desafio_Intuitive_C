import api from './api'

export default {
  // Listar todas
  listar(limit = 100) {
    return api.get(`/api/operadoras?limit=${limit}`)
  },

  // Pegar detalhes
  obter(cnpj) {
    return api.get(`/api/operadoras/${cnpj}`)
  },

  // Pegar despesas
  listarDespesas(cnpj) {
    return api.get(`/api/operadoras/${cnpj}/despesas`)
  },
  
  // Pegar estatísticas
  obterEstatisticas() {
    return api.get('/api/estatisticas')
  }
}