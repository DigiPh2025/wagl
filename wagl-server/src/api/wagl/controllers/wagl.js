'use strict';

const { removeUndefined } = require('strapi-utils');
const savedWagl = require('../../saved-wagl/controllers/saved-wagl');

/**
 * wagl controller
 */

// @ts-ignore
const { createCoreController } = require('@strapi/strapi').factories;

module.exports = createCoreController('api::wagl.wagl',({strapi})=>({

   
   //Custom Api
    async postWagl(ctx){
        try {
        const { id } = ctx.state.user;       
        // @ts-ignore
        const { data } = ctx.request.body;     
        const isActive = data.isActive;
        const waglId = data.waglId;
        
        
      //Get User Details 
    //   let userData = await strapi.query("plugin::users-permissions.user").findOne({where: { id: userID }});

         
        await strapi.query('api::wagl.wagl').update({
            where:{id:waglId,user_id:id},
            data:{ 
                isActive: isActive 
                }
            }).then(res=>{
          
            })



       return {
            "data": {
              "status": true,
              "message": "Wagl Update Successfully",
            },
            
          }
        } catch (err) {
                
                throw err;
        }
       },

    async viewCount(ctx){
        try {
        // @ts-ignore
        const { id } = ctx.state.user;       
        // @ts-ignore
        const { data } = ctx.request.body;     
        
        const waglId = data.wagl_id;
        
               
      //Get User Details 
      const waglData = await strapi.query("api::wagl.wagl").findOne({
                  where: { id: waglId },
                  populate: { // Only retrieve the follower ID
                    user_id: true // Only retrieve the follower ID
                  }
                });

      if (!waglData) { return ctx.badRequest('Wagl not found'); }

      const updatedWaglData = await strapi.query('api::wagl.wagl').update({
            where:{id:waglId},
            data:{ 
                total_views: waglData.total_views +1 
                }
            });
           

              // Fetch the user with the given profileID
              const user = await strapi.query('plugin::users-permissions.user').findOne({ where: { id: waglData.user_id.id } });
    
              
              // Check if user exists
              if (user) {
                 // Increment the totalViews and update the user
              const updatedUser = await strapi.query('plugin::users-permissions.user').update({
                   where: { id: waglData.user_id.id },
                   data: { totalViews: user.totalViews + 1 }
               }); 
              }

            return ctx.send({
              data: {
                status: true,
                message: 'Wagl view count updated successfully',
              },
            });

            
        } catch (err) {
                
                throw err;
        }
       },

    async homefeeds(ctx){
      // return 0;
      // const bcrypt = require('bcryptjs');
      
      
        try { 
        const { id } = ctx.state.user;   
         
        // @ts-ignore
        const { data } = ctx.request.body;     
      
         //Get Block Users
         const usersBlockList = await strapi.entityService.findMany("api::block-user.block-user", {
          filters: {
            block_id: id,
            // @ts-ignore
            user_id: { $ne: null } // Ensure followersID is not null
          },
          populate: {
            block_id: { fields: ['id'] }, // Only retrieve the follower ID
            user_id: { fields: ['id'] } // Only retrieve the follower ID
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
        // const followersIds = usersFollowersList.map(follower => follower.followersID.id);
        const followersIds = [...new Set(usersFollowersList.map(follower => follower.followersID.id))];
       // @ts-ignore
       const blockedIds = usersBlockList.map(list => list.user_id.id);

        let filteredFollowersIdswithBlocked = followersIds.filter(id => !blockedIds.includes(id));
       

       
        const usersSavedList = await strapi.entityService.findMany("api::saved-wagl.saved-wagl", {
          filters: {
            user_id: id,
            // @ts-ignore
            wagl_id: { $ne: null } // Ensure followersID is not null
          },
          populate: {
            wagl_id: { fields: ['id'] } // Only retrieve the follower ID
          }
        });
        
      
        const savedWaglIdsList = [...new Set(usersSavedList.map(wagls => wagls.wagl_id.id))];
        

        let filteredSavedWaglIds = savedWaglIdsList.filter(id => !blockedIds.includes(id));
        
        const page = data.skip; // Example page number
        const pageSize = data.limit; // Number of records per page
        let start = (page - 1) * pageSize; // Calculate skip value
      

const totalWaglsCount = await strapi.entityService.count("api::wagl.wagl", {
  filters: {
    // @ts-ignore
    // user_id: { $in: followersIds }
    user_id: { $in: [...filteredFollowersIdswithBlocked, id] }
  }
});

const getWagls = await strapi.entityService.findMany("api::wagl.wagl", {
  filters: {
    // @ts-ignore
    // user_id: { $in: followersIds },
    user_id: { $in: [...filteredFollowersIdswithBlocked, id] }
    // createdAt: { $gte: startOfDay, $lte: endOfDay } // Uncomment if you want to filter by date
  },
  populate: {
    user_id:  {
      populate: {
        profilePic: true, // Populate categoryIcon within interested_categories
      },
    },
    media: true, // Populate media
    good_tags: {
      populate: {
        image: true, // Populate categoryIcon within interested_categories
      },
    }, // Populate media
    interested_categories: {
      populate: {
        categoryIcon: true, // Populate categoryIcon within interested_categories
      },
    },
    product_id: {
      populate: {
        product_pic: true, // Populate categoryIcon within interested_categories
        brand_id:true
      },
    }
  },
  // @ts-ignore
  sort: { createdAt: 'DESC' },
  start, // Skip the first 'start' records
  limit: pageSize, // Limit the number of records returned
});


// Assuming you have a `likedWagls` array that contains wagl IDs that the user has liked
const savedWagls = await strapi.entityService.findMany("api::saved-wagl.saved-wagl", {
  filters: {
    // @ts-ignore
    wagl_id: { $in: filteredSavedWaglIds } // Adjust this if necessary
  },
  populate: {
    // @ts-ignore
    wagl_id: true // Populate to get related wagls
  }
});
// Assuming you have a `likedWagls` array that contains wagl IDs that the user has liked
const likedWagls = await strapi.entityService.findMany("api::like.like", {
  filters: {
    // @ts-ignore
    // user_id: { $in: followersIds } // Adjust this if necessary
    user_id: { $in: [...filteredFollowersIdswithBlocked, id] },
    wagl_id: { $ne: null }
  },
  populate: {
    // @ts-ignore
    wagl_id: true // Populate to get related wagls
  }
});

// Create a set of liked wagl IDs for quick lookup
// @ts-ignore
const likedWaglIds = new Set(likedWagls.map(like => like.wagl_id.id));
// @ts-ignore
const saveList = new Set(savedWagls.map(saved => saved.wagl_id.id));

// Map through the wagls to add the isLike property
const result = getWagls.map(wagl => ({
  ...wagl,
  isLike: likedWaglIds.has(wagl.id), // Check if the wagl ID is in the liked set
  // @ts-ignore
  isSaved: saveList.has(wagl.id), // Check if the wagl ID is in the liked set
  isFollow: true 
}));

if(result.length==0 || (result.length<pageSize)){  //unfollowed users waglw list with location and those users interested shown similar to me
  
// Get all interested categories from followed Wagls
const followedCategories = new Set();
const findCategory  = await strapi.entityService.findMany("plugin::users-permissions.user", {
  select: ['password'],
  filters: {   
    id: id,
  },
  populate: { 
    interestedCategories: true,
  }
});

findCategory.forEach(user => {
  // @ts-ignore
  user.interestedCategories.forEach(category => {
    followedCategories.add(category.id);
  });
});



const totalSuggestedWaglsCount = await strapi.entityService.count("api::wagl.wagl", {
  filters: {
    // @ts-ignore
    // user_id: { $in: followersIds }
    user_id: { $nin: [...filteredFollowersIdswithBlocked] },
    interested_categories: { id: { $in: Array.from(followedCategories) } },
  }
});


const filtersForSuggestion = { 
  $and: [
    {
      $or: [
        // { 'interested_categories.id': { $in: Array.from(followedCategories) } }, // Category filter
        { interested_categories: { id: { $in: Array.from(followedCategories) } } }, // Category filter           
      ],
    },
    {      
      
      user_id: { $notIn: [...filteredFollowersIdswithBlocked, id] }, // Mandatory user_id filter
    },
  ],
};

  // Dynamically add location filter if available
  if (findCategory[0]?.searchable_location) {
    // @ts-ignore
    filtersForSuggestion.$and[0].$or.push({
      // @ts-ignore
      location: { $containsi: findCategory[0].searchable_location },
    });

    const usersByLocation  = await strapi.entityService.findMany("plugin::users-permissions.user", {
        filters: {   
          searchable_location: findCategory[0].searchable_location,
          id: { $ne: findCategory[0].id }
        },
        populate: {id:true}
    });

  const userIDs = usersByLocation.map(user => user.id);

  // @ts-ignore
  filtersForSuggestion.$and[0].$or.push({
                // @ts-ignore
                user_id: { $in: userIDs } ,
              });


  }



// result.length!=0 ?
// start = (result.length<pageSize) ? pageSize-result.length : start + unfollowLastpage
// @ts-ignore
start = result.length == 0 ? (data.btn=='inc' ? data.unfollowLastpage : data.unfollowLastpage- data.limit) : 0;
 
// Fetch suggested content (modify filters based on your logic)

// pageSize-result.length + data.limit 

const knex = strapi.db.connection;

// return filtersForSuggestion; 

// const filtersForSuggestion1 = {
//   $and: [
//     {      
//       $and: [
//         {user_id: { $notIn: [...filteredFollowersIdswithBlocked, id] } },// Category filter        
//         {user_id: { $in: [13] } }          
//       ],
//     }
// ]
// };

let suggestedContent = await strapi.entityService.findMany("api::wagl.wagl", {
  filters: filtersForSuggestion,
  // filters: {
  // //   // user_id: { id : { $in: [11,12] } }, // Direct comparison
  // //   // id: { $in: [144,145] }, 
  //   location: {
  //           "$containsi": "pune"
  //       }
  // },
  populate: { 
    location: true,
    user_id: {
      populate: {
        profilePic: true,
      }, 
    },
    media: true,
    good_tags: {
      populate: {
        image: true,
      },
    },
    interested_categories: true,
    // interested_categories: {
    //   populate: {
    //     id:true,
    //     categoryIcon: true,
    //   },
    // },
    product_id: { 
      populate: {
        product_pic: true, // Populate categoryIcon within interested_categories
        brand_id:true
      },
    }
    
  },
  // @ts-ignore
  sort: { createdAt: 'DESC' },
  start,
  limit: (result.length<pageSize) ? pageSize-result.length : pageSize, // Limit the number of suggested content returned
  // limit: 1, // Limit the number of suggested content returned
});


// return suggestedContent;


const suggestedWaglCount=suggestedContent.length;


if(result.length!=0)
{  

  suggestedContent = result.concat(suggestedContent).reduce((acc, obj) => {
    const existingObj = acc.find(item => item.id === obj.id);
    if (existingObj) {
      Object.assign(existingObj, obj); // Merge properties of obj into existingObj
    } else {
      acc.push(obj); // Add new object if it doesn't exist
    }
    return acc;
  }, []);
  

}


const result_suggest = suggestedContent.map(wagl => ({
  ...wagl,
  isLike: likedWaglIds.has(wagl.id), // Check if the wagl ID is in the liked set
  // @ts-ignore
  isSaved: saveList.has(wagl.id) ,// Check if the wagl ID is in the liked set
  isFollow: [...filteredFollowersIdswithBlocked, id].includes(wagl.user_id.id)   
}));

if(result_suggest.length==0){
 // Prepare pagination meta
 const meta = {
  pagination: {
    page: 1, // Assuming single page for this example
    pageSize: result_suggest.length,
    pageCount: 1,
    total: totalWaglsCount
  }
};
return ctx.send({ 
  page:page,
  data:result, 
  meta: meta,
  message : "Suggested User Data if unfollow"
});
} else {
   // Prepare pagination meta
   const meta = {
    pagination: {
      page: 1, // Assuming single page for this example
      pageSize: pageSize,
      pageCount: 100,
      total: suggestedWaglCount, 
      unfollowLastpage: result.length == 0 ? (data.btn=='inc' ? (data.unfollowLastpage + data.limit) : (data.unfollowLastpage - data.limit)) : pageSize-result.length
    }
  };
  return ctx.send({ 
    page:page,
    data:result_suggest, 
    meta: meta,
    // testdata:{
    //           "result":result,
    //           "suggestedContent":suggestedContent,
    //           "filtersForSuggestion":filtersForSuggestion,
    //           start:start,
    //           limit: (result.length<pageSize) ? pageSize-result.length : pageSize,
    //   },
    message : "Suggested User Data else follow"
  });
}

}else{
  // Prepare pagination meta
    const meta = {
      pagination: {
        page: 1, // Assuming single page for this example
        pageSize: getWagls.length,
        pageCount: 1, 
        unfollowLastpage  : 0,
        total: totalWaglsCount
      } 
    }; 
    return ctx.send({ 
      page:page,
      data:result, 
      meta: meta,
      message : "Follow User Data last"
    });
}

           
        } catch (err) {
                // if (err instanceof SomeCustomError) {
                //     return ctx.send(err.body, err.status);
                // }
                
                throw err;
        }
       },  

  async searchSuggestions(ctx){
        try {
        const { id } = ctx.state.user;   
            
        // @ts-ignore
        const { searchKey } = ctx.request.body;     
       
        if (!searchKey) {
          return ctx.badRequest('Name query parameter is required');
        }
        // @ts-ignore
        const search = [];
        //Search in good tags
        const goodTags  = await strapi.entityService.findMany('api::good-tag.good-tag', {
          filters: {
            name: {
              $containsi: searchKey, // Case-insensitive search
            },
          },
          populate: {
                    image: true, // Populate categoryIcon within interested_categories
                  },
        });
 
        // Perform the search in interested-category
    const interestedCategories = await strapi.entityService.findMany('api::interested-category.interested-category', {
      filters: {
        categoryName: {
          $containsi: searchKey, // Case-insensitive search
        },
      },
      populate: {
        categoryIcon: true, // Populate categoryIcon within interested_categories
        categoryImage:true
      },
    });
    const formattedGoodTags = {
      data: goodTags.map(tag => ({
        id: tag.id,
        attributes: {
          name: tag.name,
          createdAt: tag.createdAt,
          updatedAt: tag.updatedAt,
          publishedAt: tag.publishedAt,
          image: tag.image ? {
            data: {
              id: tag.image.id,
              attributes: {
                name: tag.image.name,
                alternativeText: tag.image.alternativeText,
                caption: tag.image.caption,
                width: tag.image.width,
                height: tag.image.height,
                formats: tag.image.formats,
                hash: tag.image.hash,
                ext: tag.image.ext,
                mime: tag.image.mime,
                size: tag.image.size,
                url: tag.image.url,
                previewUrl: tag.image.previewUrl,
                provider: tag.image.provider,
                provider_metadata: tag.image.provider_metadata,
                createdAt: tag.image.createdAt,
                updatedAt: tag.image.updatedAt,
                isUrlSigned: tag.image.isUrlSigned,
              },
            },
          } : null, // Handle case where image might be null
        },
      })),
     
    };
     // Format interestedCategories to match the desired output
     const formattedCategories = {
      // data: interestedCategories.map(category => ({
      //   id: category.id,
      //   attributes: {
      //     categoryName: category.categoryName,
      //     categoryIcon: {
      //       data: category.categoryImage.map(icon => ({
      //         id: icon.id,
      //         attributes: {
      //           name: icon.name,
      //           alternativeText: icon.alternativeText,
      //           caption: icon.caption,
      //           width: icon.width,
      //           height: icon.height,
      //           formats: icon.formats,
      //           hash: icon.hash,
      //           ext: icon.ext,
      //           mime: icon.mime,
      //           size: icon.size,
      //           url: icon.url,
      //           previewUrl: icon.previewUrl,
      //           provider: icon.provider,
      //           provider_metadata: icon.provider_metadata,
      //           createdAt: icon.createdAt,
      //           updatedAt: icon.updatedAt,
      //           isUrlSigned: icon.isUrlSigned,
      //         },
      //       })),
      //     },
      //   },
      // })),
      data: interestedCategories.map(category => ({
        id: category.id,
        attributes: {
          categoryName: category.categoryName,
          categoryIcon: {
            // data: category.categoryImage.map(icon => ({
              data:{id: category.categoryImage.id,
              attributes: {
                name: category.categoryImage.name,
                alternativeText: category.categoryImage.alternativeText,
                caption: category.categoryImage.caption,
                width: category.categoryImage.width,
                height: category.categoryImage.height,
                formats: category.categoryImage.formats,
                hash: category.categoryImage.hash,
                ext: category.categoryImage.ext,
                mime: category.categoryImage.mime,
                size: category.categoryImage.size,
                url: category.categoryImage.url,
                previewUrl: category.categoryImage.previewUrl,
                provider: category.categoryImage.provider,
                provider_metadata: category.categoryImage.provider_metadata,
                createdAt: category.categoryImage.createdAt,
                updatedAt: category.categoryImage.updatedAt,
                isUrlSigned: category.categoryImage.isUrlSigned,
              },
            }
            // })),
          },
        },
      })),
    
    };
    // const searchKeyLower = searchKey.toLowerCase();
    const searchKeyLower = searchKey;
    // const users = await strapi.entityService.findMany('plugin::users-permissions.user', {
    //   filters: {
    //     // id: { $ne: id },  // Exclude current user's ID
    //     $or: [
    //           { username: { $contains: searchKeyLower } },    // Searches username
    //           { email: { $contains: searchKeyLower } },      // Searches email
    //           { firstName: { $contains: searchKeyLower } }, // Searches email
    //           { lastName: { $contains: searchKeyLower } },   // Searches email
    //           // // @ts-ignore
    //           // { username: { $regex: new RegExp(searchKey, 'i') } },    // Searches username (case-insensitive)
    //           // // @ts-ignore
    //           // { email: { $regex: new RegExp(searchKey, 'i') } },      // Searches email (case-insensitive)
    //           // // @ts-ignore
    //           // { firstName: { $regex: new RegExp(searchKey, 'i') } }, // Searches first name (case-insensitive)
    //           // // @ts-ignore
    //           // { lastName: { $regex: new RegExp(searchKey, 'i') } }   // Searches last name (case-insensitive)
    //         ] 
    //   },
    //   populate: {
    //     profilePic:true
    //   },
    // });

    const filters = {
      $or: [
        { username: { $containsi: searchKeyLower } },
        { email: { $containsi: searchKeyLower } },
        { firstName: { $containsi: searchKeyLower } },
        { lastName: { $containsi: searchKeyLower } }
      ]
    };
    
    const users = await strapi.entityService.findMany('plugin::users-permissions.user', {
      filters: {
        ...filters,
      },
      populate: {
        profilePic: true
      },  
    });

    // const filters = {
    //   $or: [
    //     { username: { $contains: searchKeyLower ,$options:"i" } },
    //     { email: { $contains: searchKeyLower,$options:"i" } },
    //     { firstName: { $contains: searchKeyLower,$options:"i" } },
    //     { lastName: { $contains: searchKeyLower,$options:"i" } }
    //   ]
    // };
    // Fetch users while excluding the current user's ID if needed
// const users = await strapi.entityService.findMany('plugin::users-permissions.user', {
//   filters: {
//     ...filters,
//     // Uncomment if you want to exclude the current user's ID
//     // id: { $ne: id },
//   },
//   populate: {
//     profilePic: true // Populate only the necessary fields
//   },
//   // Optionally add pagination to limit results
//   // pagination: {
//   //   page: 1,  // Current page
//   //   pageSize: 10 // Number of results per page
//   // },
// });

       // Get the list of follower IDs for the current user
       const followingUserIds = await strapi.entityService.findMany('api::follower-list.follower-list', {
        filters: { userID: id },
        populate: {
          userID: true, // Populate categoryIcon within interested_categories
          followersID:true
        },
        // fields: ['followersID'],
      });
      // @ts-ignore
      // const followingIds = followingUserIds.map(f => f.followersID.id);

  const followingIds = followingUserIds
  .filter(f => f.followersID !== null) // Filter out entries with null followersID
  .map(f => f.followersID.id); // Then map to extract the ids

    // Format the response
    const responseData = users.map(user => {
      // Check if the current user follows this user
      const isFollowing = followingIds.includes(user.id);

      return {
        id: user.id,
        attributes: {
          userID: user.id,
          username: user.username,
          firstName: user.firstName,
          lastName: user.lastName,
          email: user.email,
          // @ts-ignore
          profilePic:user.profilePic,
          totalFollowers:user.totalFollowers,
          following: isFollowing, // Check if the user is followed
        },
      };
    });
      // @ts-ignore
            return ctx.send({
              data:  {
                goodTags:formattedGoodTags.data,
                interestedCategories:formattedCategories.data,
                users:responseData
              },
              status:true
            });

           
        } catch (err) {
                
                throw err;
        }
       },  

    async totalWaglCount(ctx){
        try {
        const { id } = ctx.state.user;       
        // @ts-ignore
        // @ts-ignore
        const { data } = ctx.request.body; 
      //Get Wagls Details 
      const waglData = await strapi.query("api::wagl.wagl").findWithCount({where: { userId: id }});
          
      if (!waglData) { return ctx.badRequest('Wagl not found'); }
  
        } catch (err) {
                // if (err instanceof SomeCustomError) {
                //     return ctx.send(err.body, err.status);
                // }
                
                throw err;
        }
       },
       
  async discoveryWagl(ctx){
        try {
        const { id } = ctx.state.user;   
            
        // @ts-ignore
        const { data } = ctx.request.body;     
        
     
          //Get Block Users
          const usersBlockList = await strapi.entityService.findMany("api::block-user.block-user", {
            filters: {
              user_id: id,
              // @ts-ignore
              block_id: { $ne: null } // Ensure followersID is not null
            },
            populate: {
              block_id: { fields: ['id'] } // Only retrieve the follower ID
            }
          });
               
          // Extract only the follower IDs
          // @ts-ignore
          const blockedIds = usersBlockList.map(list => list.block_id.id);
          //Get Reported Wagl
          const reportedWagls = await strapi.entityService.findMany("api::report-wagl.report-wagl", {
            filters: {
              user_id: id,
              // @ts-ignore
              wagl_id: { $ne: null } // Ensure followersID is not null
            },
            populate: {
              wagl_id: { fields: ['id'] } // Only retrieve the follower ID
            }
          });     
          // Extract only the follower IDs
          // @ts-ignore
          const reportedWaglds = reportedWagls.map(list => list.wagl_id.id);




        // const interested_categories = data.interested_categories
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
        // const followerIds = usersFollowersList.map(follower => follower.followersID.id);


        const followersIds = [...new Set(usersFollowersList.map(follower => follower.followersID.id))];

        let filteredFollowersIdswithBlocked = followersIds.filter(id => !blockedIds.includes(id));

        let filteredFollowersIds = filteredFollowersIdswithBlocked.filter(id => !reportedWaglds.includes(id));
       
// Step 2: Query all users and filter out followers
const unFollowUsers = await strapi.entityService.findMany("plugin::users-permissions.user", {
  filters: {
    // @ts-ignore
    id: { $nin: Array.from(filteredFollowersIds) } // Exclude follower IDs
  },
  fields: ['id', 'username'] // Adjust fields as necessary
});
const unFollowList = unFollowUsers.map(unfollower => unfollower.id);
const page = data.skip; // Example page number
const pageSize = data.limit; // Number of records per page
const start = (page - 1) * pageSize; // Calculate skip value

const totalWaglsCount = await strapi.entityService.count("api::wagl.wagl", {
  filters: {
    // @ts-ignore
    user_id: { $in: unFollowList },
    // interested_categories:interested_categories
  }
});



const filtersForSuggestion = {  // @ts-ignore
  user_id: { $in: unFollowList },
  // interested_categories:interested_categories
};  

if ('interested_categories' in data) {
  filtersForSuggestion.interested_categories =  { $in: [data.interested_categories] };
}

if ('product_id' in data) {  
  filtersForSuggestion.product_id =  { $in: [data.product_id] };
}

// if (findCategory[0].searchable_location) {// Case-insensitive search
//   filtersForSuggestion.searchable_location = { $containsi: findCategory[0].searchable_location }; // Case-insensitive search
// }


const getWagls = await strapi.entityService.findMany("api::wagl.wagl", {
  // filters: {
  //   // @ts-ignore
  //   user_id: { $in: unFollowList },
  //   interested_categories:interested_categories
  //   // createdAt: { $gte: startOfDay, $lte: endOfDay } // Uncomment if you want to filter by date
  // },
  filters: filtersForSuggestion,
  populate: {
    user_id: true, // Populate user_id
    media: true, // Populate media
    good_tags: {
      populate: {
        image: true, // Populate categoryIcon within interested_categories
      },
    }, // Populate media
    interested_categories: {
      populate: {
        categoryIcon: true, // Populate categoryIcon within interested_categories
      },
    },
    product_id: {
      populate: {
        product_pic: true, // Populate categoryIcon within interested_categories
      },
    },
  },
  // @ts-ignore
  sort: { createdAt: 'DESC' },
  start, // Skip the first 'start' records
  limit: pageSize, // Limit the number of records returned
});




// Assuming you have a `likedWagls` array that contains wagl IDs that the user has liked
const likedWagls = await strapi.entityService.findMany("api::like.like", {
  filters: {
    // @ts-ignore
    user_id: { $in: unFollowList } // Adjust this if necessary
  },
  populate: {
    // @ts-ignore
    wagl_id: true // Populate to get related wagls
  }
});

// Create a set of liked wagl IDs for quick lookup
// @ts-ignore
const likedWaglIds = new Set(likedWagls.map(like => like.wagl_id.id));

// Map through the wagls to add the isLike property
const result = getWagls.map(wagl => ({
  ...wagl,
  isLike: likedWaglIds.has(wagl.id) // Check if the wagl ID is in the liked set
}));

const outputData = {
  data: getWagls.map(item => ({
    id: item.id,
    attributes: {
      description: item.description,
      location: item.location,
      isActive: item.isActive,
      createdAt: item.createdAt,
      updatedAt: item.updatedAt,
      publishedAt: item.publishedAt,
      total_likes: item.total_likes,
      total_comments: item.total_comments,
      total_views: item.total_views,
      total_saved: item.total_saved,
      media: {
        // @ts-ignore
        data: item.media ? item.media : null,
      },
      user_id: {
        data: {
          // @ts-ignore
          id: item.user_id.id,
          attributes: {
            // @ts-ignore
            username: item.user_id.username,
            // @ts-ignore
            email: item.user_id.email,
            // @ts-ignore
            provider: item.user_id.provider,
            // @ts-ignore
            confirmed: item.user_id.confirmed,
            // @ts-ignore
            blocked: item.user_id.blocked,
            // @ts-ignore
            createdAt: item.user_id.createdAt,
            // @ts-ignore
            updatedAt: item.user_id.updatedAt,
            // @ts-ignore
            firstName: item.user_id.firstName,
            // @ts-ignore
            lastName: item.user_id.lastName,
            // @ts-ignore
            dateOfBirth: item.user_id.dateOfBirth,
            // @ts-ignore
            location: item.user_id.location,
            // @ts-ignore
            gender: item.user_id.gender,
            // @ts-ignore
            pronouns: item.user_id.pronouns,
            // @ts-ignore
            accountType: item.user_id.accountType,
            // @ts-ignore
            totalWagls: item.user_id.totalWagls,
            // @ts-ignore
            totalFollowers: item.user_id.totalFollowers,
            // @ts-ignore
            totalFollowing: item.user_id.totalFollowing,
            // @ts-ignore
            totalViews: item.user_id.totalViews,
            // @ts-ignore
            bio: item.user_id.bio,
            // @ts-ignore
            linkAccountBy: item.user_id.linkAccountBy,
            // @ts-ignore
            emailNotification: item.user_id.emailNotification,
            // @ts-ignore
            pushNotification: item.user_id.pushNotification,
            // @ts-ignore
            fcm: item.user_id.fcm,
            profilePic: {
              data: null, // Adjust if there's profile picture data
            },
            interestedCategories: {
              data: [], // Adjust if there are interested categories
            }
          }
        }
      },
      // @ts-ignore
      good_tags: item.good_tags.map(tag => ({
        id: tag.id,
        name: tag.name,
        createdAt: tag.createdAt,
        updatedAt: tag.updatedAt,
        publishedAt: tag.publishedAt,
        image: tag.image ? {
          data: {
            id: tag.image.id,
            attributes: {
              name: tag.image.name,
              alternativeText: tag.image.alternativeText,
              caption: tag.image.caption,
              width: tag.image.width,
              height: tag.image.height,
              formats: tag.image.formats,
              hash: tag.image.hash,
              ext: tag.image.ext,
              mime: tag.image.mime,
              size: tag.image.size,
              url: tag.image.url,
              provider: tag.image.provider,
            }
          }
        } : null
      })),
      // @ts-ignore
      interested_categories: item.interested_categories.map(category => ({
        id: category.id,
        categoryName: category.categoryName,
        createdAt: category.createdAt,
        updatedAt: category.updatedAt,
        publishedAt: category.publishedAt,
        totalWagls: category.totalWagls,
        categoryIcon: category.categoryIcon.map(icon => ({
          id: icon.id,
          name: icon.name,
          alternativeText: icon.alternativeText,
          caption: icon.caption,
          width: icon.width,
          height: icon.height,
          hash: icon.hash,
          ext: icon.ext,
          mime: icon.mime,
          size: icon.size,
          url: icon.url,
          provider: icon.provider,
        }))
      }))
    }
  }))
};

 // Prepare pagination meta
 const meta = {
  pagination: {
    page: 1, // Assuming single page for this example
    pageSize: getWagls.length,
    pageCount: 1,
    total: totalWaglsCount
  }
};
            return ctx.send({
              // data: outputData.data,
              data: result,
              // odata: getWagls,
              meta: meta
            });

           
        } catch (err) {
                // if (err instanceof SomeCustomError) {
                //     return ctx.send(err.body, err.status);
                // }
                throw err;
        }
       }, 

  async getProfileWagls(ctx){
      try {
        const { id } = ctx.state.user; 
        // @ts-ignore
        const { data } = ctx.request.body;     
          
        const page = data.skip; // Example page number
        const pageSize = data.limit; // Number of records per page
        const start = (page - 1) * pageSize; // Calculate skip value

const totalWaglsCount = await strapi.entityService.count("api::wagl.wagl", {
  filters: {
    // @ts-ignore
    user_id: { $in: id } 
  }
});


const getWagls = await strapi.entityService.findMany("api::wagl.wagl", {
  filters: {
    // @ts-ignore
    user_id: { $in: id } 
  },
  populate: {
    user_id:  {
      populate: {
        profilePic: true, // Populate categoryIcon within interested_categories
      },
    },
    media: true, // Populate media
    good_tags: {
      populate: {
        image: true, // Populate categoryIcon within interested_categories
      },
    }, // Populate media
    interested_categories: {
      populate: {
        categoryIcon: true, // Populate categoryIcon within interested_categories
      },
    },
    product_id: {
      populate: {
        product_pic: true, // Populate categoryIcon within interested_categories
      },
    }
  },
  // @ts-ignore
  sort: { createdAt: 'DESC' },
  start, // Skip the first 'start' records
  limit: pageSize, // Limit the number of records returned
});

  
// Assuming you have a `likedWagls` array that contains wagl IDs that the user has liked
const likedWagls = await strapi.entityService.findMany("api::like.like", {
  filters: {
    // @ts-ignore
    user_id: { $in: id } ,// Adjust this if necessary 
    wagl_id: { $ne: null }
  },
  populate: {
    // @ts-ignore
    wagl_id: true // Populate to get related wagls
  }
});

// Create a set of liked wagl IDs for quick lookup
// @ts-ignore
const likedWaglIds = new Set(likedWagls.map(like => like.wagl_id.id));
// @ts-ignore
// const saveList = new Set(savedWagls.map(saved => saved.wagl_id.id));

// Map through the wagls to add the isLike property
const result = getWagls.map(wagl => ({
  ...wagl,
  isLike: likedWaglIds.has(wagl.id), // Check if the wagl ID is in the liked set
  // @ts-ignore
  // isSaved: saveList.has(wagl.id) // Check if the wagl ID is in the liked set
}));

          // Prepare pagination meta
          const meta = {
            pagination: {
              page: 1, // Assuming single page for this example
              pageSize: getWagls.length,
              pageCount: 1,
              total: totalWaglsCount
            }
          };

      return ctx.send({
        // data: outputData.data,
        page:page,
        data: result,
        // odata: "suggestedContent",
        meta: meta
      });
           
        } catch (err) {                
               
                throw err;
        }
    },  

    async getSavedWagls(ctx){
      try {
        const { id } = ctx.state.user;   
        // @ts-ignore
        const { data } = ctx.request.body; 
          
        const page = data.skip; // Example page number
        const pageSize = data.limit; // Number of records per page
        const start = (page - 1) * pageSize; // Calculate skip value


        const usersSavedList = await strapi.entityService.findMany("api::saved-wagl.saved-wagl", {
          filters: {
            user_id: id,
            // @ts-ignore
            wagl_id: { $ne: null } // Ensure followersID is not null
          },
          populate: {
            wagl_id: { fields: ['id'] } // Only retrieve the follower ID
          }
        });
        const savedWaglIdsList = [...new Set(usersSavedList.map(wagls => wagls.wagl_id.id))];

      const totalWaglsCount = await strapi.entityService.count("api::wagl.wagl", {
        filters: {
          // @ts-ignore
          id: { $in: savedWaglIdsList } 
        }
      });


const getWagls = await strapi.entityService.findMany("api::wagl.wagl", {
  filters: {
    // @ts-ignore
    id: { $in: savedWaglIdsList } 
  },
  populate: {
    user_id:  {
      populate: {
        profilePic: true, // Populate categoryIcon within interested_categories
      },
    },
    media: true, // Populate media
    good_tags: {
      populate: {
        image: true, // Populate categoryIcon within interested_categories
      },
    }, // Populate media
    interested_categories: {
      populate: {
        categoryIcon: true, // Populate categoryIcon within interested_categories
      },
    },
    product_id: {
      populate: {
        product_pic: true, // Populate categoryIcon within interested_categories
      },
    }
  },
  // @ts-ignore
  sort: { createdAt: 'DESC' },
  start, // Skip the first 'start' records
  limit: pageSize, // Limit the number of records returned
});


  
// Assuming you have a `likedWagls` array that contains wagl IDs that the user has liked
const likedWagls = await strapi.entityService.findMany("api::like.like", {
  filters: {
    // @ts-ignore
    user_id: { $in: id } ,// Adjust this if necessary 
    wagl_id: { $ne: null }
  },
  populate: {
    // @ts-ignore
    wagl_id: true // Populate to get related wagls
  }
});

// Create a set of liked wagl IDs for quick lookup
// @ts-ignore
const likedWaglIds = new Set(likedWagls.map(like => like.wagl_id.id));
// @ts-ignore
// const saveList = new Set(savedWagls.map(saved => saved.wagl_id.id));

// Map through the wagls to add the isLike property
const result = getWagls.map(wagl => ({
  ...wagl,
  isLike: likedWaglIds.has(wagl.id), // Check if the wagl ID is in the liked set
  // @ts-ignore
  // isSaved: saveList.has(wagl.id) // Check if the wagl ID is in the liked set
}));

          // Prepare pagination meta
          const meta = {
            pagination: {
              page: 1, // Assuming single page for this example
              pageSize: getWagls.length,
              pageCount: 1,
              total: totalWaglsCount
            }
          };

      return ctx.send({
        // data: outputData.data,
        page:page,
        data: result,
        // odata: "suggestedContent",
        meta: meta
      });
           
        } catch (err) {                
                
                throw err;
        }
    },  

   }));
