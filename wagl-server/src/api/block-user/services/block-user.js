'use strict';

/**
 * block-user service
 */

const { createCoreService } = require('@strapi/strapi').factories;

module.exports = createCoreService('api::block-user.block-user');
