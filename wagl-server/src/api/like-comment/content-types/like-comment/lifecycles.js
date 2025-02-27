module.exports = {
    
    async afterCreate(event) {

      const { result, params } = event;

      const {comment_id,wagl_id} = params.data;

      //Get User Details 
        let totalLikesCount = await strapi
        .query("api::comment.comment")    
        .findOne({where: { id: comment_id }});

    // Add Following to user profile
      await strapi.query('api::comment.comment').update({
        where:{id:comment_id},
        data:{ 
          total_comment_likes: totalLikesCount.total_comment_likes + 1 
        }
    }).then(res=>{
    })

    

    const getUserId = await strapi.query("api::wagl.wagl").findOne({
      where: { id: wagl_id },
      populate: { user_id: true }, // Adjust this field name if necessary
    });
      // Check if user_id exists
      if (getUserId && getUserId.user_id) {
        const userId = getUserId.user_id.id;
        const fcm = getUserId.user_id.fcm;
      
        if (fcm) {
          // Send notification
          // @ts-ignore
          await strapi.notification.sendNotification(fcm, {
            notification: {
              title: `Like your Comment`, 
              body: `Like your Comment!`,
            },
          });
         
        }
      } else {
      }

    },
    async beforeDelete(event) {
      
      const { result, params } = event;

      // Check if params.data is defined
      if (!params.data) {
        return; // or handle it accordingly
      }
      const {comment_id} = params.data;
      //Get User Details 
        let totalLikesCount = await strapi
        .query("api::comment.comment")    
        .findOne({where: { id: comment_id }});

    // Add Following to user profile
      await strapi.query('api::comment.comment').update({
        where:{id:comment_id},
        data:{ 
          total_comment_likes: totalLikesCount.total_comment_likes - 1 
        }
    }).then(res=>{
    })
 
    },
  }