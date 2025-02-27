'use strict';

/**
 * follower-list controller
 */
const { sanitizeEntity } = require("strapi-utils/lib");
// @ts-ignore
const { createCoreController } = require('@strapi/strapi').factories;

module.exports = createCoreController('api::follower-list.follower-list',({strapi})=>({
   
   //Custom Api
    async unFollow(ctx){
        try {
        const { id } = ctx.state.user;       
        // @ts-ignore
        const { data } = ctx.request.body;     
        const userID = data.userID;
        const followersID = data.followersID;
        
      //Get User Details 
      let userData = await strapi.query("plugin::users-permissions.user").findOne({where: { id: userID }});

        // Remove Following to user profile
        await strapi.query('plugin::users-permissions.user').update({
            where:{id:userID},
            data:{ 
                    totalFollowing: userData.totalFollowing - 1 
                }
            }).then(res=>{
            // ctx.response.status = 200
            })

        //Get Follower Details 
        let followerData = await strapi.query("plugin::users-permissions.user").findOne({where: { id: followersID }});

        // Remove Follower to Follows user profile
        await strapi.query('plugin::users-permissions.user').update({
            where:{id:followersID},
            data:{ 
                    totalFollowers: followerData.totalFollowers - 1 
                }
            }).then(res=>{
      // ctx.response.status = 200
             })

            // @ts-ignore
        let deletedRecordsCount=  await strapi.query('api::follower-list.follower-list').delete({
                where:{followersID:followersID,userID:userID}    
                }).then(res=>{
                    // ctx.response.status = 200
                })

        // return {"message":"User un-Follow Success"}

       return {
            "data": {
              "status": true,
              "message": "User un-follow Success",
            },
            
          }
        } catch (err) {
                // if (err instanceof SomeCustomError) {
                //     return ctx.send(err.body, err.status);
                // }
                throw err;
        }
       },

    async getFollowersList(ctx){
      try {
      const { id } = ctx.state.user;       
    //Get Wagl Details  
      const followers = await strapi.db.query('api::follower-list.follower-list').findMany({
          where: { userID: id }, // Ensure 'id' is correct in your schema
          populate: ['followersID'],
      }) 
   
      if (!followers) { return ctx.badRequest('Followers not found'); }
      // Extract IDs from followers
      const resultIds = followers.map(item => item.followersID.id);
      // const followerIds = followers.map(entry => entry.followersID.id);
    return ctx.send({
          status: resultIds.length==0?false:true,
          result:resultIds,
          message: 'Followers List',
      });
      
      } catch (err) {
              // if (err instanceof SomeCustomError) {
              //     return ctx.send(err.body, err.status);
              // }
              return ctx.internalServerError('An error occurred');
      }
       }

   }));
