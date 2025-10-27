import axios from 'axios';

const API = axios.create({
  baseURL: 'http://localhost:5000/api/terraform', // backend URL
});

export const deploy = (payload) => API.post('/deploy', payload);
export const getHistory = () => API.get('/history');
export const destroy = (workspace) => API.post('/destroy', { workspace });
;
