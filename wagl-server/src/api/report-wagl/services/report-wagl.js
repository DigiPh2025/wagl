'use strict';

/**
 * report-wagl service
 */

const { createCoreService } = require('@strapi/strapi').factories;

module.exports = createCoreService('api::report-wagl.report-wagl');
