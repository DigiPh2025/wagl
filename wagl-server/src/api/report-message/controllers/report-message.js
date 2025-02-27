'use strict';

/**
 * report-message controller
 */

const { createCoreController } = require('@strapi/strapi').factories;

// module.exports = createCoreController('api::report-message.report-message');

module.exports = createCoreController('api::report-message.report-message',({strapi})=>({
   
    //Custom Api
     async getReportData(ctx){
         try {
         const { id } = ctx.state.user;       
         // @ts-ignore
        const reportMessage = await strapi.db.query('api::report-message.report-message').findMany()
        const reportType = await strapi.db.query('api::reason.reason').findMany()
        return ctx.send({
            status:  true,
            reportMessage:reportMessage ,
            reportType:reportType ,
            message: 'List of Saved wagls',
        });
   
         } catch (err) {
                
                 throw err;
         }
        },
    }));