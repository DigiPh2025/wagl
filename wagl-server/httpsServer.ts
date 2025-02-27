// httpsServer.js
// const { create } = require('greenlock-express');
const https = require('https');
// const Greenlock = require('greenlock-express');
const app = require('./app'); // Adjust the path to match your actual app.js file location

// Setup Greenlock

const greenlock = require('greenlock-express').create({
    server: 'https://acme-v02.api.letsencrypt.org/directory',
    email: 'shritejipte@gmail.com',  // Your email address for Let's Encrypt notifications
    agreeTos: true,                   // You need to agree to the Let's Encrypt TOS
    approveDomains: ['api.wagl.io'],  // Your domain(s) for SSL
    configDir: '~/.config/acme/',     // Directory to store certificates and configs
    communityMember: true,            // Option to become a community member
    version: 'draft-11',              // ACME protocol version
    store: require('greenlock-store-fs') // File store for certificates
});

// HTTPS server setup with Greenlock
greenlock.listen(443, 80); // HTTPS on port 443, HTTP challenge on port 80

// Obtain the Express app from Strapi
// const strapiApp = require('strapi')();

// Serve Strapi app with HTTPS
greenlock.serveApp(app);
 
 

// Create HTTPS server with increased timeouts
const server = https.createServer(greenlock.httpsOptions, app);

// Set timeout configurations
server.timeout = 1200000;         // 20 minutes request timeout
server.keepAliveTimeout = 1200000; // 20 minutes keep-alive timeout

// Start the HTTPS server manually
server.listen(443, () => {
    console.log("🚀 HTTPS Server is running on port 443 with increased timeout!");
});