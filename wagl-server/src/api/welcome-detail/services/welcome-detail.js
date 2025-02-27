'use strict';

/**
 * welcome-detail service
 */

const { createCoreService } = require('@strapi/strapi').factories;

module.exports = createCoreService('api::welcome-detail.welcome-detail');
