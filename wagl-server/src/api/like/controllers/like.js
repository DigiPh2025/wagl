'use strict';

/**
 * like controller
 */

// @ts-ignore
const { createCoreController } = require('@strapi/strapi').factories;

 
module.exports = createCoreController('api::like.like',({strapi})=>({
   
    //Custom Api
     async unLike(ctx){
         try {
         const { id } = ctx.state.user;       
         // @ts-ignore
         const { data } = ctx.request.body; 
         const userID = data.user_id;
      const waglID = data.wagl_id;
        
       //Get Wagl Details 
    //    let waglData = await strapi.query("api::wagl.wagl").findOne({where: { id: waglID }}); 
    const waglData = await strapi.db.query('api::wagl.wagl').findOne({
        where: { id: waglID }, // Ensure 'id' is correct in your schema
      });
       if (!waglData) { return ctx.badRequest('Wagl not found'); }

         // Remove Like data from table
         let deletedRecord = await strapi.query('api::like.like').delete({
             where:{wagl_id:waglID,user_id:userID}          
             })     
    // Check if any records were deleted

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
                    total_likes: waglData.total_likes - 1 
                    }
                }).then(res=>{
            // ctx.response.status = 200
                })
                return ctx.send({
                    status: true,
                    message: 'Un-like Success',
                    });
            } else {
                return ctx.send({
                    status: false,
                    message: 'No like found to remove',
                    });
            }
        
 
         } catch (err) {
                 // if (err instanceof SomeCustomError) {
                 //     return ctx.send(err.body, err.status);
                 // }
                 return ctx.internalServerError('An error occurred');
         }
        },

     async getLikeWagls(ctx){
         try {
         const { id } = ctx.state.user; 
       //Get Wagl Details  
        const waglData = await strapi.db.query('api::like.like').findMany({
                                where: { user_id: id }, // Ensure 'id' is correct in your schema
                                populate: ['wagl_id'],
                            })
        
        if (!waglData) { return ctx.badRequest('Wagl not found'); }
        // Extract IDs from waglData
        const resultIds = waglData.map(item => item.wagl_id.id);
        // let uniqueData = Object.entries(
        //     waglData.reduce((acc, [key, value]) => {
        //         acc[key] = value.wagl_id.id;
        //         return acc;
        //     }, {})
        // )
        return ctx.send({
                status: resultIds.length==0?false: true,
                result: [...new Set(resultIds)],
                message: 'Liked wagls',
            });
        
 
         } catch (err) {
                 // if (err instanceof SomeCustomError) {
                 //     return ctx.send(err.body, err.status);
                 // }
                 return ctx.internalServerError('An error occurred');
         }
        }
    }));
