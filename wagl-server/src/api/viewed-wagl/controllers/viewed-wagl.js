'use strict';

/**
 * viewed-wagl controller
 */

const { createCoreController } = require('@strapi/strapi').factories;


module.exports = createCoreController('api::viewed-wagl.viewed-wagl',({strapi})=>({
      //Custom Api
      async savedViewedWagls(ctx){
        try {
        const { id } = ctx.state.user;       
        // @ts-ignore
        const { data } = ctx.request.body;     
       
       
  
// Fetch the existing record from the database
const getViewWagls = await strapi.query('api::viewed-wagl.viewed-wagl').findOne({ where: { user_id: id } });


// Check if getViewWagls and waglIDS exist
if (getViewWagls && getViewWagls.waglIDS) {
   
    // Parse the string into an array
    let parsedData;
    try {
        parsedData = JSON.parse(getViewWagls.waglIDS);
    } catch (error) {
        console.error("Error parsing waglIDS:", error);
        parsedData = []; // Default to empty array if parsing fails
    }

    // Ensure data.wagl_id is an array
    const waglIdsToAdd = Array.isArray(data.wagl_id) ? data.wagl_id : [];

    // Combine the arrays using the spread operator
    const result = [...parsedData, ...waglIdsToAdd];
   
    const uniqueArray = [...new Set(result)];
    // If you need to save the result back to the database, you can do that here
    await strapi.query('api::viewed-wagl.viewed-wagl').update({ where: { id: getViewWagls.id }, data: { waglIDS: JSON.stringify(uniqueArray),publishedAt: new Date() } });
} else {
   
}
        
      
       return {
            "data": {
              "status": true,
              "message": "Wagl Update Successfully",
            },
            
          }
        } catch (err) {
               
                throw err;
        }
       },
}))