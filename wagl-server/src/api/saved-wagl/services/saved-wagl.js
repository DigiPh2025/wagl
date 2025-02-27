'use strict';

/**
 * saved-wagl service
 */

const { createCoreService } = require('@strapi/strapi').factories;

module.exports = createCoreService('api::saved-wagl.saved-wagl');
