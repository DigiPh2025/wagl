'use strict';

/**
 * report-message service
 */

const { createCoreService } = require('@strapi/strapi').factories;

module.exports = createCoreService('api::report-message.report-message');
