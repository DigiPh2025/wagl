'use strict';

/**
 * wagl service
 */

const { createCoreService } = require('@strapi/strapi').factories;

module.exports = createCoreService('api::wagl.wagl');
