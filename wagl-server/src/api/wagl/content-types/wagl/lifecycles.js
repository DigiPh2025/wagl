const jwt = require('jsonwebtoken');
module.exports = {
 
async beforeCount(event) {
  const { params } = event;

  // Add your condition
  params.where = {
    ...params.where,
    media: { $notNull: true }
  };
  
},

async beforeFindMany(event) { 
  
  const { params } = event;

  // Add your condition
  params.where = {
    ...params.where,
    media: { $notNull: true }
  };

},


async beforeCreate(event) {
  
  const { data, files } = event.params;
  const ctx = strapi.requestContext.get();
  const file = ctx.request.files;


  if(file!=undefined)
  {
    const mediaFiles = Array.isArray(file['files.media']) 
        ? file['files.media'] 
        : (file['files.media'] ? [file['files.media']] : []); // Ensure it's always an array

              
      // Check the count of media files  
      if (mediaFiles.length > 0) {
        // throw new Error('Only one media file is allowed.');
      } else {
        const error = new Error('File is required.');
        // @ts-ignore
        error.status = 400; // Set HTTP status code
        throw error;
      } 

  // @ts-ignore
  } else if(!data.media ?? true) {
    const error = new Error('File is required.');
    // @ts-ignore 
    error.status = 400; // Set HTTP status code
    throw error;
    // @ts-ignore
    // throw strapi.errors.badRequest('A file for the image field is required.');
  }
  

},

async afterCreate(event) {
  try {
    const { result } = event;
    const { id: waglID } = result; // Get the newly created wagl ID
   
    // Fetch the associated user ID from the wagl record
    const getUserId = await strapi.query("api::wagl.wagl").findOne({
      where: { id: waglID },
      populate: { 
         user_id: {
                  populate: {
                    recentCategories: true, // Adjust this field name if necessary
                  },
                },
       interested_categories: true,
       product_id:true
      } // Adjust this field name if necessary
      
    });

    

    // Check if user_id exists
    if (getUserId && getUserId.user_id) {

      
      const userId = getUserId.user_id.id;
      const interested_categories = getUserId.interested_categories;

     
      const recent_categories = getUserId.user_id.recentCategories;
     
// Create a Set to track unique IDs
const uniqueIds = new Set();

// Merge arrays while maintaining uniqueness
const mergedCategories = [
  ...interested_categories.filter(category => {
    if (!uniqueIds.has(category.id)) {
      uniqueIds.add(category.id);
      return true;
    }
    return false;
  }),
  ...recent_categories.filter(category => {
    if (!uniqueIds.has(category.id)) {
      uniqueIds.add(category.id);
      return true;
    }
    return false;
  })
];


      const updateIC = interested_categories.map(async ic =>{
        const totalWaglCount = await strapi.query("api::interested-category.interested-category").findOne({
          where: { id: ic.id },
        });
       
  // Update the totalWagls count
  const updateCount = await strapi.query("api::interested-category.interested-category").update({
    where: { id: ic.id },
    data: {
      totalWagls: (totalWaglCount.totalWagls|| 0) + 1, // Ensure it starts at 0 if undefined
    },
  });
      } );

      // Fetch the totalWagls count for the user
      const totalWaglCount = await strapi.query("plugin::users-permissions.user").findOne({
        where: { id: userId },
      });

     
      // Update the totalWagls count
      const updateCount = await strapi.query("plugin::users-permissions.user").update({
        where: { id: userId },
        data: {
          totalWagls: (totalWaglCount.totalWagls || 0) + 1, // Ensure it starts at 0 if undefined
          recentCategories:mergedCategories
        },
      });

    
if(getUserId.product_id){
  
      // Fetch the totalWagls count for the user
      const totalProductCount = await strapi.query("api::product.product").findOne({
        where: { id: getUserId.product_id.id },
      });

      const updateWaglCount = await strapi.query("api::product.product").update({
        where: { id: getUserId.product_id.id },
        data: {
          wagl_count: (totalProductCount.wagl_count || 0) + 1, // Ensure it starts at 0 if undefined
          
        },
      });
     
    }
    } else {
     
    }
  } catch (error) {
    
  }
},

 

  async beforeUpdate(event) { 
   
    // Get the newly created wagl ID
    const { result,params } = event; // Get the params directly from the event
   
    // return true;
    if(params.data.product_id && typeof params.data.product_id === 'object')
    {
      
      const connectArr =params.data.product_id.connect.length>0 ? params.data.product_id.connect[0].id : null;
      const disconnectArr=params.data.product_id.disconnect.length>0 ? params.data.product_id.disconnect[0].id : null;
      params.data.product_id=connectArr;
      if(connectArr==null && disconnectArr==null)
      {
        return true;
      }

     
      
    } else {
      
    }

   
    
    if(params.data.good_tags??false)
    {
      
    // Fetch the associated user ID from the wagl record
    const getUserId = await strapi.query("api::wagl.wagl").findOne({
      where: { id: params.where.id },
      populate: { 
         user_id: {
                  populate: {
                    recentCategories: true, // Adjust this field name if necessary
                  }, 
                },
       interested_categories: true,
       product_id:true 
      } // Adjust this field name if necessary
      
    });

   

        if(params.data.product_id??null)
        {
          
        }
           

          if(getUserId.product_id ?? false)
          {
            if(params.data.product_id!=getUserId.product_id.id)
              {
                // Decrease Product Count
                  const totalProductCount = await strapi.query("api::product.product").findOne({
                    where: { id: getUserId.product_id.id },  // previous productid
                  });
          
                  const updateWaglCount = await strapi.query("api::product.product").update({
                    where: { id: getUserId.product_id.id },
                    data: {
                      wagl_count: totalProductCount.wagl_count > 0 ? totalProductCount.wagl_count - 1 : 0, // Ensure it starts at 0 if undefined
                      
                    },
                  });

                  
               }
          }
           
          if(params.data.product_id ?? false) 
          {
            const proId=getUserId.product_id ? getUserId.product_id.id : null;
            if(params.data.product_id!=proId)
              {
                // Increase Product Count 
                const totalProductCount1 = await strapi.query("api::product.product").findOne({
                  where: { id: params.data.product_id },
                });

               
        
                const updateWaglCount1 = await strapi.query("api::product.product").update({
                  where: { id: params.data.product_id },
                  data: {
                    wagl_count: totalProductCount1.wagl_count + 1, // Ensure it starts at 0 if undefined                    
                  },
                });
              }
          }
        }

    
         
    
  },
  
  async afterUpdate(event) { 

    const { result,params } = event; // Get the params directly from the event
   
  
    if (Array.isArray(params.data.mediaIds) && params.data.mediaIds.length > 0) {
    const updateIC = params.data.mediaIds.map(async mediaId =>{          
      
      const resp =await strapi.plugins['upload'].services.upload.remove({ id: mediaId }); 

    } );
  } 

    
  },

  async beforeDelete(event) {
      try {
        const { result ,params } = event; // Get the params directly from the event
    const waglID = params.where.id; // Extract the wagl ID from params

    const waglData = await strapi.query("api::wagl.wagl").findOne({
      where: { id: waglID },
      populate: { user_id: true, interested_categories: true ,product_id:true }, // Adjust this field name if necessary
    });


    const userData = await strapi.query("plugin::users-permissions.user").findOne({
      where: { id: waglData.user_id.id }, // Adjust this field name if necessary
      populate: { user_id: true, recentCategories : true }
    });

    async function generateCategories(userData, waglData) {

      const categories = new Set(); // Initialize a Set to store unique values
    
      // Use a for...of loop to await asynchronous operations correctly
      for (const category of userData.recentCategories) {
        const checkWagl = await strapi.query("api::wagl.wagl").findOne({
          where: {
            user_id: waglData.user_id.id,
            id: {
              $ne: waglID, // Ensure the specific country ID is not equal (not included)
            },
            interested_categories: {
              id: category.id, // Assuming cities is a relation and we're checking by city ID
            },
          },
          populate: {
            id:true,
            user_id: true,
            interested_categories: true,
            product_id: true, // Adjust this field name if necessary
          },
        });
    
       
    
        if (checkWagl) {
          categories.add(category.id); // If the check is true, add 20
        } else {
           // If the check is false, add 10 (was previously adding 20)
        }
      }
    
      return Array.from(categories); // Convert Set to an Array before returning
    }

    const generatedCategories = await generateCategories(userData, waglData);
  
    
    
  await strapi.query('plugin::users-permissions.user').update({
    where: { id : waglData.user_id.id },
    data: {
      recentCategories : generatedCategories                       
    },
    });

    // ***************************************************************************************


    
        // Fetch the associated user ID from the wagl record
        const getUserId = await strapi.query("api::wagl.wagl").findOne({
          where: { id: waglID },
          populate: { user_id: true, interested_categories: true ,product_id:true }, // Adjust this field name if necessary
        });
    
          
        // Check if user_id exists
        if (getUserId && getUserId.user_id) {
          const userId = getUserId.user_id.id;
          const interested_categories = getUserId.interested_categories;
          
          const updateIC = interested_categories.map(async ic =>{
            const totalWaglCount = await strapi.query("api::interested-category.interested-category").findOne({
              where: { id: ic.id },
            });
                       
          //   const removeLikeWagls = await strapi.db.query("api::like.like").deleteMany({
          //     where: {
          //         wagl_id: { $in: waglID },
          //     },
          // });

          let removeLikeWagls=  await strapi.query('api::like.like').delete({
            where:{wagl_id:waglID}    
            }).then(res=>{
               
            })
           
            // likeComment
            const removelikeComment = await strapi.query("api::like-comment.like-comment").delete({
              where:{wagl_id:waglID}
            });
            
           
            
            const removeComment = await strapi.query("api::comment.comment").delete({
              where:{wagl_id:waglID}
            });
           
            const removeSavedWagl = await strapi.query("api::saved-wagl.saved-wagl").delete({
              where:{wagl_id:waglID}
            });
           

      // Update the totalWagls count
      const updateCount = await strapi.query("api::interested-category.interested-category").update({
        where: { id: ic.id },
        data: {
          totalWagls: (totalWaglCount.totalWagls|| 0) - 1, // Ensure it starts at 0 if undefined
        },
      });
          } );
          // Fetch the totalWagls count for the user
          const totalWaglCount = await strapi.query("plugin::users-permissions.user").findOne({
            where: { id: userId },
          });
    
          
          // Update the totalWagls count
          const updateCount = await strapi.query("plugin::users-permissions.user").update({
            where: { id: userId },
            data: {
              totalWagls: (totalWaglCount.totalWagls || 0) - 1, // Ensure it starts at 0 if undefined
            },
          });
    
      

                // Fetch the totalWagls count for the user
      const totalProductCount = await strapi.query("api::product.product").findOne({
        where: { id: getUserId.product_id.id },
      });

      const updateWaglCount = await strapi.query("api::product.product").update({
        where: { id: getUserId.product_id.id },
        data: {
          wagl_count: (totalProductCount.wagl_count || 0) - 1, // Ensure it starts at 0 if undefined
          
        },
      });

         

        } else {
         
        }


         

      } catch (error) {
        console.error('Error in afterCreate lifecycle:', error);
      }
    },
  }