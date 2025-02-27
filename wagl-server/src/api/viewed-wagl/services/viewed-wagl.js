'use strict';

/**
 * viewed-wagl service
 */

const { createCoreService } = require('@strapi/strapi').factories;

module.exports = createCoreService('api::viewed-wagl.viewed-wagl');
