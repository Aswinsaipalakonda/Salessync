const config = {
    apiUrl: window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1' ? 'http://127.0.0.1:8000' : ''
};
  
export default config;