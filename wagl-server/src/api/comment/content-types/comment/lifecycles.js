module.exports = {
    
    async afterCreate(event) {
      
try {
  const { result, params } = event;
const  {id} = result;
  const {wagl_id,user_id} = params.data;

const waglIDs = wagl_id.connect[0].id
const userID = user_id.connect[0].id

 
    let totalCommentsCount = await strapi
    .query("api::wagl.wagl")    
    .findOne({where: { id: waglIDs }});

 
  const updateCount = await strapi.query('api::wagl.wagl').update({
    where:{id:waglIDs},
    data:{ 
      total_comments: totalCommentsCount.total_comments + 1 
    }
}).then(res=>{
    // ctx.response.status = 200
    
})
 // Publish the entry
 await strapi.query('api::comment.comment').update({
  where: { id: id},
  data: {
    publishedAt: new Date(), // Publish the entry
  },
});


//Get User Details 
// const users = await strapi
// .query("plugin::users-permissions.user")    
// .findOne({where: { id: userID }});
const waglData = await strapi.query('api::wagl.wagl').findOne({
  where:{id:waglIDs},
  populate: {
    user_id: true, // Populate user_id         
  },
})
if (waglData && waglData.user_id.fcm) {
  if(waglData.user_id.pushNotification && (waglData.user_id.id!=userID))
    {
      // Send notification
      // @ts-ignore
      await strapi.notification.sendNotification(waglData.user_id.fcm, {
        notification: {
          title: `Comment on a Wagl`, // Adjust as necessary
          body: ` There is a new comment on your Wagl`,
        },
      });
    }
}
//Add Data to notification Table

const notificationDetails = {
"title":"Comment on a Wagl",
// @ts-ignore
"description":`There is a new comment on your Wagl`,
"user_id":waglData.user_id.id,
"type":"Comment on Wagl",
"wagl_id":waglIDs,
"sender_id":userID,
publishedAt: new Date(),

}

if((waglData.user_id.id!=userID))
  {
  await strapi.entityService.create('api::notification.notification', {
       // @ts-ignore
       data: notificationDetails ,
    });
  }


    const user = await strapi.entityService.findOne(
      'plugin::users-permissions.user',
      userID 
    );

    const mailData={
      firstName:waglData.user_id.firstName,
      lastName:waglData.user_id.lastName,
      to:waglData.user_id.email,
      // to:"tp997511xyz99abc@gmail.com",
      wagl:waglData.description,
      commentByUser: `${user.firstName} ${user.lastName}`,
      subject:"Wagl : Wagl Comment",
      from:"suraj@appcartsystems.com",
      template:'wagl-comment-template.html'
  };

if(waglData.user_id.emailNotification && (waglData.user_id.id!=userID))
{
  const sendMailResponse = await strapi.service("api::wagl.mail").sendMail(mailData);
}

} catch (error) {
}
    

 
 

    },
    async beforeDelete(event) {
      const { result, params } = event;
// Check if params.data is defined
if (!params.data) {
  return; // or handle it accordingly
}
      const {wagl_id} = params.data;

      //Get User Details 
        let totalCommentsCount = await strapi
        .query("api::wagl.wagl")    
        .findOne({where: { id: wagl_id }});

    // Add Following to user profile
      await strapi.query('api::wagl.wagl').update({
        where:{id:wagl_id},
        data:{ 
          total_comments: totalCommentsCount.total_comments - 1 
        }
    }).then(res=>{
        // ctx.response.status = 200
    })
    },
  }