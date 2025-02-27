module.exports = {

   // Before creating a new entry
   async beforeCreate(event) {
    const { result, params } = event;
    const {userID,followersID} = params.data;

    

    const existing = await strapi.db.query('api::follower-list.follower-list').findOne({
      where: {
        userID: userID,
        followersID: followersID,
      },
    });

    // If the combination exists, throw an error
    if (existing) {
      const error = new Error('User already followed.');
      // @ts-ignore
      error.status = 400; // Set HTTP status code
      throw error;
    }
  },
    
    async afterCreate(event) {

      const { result, params } = event;

      const {userID,followersID} = params.data;

      //Get User Details 
        let userData = await strapi
        .query("plugin::users-permissions.user")    
        .findOne({where: { id: userID }});

    // Add Following to user profile
      await strapi.query('plugin::users-permissions.user').update({
        where:{id:userID},
        data:{ 
            totalFollowing: userData.totalFollowing + 1 
        }
    }).then(res=>{
        // ctx.response.status = 200
        
    })

    //Get Follower Details 
    let followerData = await strapi
    .query("plugin::users-permissions.user")    
    .findOne({where: { id: followersID }});

    // Add Follower to Follows user profile
      await strapi.query('plugin::users-permissions.user').update({
        where:{id:followersID},
        data:{ 
            totalFollowers: followerData.totalFollowers + 1 
        }
    }).then(res=>{
        // ctx.response.status = 200
       
    })

    const today = new Date();
    const startOfDay = new Date(today.setHours(0, 0, 0, 0)); // Start of today
    const endOfDay = new Date(today.setHours(23, 59, 59, 999)); // End of today

    let todaysameNotify = await strapi
                  .query("api::notification.notification")    
                  .findOne({where: { 
                    title:"Follow User",
                    user_id:followersID,
                    sender_id:userID,
                    createdAt: {
                      $gte: startOfDay,
                      $lte: endOfDay,
                    }
                  }});

    
    // const user = await strapi.entityService.findOne(
    //   'plugin::users-permissions.user',
    //   followersID 
    // );
    if (followerData && followerData.fcm) {

      if(followerData.pushNotification && (followerData.id!=userID && !todaysameNotify))
      {
        // Send notification
        // @ts-ignore
        await strapi.notification.sendNotification(followerData.fcm, {
          notification: {
            title: `Follow User`, // Adjust as necessary
            body: ` ${userData.username} is started following you`,
          },
        });
        
      }

    }
  //Add Data to notification Table

  const notificationDetails = {
    "title":"Follow User",
    // @ts-ignore
    "description":`${userData.username} is started following you`,
    "user_id":followersID,
    "type":"Follow User",
    "sender_id":userID,
    // "wagl_id":wagl_id,
    publishedAt: new Date(),
  
  }

  if(!todaysameNotify)
  {
    await strapi.entityService.create('api::notification.notification', {
         // @ts-ignore
         data: notificationDetails ,
      });
  }
    
    //   strapi.entityService.create('api::follower-list.follower-list', {    
    //      // @ts-ignore
    //      data: {
    //         // contentType: 'Article',
    //         // action:'New Content Entry',
    //         // content:result.Content,
    //         // author:result.createdBy,
    //         // params:params,
    //         // request:event,   
    //     },
    //   });

    const mailData={
      firstName:followerData.firstName,
      lastName:followerData.lastName,
      // to:"tp997511xyz99abc@gmail.com",
      to:followerData.email,
      followerName: `${userData.firstName} ${userData.lastName}`,
      subject:"Wagl : Follower Alert",
      from:"suraj@appcartsystems.com",
      template:'follow-template.html'
  };

    if(followerData.emailNotification && !todaysameNotify)
    {
        const sendMailResponse = await strapi.service("api::wagl.mail").sendMail(mailData);
    }

    },
    async beforeDelete(event) {

      const { result, params } = event;


 
    },
  }