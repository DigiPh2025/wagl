'use strict';

/**
 * follower-list service
 */

const { createCoreService } = require('@strapi/strapi').factories;

module.exports = createCoreService('api::follower-list.follower-list');
