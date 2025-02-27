'use strict';

/**
 * wagl router
 */

// @ts-ignore
const { createCoreRouter } = require('@strapi/strapi').factories;

module.exports = createCoreRouter('api::wagl.wagl');
