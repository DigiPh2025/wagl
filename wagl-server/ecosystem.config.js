const { env } = require('strapi-utils');
module.exports = {
  // module.exports = ({ env }) => ({
    apps: [
      {
        name: 'strapi',
        cwd: 'C:/Users/USER/Desktop/Wagl/wagl-server',
        script: 'npm',
        args: 'start',
        env: {
        // //   NODE_ENV: 'production',
        //   DATABASE_HOST: 'localhost',
        //   DATABASE_PORT: '5432',
        //   DATABASE_NAME: 'waglDB',
        //   DATABASE_USERNAME: 'postgres',
        //   DATABASE_PASSWORD: 'admin', 
          DATABASE_HOST: env('DATABASE_HOST', 'localhost'),
          DATABASE_PORT: env('DATABASE_PORT', 5432),
          DATABASE_NAME: env('DATABASE_NAME', 'strapi'),
          DATABASE_USERNAME: env('DATABASE_USERNAME', 'strapi'),
          DATABASE_PASSWORD: env('DATABASE_PASSWORD', 'strapi'),
        },
      },
    ],
  // });
  };