import axios from 'axios'

// mostra o caminho central para o vue de aonde percorrer pra pegar os dados 
// usei inicialmente só para o GET simples,  mas está sem uso :(
const api = axios.create({
  baseURL: 'http://localhost:8000',
})

export default api
