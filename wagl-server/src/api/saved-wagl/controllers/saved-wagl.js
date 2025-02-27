'use strict';

/**
 * saved-wagl controller
 */

const { createCoreController } = require('@strapi/strapi').factories;

module.exports = createCoreController('api::saved-wagl.saved-wagl',({strapi})=>({
   
    //Custom Api
     async removedSaved(ctx){
         try {
         const { id } = ctx.state.user;       
         // @ts-ignore
         const { data } = ctx.request.body; 
         const userID = data.user_id;
         const waglID = data.wagl_id;
        
         
        
       //Get Wagl Details 
    
        const waglData = await strapi.db.query('api::wagl.wagl').findOne({
                                where: { id: waglID }, // Ensure 'id' is correct in your schema
                            });
       
       if (!waglData) { return ctx.badRequest('Wagl not found'); }

         // Remove Like data from table
         let deletedRecord = await strapi.query('api::saved-wagl.saved-wagl').delete({
             where:{wagl_id:waglID,user_id:userID}          
             })
       

    // Determine the count of deleted records from the result
    let deletedCount = 0;
    if (Array.isArray(deletedRecord)) {
      deletedCount = deletedRecord.length;
    } else if (deletedRecord && typeof deletedRecord === 'object') {
      // Handle other possible structures
      deletedCount = deletedRecord.count || deletedRecord.deleted || 0; // Adjust based on your result structure
    }   
   
    // @ts-ignore
        if (deletedRecord) {
            // decrement total Count
            await strapi.query('api::wagl.wagl').update({
                where:{id:waglID},
                data:{ 
                    total_saved: waglData.total_saved - 1 
                    }
                }).then(res=>{
            
                })
                return ctx.send({
                    status: true,
                    message: 'Saved Wagl Removed Successfully',
                    });
            } else {
                return ctx.send({
                    status: false,
                    message: 'No Saved Wagl found to remove',
                    });
            }
        
 
         } catch (err) {
                
                 return ctx.internalServerError('An error occurred');
         }
        },

     async getSavedWagls(ctx){
         try {
         const { id } = ctx.state.user; 
         
       //Get Wagl Details  
        const waglData = await strapi.db.query('api::saved-wagl.saved-wagl').findMany({
                                where: { user_id: id }, // Ensure 'id' is correct in your schema
                                populate: ['wagl_id'],
                            })
        
        if (!waglData) { return ctx.badRequest('Wagl not found'); }
        // Extract IDs from waglData
        
        const resultIds = waglData.map(item => item.wagl_id.id);
        
        return ctx.send({
                status: resultIds.length==0?false: true,
                result: [...new Set(resultIds)],
                message: 'List of Saved wagls',
            });
        
 
         } catch (err) {
                
                 return ctx.internalServerError('An error occurred');
         }
        }
    
    }));
