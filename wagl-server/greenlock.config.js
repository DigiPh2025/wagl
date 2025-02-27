
// @ts-ignore
const { greenlock } = require('greenlock');

const config = {
  packageRoot: __dirname,
  configDir: './greenlock.d',
  maintainerEmail: 'shritejipte@gmail.com',
  cluster: false
};

const greenlockInstance = greenlock.init(config);

module.exports = greenlockInstance;
