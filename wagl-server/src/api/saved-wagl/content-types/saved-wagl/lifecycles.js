module.exports = {
    
    async afterCreate(event) {

      const { result, params } = event;

      const {wagl_id} = params.data;

      //Get User Details 
        let totalSavedCounts = await strapi
        .query("api::wagl.wagl")    
        .findOne({where: { id: wagl_id }});

    // Add Following to user profile
      await strapi.query('api::wagl.wagl').update({
        where:{id:wagl_id},
        data:{ 
          total_saved: totalSavedCounts.total_saved + 1 
        }
    }).then(res=>{
       
    })

 
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

 
    },
  }