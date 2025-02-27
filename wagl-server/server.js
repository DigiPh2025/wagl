const strapi = require('@strapi/strapi');

// @ts-ignore
strapi().start();

// const https = require('https');
// const Greenlock = require('greenlock-express');
// const fs = require('fs');
// const strapi = require('@strapi/strapi');

// // @ts-ignore
// const greenlock = Greenlock.create({
//     server: 'https://acme-v02.api.letsencrypt.org/directory',
//     email: 'pragati@yopmail.com',  // Replace with your email address
//     agreeTos: true,
//     approveDomains: ['api.wagl.io'],  // Replace with your domain(s)
//     configDir: '~/.config/acme/',
//     communityMember: true,
//     version: 'draft-11',
//     store: require('greenlock-store-fs')
// });

// // @ts-ignore
// strapi()
//     .start()
//     .then(async (strapiInstance) => {
//         // HTTPS server setup with Greenlock
//         https.createServer(greenlock.tlsOptions, greenlock.middleware(strapiInstance.app)).listen(443);
//     })
//     .catch((err) => {
//         console.error('Error starting Strapi:', err);
//         process.exit(1);
//     });

// const strapi = require('@strapi/strapi');
// const greenlock = require('./greenlock.config'); // Assuming greenlock.config.js is in the same directory

// async function runServer() {
//   // @ts-ignore
//   await strapi().load(); // Load Strapi
//   // @ts-ignore
//   await strapi().start(); // Start Strapi

//   // @ts-ignore
//   const server = strapi.server; // Get access to the Strapi server instance

//   // Replace with your actual domain name
//   const domain = 'api.wagl.io';

//   try {
//     await greenlock.check({ domains: [domain] }); // Check if SSL certificate needs renewal
//   } catch (err) {
//     console.error('Greenlock check error:', err);
//     return;
//   }

//   const tlsOptions = await greenlock.tlsOptions({
//     domains: [domain],
//     email: 'shritejipte@gmail.com',
//     communityMember: false,
//     agreeTos: true,
//     rsaKeySize: 2048,
//     challengeType: 'http-01',
//     challengeDir: `${__dirname}/.well-known/acme-challenge`,
//     webrootPath: `${__dirname}/public`,
//     renewWithin: 90 * 24 * 60 * 60 * 1000,
//     renewBy: 89 * 24 * 60 * 60 * 1000
//   });

//   server.tlsOptions = tlsOptions; // Set TLS options for Strapi server

//   // @ts-ignore
//   await strapi().start(); // Restart Strapi with TLS options enabled
// }

// runServer();

// const https = require('https');

// const app = require('./app');  // Import your Express app

// const Greenlock = require('greenlock-express');

 

// // Setup Greenlock

// // @ts-ignore
// const greenlock = Greenlock.create({

//     server: 'https://acme-v02.api.letsencrypt.org/directory',

//     email: 'shritejipte@gmail.com',  // Your email address for Let's Encrypt notifications

//     agreeTos: true,                   // You need to agree to the Let's Encrypt TOS

//     approveDomains: ['api.wagl.io'],  // Your domain(s) for SSL

//     configDir: '~/.config/acme/',     // Directory to store certificates and configs

//     communityMember: true,            // Option to become a community member

//     version: 'draft-11',              // ACME protocol version

//     store: require('greenlock-store-fs') // File store for certificates

// });

 

// // HTTPS server setup with Greenlock

// greenlock.listen(80, 443);

// greenlock.serveApp(app);