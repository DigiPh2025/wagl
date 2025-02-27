'use strict';

/**
 * report-user service
 */

const { createCoreService } = require('@strapi/strapi').factories;

module.exports = createCoreService('api::report-user.report-user');
