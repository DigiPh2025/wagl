module.exports = {
    
    async afterCreate(event) {
      try {
      const { result, params } = event;

      const {wagl_id,user_id} = params.data;
     
      
      //Get User Details 
        let totalLikesCount = await strapi
        .query("api::wagl.wagl")    
        .findOne({where: { id: wagl_id }});

    // Add Following to user profile
     await strapi.query('api::wagl.wagl').update({
        where:{id:wagl_id},
        data:{ 
          total_likes: totalLikesCount.total_likes + 1 
        }
    }).then(res=>{
       
    })
     const waglData = await strapi.query('api::wagl.wagl').findOne({
        where:{id:wagl_id},
        populate: {
          user_id: true, // Populate user_id         
        },
    })
   
    // @ts-ignore
    // @ts-ignore
    if(waglData){
  // @ts-ignore
 
  const user = await strapi.entityService.findOne(
    'plugin::users-permissions.user',
    user_id 
  );

  const today = new Date();
    const startOfDay = new Date(today.setHours(0, 0, 0, 0)); // Start of today
    const endOfDay = new Date(today.setHours(23, 59, 59, 999)); // End of today

    let todaysameNotify = await strapi
                  .query("api::notification.notification")    
                  .findOne({where: { 
                    title:"liked your Wagl",
                    wagl_id:wagl_id,
                    sender_id:user.id,
                    createdAt: {
                      $gte: startOfDay,
                      $lte: endOfDay,
                    }
                  }});

  if (waglData && waglData.user_id.fcm) {

    if(waglData.user_id.pushNotification && (waglData.user_id.id!=user.id) && !todaysameNotify)
    {
      // Send notification
      // @ts-ignore
      await strapi.notification.sendNotification(waglData.user_id.fcm, {
        notification: {
          title: `Like on a Wagl`, // Adjust as necessary
          body: `Your post Wagl has been liked by ${user.username}`,
        },
      });
      
    }
  }

  //Add Data to notification Table
if(waglData.user_id.fcm!=user.fcm){

  const notificationDetails = {
    "title":"liked your Wagl",
    // @ts-ignore
    "description":`Your post Wagl has been liked by ${user.username}.`,
    "user_id":waglData.user_id.id,
    "type":"Like Wagl",
    "wagl_id":wagl_id,
    "sender_id":user.id,
    publishedAt: new Date(),    
  }
  
  if(!todaysameNotify)
  {
    await strapi.entityService.create('api::notification.notification', {
      // @ts-ignore
      data: notificationDetails ,
    });
  }

  const mailData={
                    firstName:waglData.user_id.firstName,
                    lastName:waglData.user_id.lastName,
                    to:waglData.user_id.email,
                    // to:"tp997511xyz99abc@gmail.com",
                    wagl:waglData.description,
                    likedByUser: `${user.firstName} ${user.lastName}`,
                    subject:"Wagl : Wagl Like",
                    from:"suraj@appcartsystems.com",
                    template:'wagl-like-template.html'
                };

   
    if(waglData.user_id.emailNotification && (waglData.user_id.id!=user.id) && !todaysameNotify)
    {
    const sendMailResponse = await strapi.service("api::wagl.mail").sendMail(mailData);
    }
  
}

    }
  } catch (error) {
    console.error("Error occurred in afterCreate:", error);
    // Handle error accordingly
  }
   

  



  //   var owner = await strapi.entityService.findOne(
  //     'plugin::users-permissions.user', user_id);
  // strapi.notification.sendNotification(owner.fcm, {
  //     notification: {
  //         title: ` liked your quote`,
  //         body: `test`
  //     }
  // });
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

    },
    async beforeDelete(event) {
      const { result, params } = event;

    //   const {wagl_id} = params.data;

    //   //Get User Details 
    //     let totalLikesCount = await strapi
    //     .query("api::wagl.wagl")    
    //     .findOne({where: { id: wagl_id }});

    // // Add Following to user profile
    //   await strapi.query('api::wagl.wagl').update({
    //     where:{id:wagl_id},
    //     data:{ 
    //       total_likes: totalLikesCount.total_likes - 1 
    //     }
    // }).then(res=>{
    //     // ctx.response.status = 200
    
    // })
 
    },
  }