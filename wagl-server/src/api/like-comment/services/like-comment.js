'use strict';

/**
 * like-comment service
 */

const { createCoreService } = require('@strapi/strapi').factories;

module.exports = createCoreService('api::like-comment.like-comment');
