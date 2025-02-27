module.exports = ({ env }) => ({

  host: env('HOST', '0.0.0.0'),
  port: env.int('PORT', 1337),
  app: {
    keys: env.array('APP_KEYS'),
  },
  proxy: {
    enabled: true,
    timeout: 1200000, // 20 minutes
  },
  // timeout: 1200000, 
  server: {
    keepAliveTimeout: 1200000, // 60 seconds
    headersTimeout: 1250000,  // Slightly higher than keepAliveTimeout
  },
  webhooks: {
    populateRelations: env.bool('WEBHOOKS_POPULATE_RELATIONS', false),
  },

  // url: env('PUBLIC_URL','http://192.168.1.57:1337')
  url: env('PUBLIC_URL','http://localhost:1337')
});


