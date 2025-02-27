'use strict';

/**
 * notification controller
 */

const { createCoreController } = require('@strapi/strapi').factories;

// module.exports = createCoreController('api::notification.notification');

module.exports = createCoreController('api::notification.notification',({strapi})=>({
   
    //Custom Api
     async getNotificationList(ctx){
         try {
         const { id } = ctx.state.user;       
         // @ts-ignore
         const { data } = ctx.request.body;     
         const page = data.skip; // Example page number
        const pageSize = data.limit; // Number of records per page
        const start = (page - 1) * pageSize; // Calculate skip value

        
            const totalNotificationCount = await strapi.entityService.count("api::notification.notification", {
                filters: {
                // @ts-ignore
                user_id: id
                }
            });

               // get followers list
        const usersFollowersList = await strapi.entityService.findMany("api::follower-list.follower-list", {
            filters: {
              userID: id,
              // @ts-ignore
              followersID: { $ne: null } // Ensure followersID is not null
            },
            populate: {
              followersID: { fields: ['id'] } // Only retrieve the follower ID
            }
          });
          
          // Extract only the follower IDs
          // @ts-ignore
          const followersIds = usersFollowersList.map(follower => follower.followersID.id);

         const notificationList = await strapi.entityService.findMany("api::notification.notification", {
            filters: {
              // @ts-ignore
              user_id: id,
              sender_id: {
                $notNull: true,
              }             
            },
            populate: {
                // @ts-ignore
                // fields: ['id', 'name'],
              sender_id:{
                populate: {
                  profilePic: true, 
                },
              },
              wagl_id:{
                populate: {
                    media: true,  
                    thumbnail: true,  
                    interested_categories:true,
                    good_tags:{
                        populate: {
                          image:true,
                          media: true,
                        }
                      },
                    product_id:{
                      populate: {
                        product_pic:true,
                          media: true,
                          brand_id:true
                      } }
                      // Limit to the first index
                // @ts-ignore
                // pagination: {
                //     page: 1,
                //     pageSize: 1, // Only return one media/thumbnail
                // },
                },
              },              
              
            },  // @ts-ignore
            sort: { createdAt: 'DESC' },
            start, // Skip the first 'start' records
            limit: pageSize, // Limit the number of records returned
          });
//  // Prepare pagination meta
//  const meta = {
//     pagination: {
//       page: 1, // Assuming single page for this example
//       pageSize: notificationList.length,
//       pageCount: 1,
//       total: totalNotificationCount
//     }
//   }

   // Set isFollow flag for each notification
   // @ts-ignore
   const notificationListWithFollowFlag = notificationList.map(notification => {
    if(notification.sender_id!=null && notification.sender_id!='')
    {
        // @ts-ignore
        const senderId = notification.sender_id.id; // Assuming sender_id has an id field
        return {
            ...notification,
            isFollow: followersIds.includes(senderId) // Check if the sender is followed
        };
    }
   
});

// Map through the notifications to get only the first populated entry
const filteredNotificationList = notificationList.map(notification => {
  if(notification.sender_id!=null && notification.sender_id!='')
  {  
    // @ts-ignore
    const senderId = notification.sender_id.id; // Assuming sender_id has an id field
    return {
        ...notification,
        // @ts-ignore
        sender_id: notification.sender_id ? {
            // @ts-ignore
            ...notification.sender_id,
            // @ts-ignore
            profilePic: notification.sender_id.profilePic ? notification.sender_id.profilePic : null // Take only the first profilePic
        } : null,
        // @ts-ignore
        wagl_id: notification.wagl_id ? {
            // @ts-ignore
            ...notification.wagl_id,
            // @ts-ignore
            media: notification.wagl_id.media ? [notification.wagl_id.media[0]] : [], // Take only the first media
            // @ts-ignore
            thumbnail: notification.wagl_id.thumbnail ? [notification.wagl_id.thumbnail] : [] // Take only the first thumbnail
        } : null,
        isFollow: followersIds.includes(senderId) // Check if the sender is followed
    };
  }
});

 // Prepare pagination meta
 const meta = {
    pagination: {
        page: page, // Current page
        pageSize: filteredNotificationList.length,
        pageCount: Math.ceil(totalNotificationCount / pageSize), // Calculate total pages
        total: totalNotificationCount
    }
}
        return {
             "data": {
               "status": true,
               "message": "Notification List",
               "list":filteredNotificationList,
               meta:meta
             },
             
           }
         } catch (err) {
                
                 throw err;
         }
        },
    }));