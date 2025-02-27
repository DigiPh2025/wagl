const Koa = require('koa');
const greenlock = require('greenlock-express');

const app = new Koa();

const greenlockConfig = {
  server: 'https://acme-v02.api.letsencrypt.org/directory',
  email: 'shritejipte@gmail.com',  // Replace with your email address
  agreeTos: true,
  approveDomains: ['api.wagl.io'],  // Replace with your domain(s)
  configDir: '~/.config/acme/',  // Directory to store certificates and configs
  communityMember: true,
  version: 'draft-11',
  // @ts-ignore
  store: require('greenlock-store-fs'),  // File store for certificates
};

// @ts-ignore
greenlock.init(greenlockConfig).serve(app);
