const fs = require('fs');
const path = require('path');
const user = require('./content-types/user');
const jwt = require('jsonwebtoken'); 

const { v4: uuidv4 } = require("uuid");

module.exports=(plugin)=>{

    
    plugin.controllers.user.updateMe= async(ctx)=>{
       
        let userUpdateData = ctx.request.body;


        
        if (ctx.request.files && ctx.request.files.profilePic) {
            // Handle image upload
            const { profilePic } = ctx.request.files;
            
            const filePath = profilePic.path;
            const fileName = path.basename(filePath);
                       
            const fileStat = fs.statSync(filePath);
            
            const fileBuffer = fs.readFileSync(filePath);
                        
            const uploadService = strapi.plugins['upload'].services.upload;

            // Upload the file
            const uploadedFiles = await uploadService.upload({
                data: {}, // optional data to pass with the upload
                files: {
                    path: filePath,
                    name: fileName,
                    type: profilePic.type,
                    size: fileStat.size,
                },
            });

            // Assuming the image field in the user model is named `profilePicture`
            userUpdateData.profilePic = uploadedFiles[0].id;
        }

  // Proceed with the user update
  ctx.request.body = userUpdateData;
//   return await plugin.controllers.user.update(ctx);

        await strapi.query('plugin::users-permissions.user').update({
            where:{id:ctx.state.user.id},
            data:ctx.request.body
        }).then(res=>{
            ctx.response.status = 200
            
        })

        if ('is_first' in userUpdateData) {

            const user = await strapi.entityService.findOne(
                'plugin::users-permissions.user',
                ctx.state.user.id 
              );

            const mailData={
                firstName:user.firstName,
                lastName:user.lastName,
                // to:"tp997511xyz99abc@gmail.com",
                to:user.email,
                subject:"Wagl : Signup",
                from:"suraj@appcartsystems.com",
                template:'signup-welcome-template.html'
            };
          const sendMailResponse = await strapi.service("api::wagl.mail").sendMail(mailData);
          }

    }
    
    plugin.controllers.user.removeMediaFromLibrary= async(ctx)=>{

        const data = ctx.request.body;

        const updateIC = data.data.mediaIds.map(async mediaId =>{          
            
            const resp =await strapi.plugins['upload'].services.upload.remove({ id: 26 });

          } );


        

        return ctx.send({ 
            data:  {
              message:"User and data deleted successfully."
            },
            status:true
          });    
          
    }

    plugin.controllers.user.removeProfilePic= async(ctx)=>{
    
        try {
            const { id } = ctx.state.user; // Assuming you're using JWT authentication
            // const { field } = ctx.request.body;
           
          // Fetch the current user including their profile picture association
       
          // @ts-ignore
        //   let user = await strapi.query('plugin::users-permissions.user').find({ id:6});
        let user = await strapi.query('plugin::users-permissions.user').findOne( {where: { id: id }, populate: { profilePic: true }})
    
          // Ensure the user and profile picture exist
          if (!user || !user['profilePic']) {
            ctx.throw(404, 'User or profile picture not found');
          }
    
          // Delete the profile picture Upload entry
          await strapi.plugins['upload'].services.upload.remove({ id: user['profilePic'].id });
    
          // Update the user with nullifying the profile picture association
          // @ts-ignore
          user = await strapi.query('plugin::users-permissions.user').update(
            {
                where:{id:ctx.state.user.id},
                data: {
                    profilePic: null,
                  },
            })
            // { id }, { ['profilePic']: null });
    
          // Return the updated user object
          return user;
        // return sanitizeEntity(updatedUser, { model: strapi.query('user', 'users-permissions').model });
        } catch (err) {
          console.error(`Error deleting profile picture for user with id  :`, err);
          ctx.throw(500, 'Failed to delete profile picture');
        }
        // await strapi.query('plugin::users-permissions.user').update({
        //     where:{id:ctx.state.user.id},
        //     data:ctx.request.body
        // }).then(res=>{
        //     ctx.response.status = 200
        
        // })

    }
   
    
    // plugin.controllers.user.postProfileCount= async(ctx)=>{
         
    //     let profileID = ctx.request.body;
    //     const getTotalViews = await strapi.query("plugin::users-permissions.user").findOne({where: { id: profileID }});
       
    //     await strapi.query('plugin::users-permissions.user').update({
    //         where:{id:profileID},
    //         data:{ 
    //             totalViews : getTotalViews.totalViews + 1 
    //             }
    //     }).then(res=>{
    //         ctx.response.status = 200
    
    //     })

    // }
    plugin.controllers.user.postProfileCount = async (ctx) => {
        try {
            // Extract profileID from request body
            const { profileID } = ctx.request.body;
    
            // Validate that profileID is provided
            if (!profileID) {
                return ctx.throw(400, 'Profile ID is required');
            }
    
            // Fetch the user with the given profileID
            const user = await strapi.query('plugin::users-permissions.user').findOne({ where: { id: profileID } });
    
            // Check if user exists
            if (!user) {
                return ctx.throw(404, 'User not found');
            }
    
            // Increment the totalViews and update the user
            const updatedUser = await strapi.query('plugin::users-permissions.user').update({
                where: { id: profileID },
                data: { totalViews: user.totalViews + 1 }
            });
    
            // Respond with the updated user data
            ctx.response.status = 200;
            ctx.response.body = updatedUser;
    
        } catch (error) {
            // Handle any unexpected errors
            ctx.throw(500, error.message);
        }
    };

     /**
    Appends a function that saves the messaging token from a client device to the plugin's controller
    **/
    plugin.controllers.auth.saveFCM = async (ctx) => {
        var res = await strapi.entityService.update('plugin::users-permissions.user', ctx.state.user.id, { data: { fcm: ctx.request.body.token } });
                ctx.body = res;
            };


    plugin.controllers.user.updatePassword = async (ctx) => {

        const { data } = ctx.request.body;

        try{            
            if (!data.user_id || !data.new_password) {
                return ctx.badRequest('user and password are required');
              }

            const bcrypt = require('bcrypt');
            let userData = await strapi.query("plugin::users-permissions.user").findOne({where: { id: data.user_id}});
           
            const validPassword = await bcrypt.compare(data.old_password, userData.password);
 
            // If the password is invalid
            if (!validPassword) {
                return ctx.badRequest('Invalid user or password');
            }
            
            await strapi.query('plugin::users-permissions.user').update({
                // @ts-ignore
                where: { id: data.user_id },
                data:{                         
                        password:await bcrypt.hash(data.new_password, 10)
                    }
                }).then(res=>{ 
                // ctx.response.status = 200
                
                }); 

            return ctx.send({
                data:  {
                  message:"Password changed successfully."
                },
                status:true
              });


            } catch (err) {
                // if (err instanceof SomeCustomError) {
                //     return ctx.send(err.body, err.status);
                // }
               
                throw err;
        }
    }

    plugin.controllers.user.verifyOTP = async (ctx) => {
        try{
            const { data } = ctx.request.body;

            const fiveMinutesAgo = new Date(Date.now() - 5 * 60 * 1000);
            // let userData = await strapi.query("plugin::users-permissions.user").findOne({where: { email: data.email, otpCreatedAt: { $gte: fiveMinutesAgo }}});
            let userData = await strapi.query("plugin::users-permissions.user").findOne({where: { email: data.email, otp:data.otp, otpCreatedAt: { $gte: fiveMinutesAgo }}});

            if(userData)
                {
                    return ctx.send({
                        data:  {
                          message:"Otp matched"
                        },
                        status:true
                      });
                } else {
                    return ctx.send({
                        data:  {
                          message:"Otp has expired"
                        },
                        status:false
                      });
                }

           } catch (err) {               
                
                throw err;
           }
    }

   

    plugin.controllers.user.sendNotification = async (ctx) => { 

        const data=ctx.request.body;
        //  @ts-ignore
         const res=await strapi.notification.sendNotification(data.data.fcm, {
            notification: {
              title: `title`, // Adjust as necessary
              body: `Notification data body`,
            },
          });

 
        
        return ctx.send({
            data:  {
              res:res,
              message:"notification sent"
            },
            status:true
          });        
        
    };

    plugin.controllers.user.checkwagluser = async (ctx) => { 
        // Log the request payload (data)
        const data=ctx.request.body;

       
    
        const users = await strapi.entityService.findMany('plugin::users-permissions.user', {
          filters: { contact_no: { $in: data.data.contact_no } },
          sort: { firstName: 'asc' }
        });
    
        ctx.send(users);

    // let users = await strapi.query('plugin::users-permissions.user').findOne(
    //      { where: { id: 20 }, 
    //      populate: { profilePic: true }
    //      });

    //     return ctx.send({
    //         data:  {
    //           users:users
    //         },
    //         status:true
    //       });
    };

    plugin.controllers.user.checkfiledata = async (ctx) => { 
       
        return ctx.send({
            data:  {
              message:"custom file."
            },
            status:true
          });
    };

    plugin.controllers.user.resetPassword = async (ctx) => {
        
        try{

            const { data } = ctx.request.body;
            
            const fiveMinutesAgo = new Date(Date.now() - 5 * 60 * 1000);
            
            // let userData = await strapi.query("plugin::users-permissions.user").findOne({where: { email: data.email, otp:data.otp, otpCreatedAt: { $gte: fiveMinutesAgo }}});
            let userData = await strapi.query("plugin::users-permissions.user").findOne({where: { email: data.email }});
            
            const crypto = require('crypto');
    
                      
            const resetPasswordToken = crypto.createHash('sha1').update(new Date().toLocaleString()+data.email).digest('hex');
            // if(userData)
            // {
                const bcrypt = require('bcrypt');

                   
                const hashedPassword = await bcrypt.hash(String(data.password), 10);

                await strapi.query('plugin::users-permissions.user').update({
                    // @ts-ignore
                    where: { email: userData.email },
                    data:{ 
                            otp: "" ,
                            // password:data.password
                            password:hashedPassword
                        }
                    }).then(res=>{ 
                   
                    }); 
    
                return ctx.send({
                    data:  {
                      message:"Password changed successfully."
                    },
                    status:true
                  });
    
                          
    
            } catch (err) {
                  
                    throw err;
            }
        
            
    };

    plugin.controllers.user.updateToken = async (ctx) => { 

        
 
        const authHeader = ctx.request.header.authorization;
        let token = null;

        if (authHeader && authHeader.startsWith('Bearer ')) {
        token = authHeader.split(' ')[1]; // Extract the token part
        }

        let updatedEntry2 = await strapi.query('plugin::users-permissions.user').update({
            where: { id : ctx.state.user.id },
            data: {
                activeToken : token                       
            },
            });

        return true;       
        
    };


    plugin.controllers.user.userProfileDelete = async (ctx) => { 
       
        try{
            
            const { data } = ctx.request.body;

           
            
        const deletedAsWagl = await strapi.entityService.findMany("api::wagl.wagl", {
            filters: {
            // @ts-ignore
            // where: { id: waglID }
            user_id: data.user_id
            // createdAt: { $gte: startOfDay, $lte: endOfDay } // Uncomment if you want to filter by date
            },
            populate: {           
            interested_categories: true,   
            media:true       
            },
        // Limit the number of records returned
    });

  
      const categoryDecrementMap = new Map();  
      
      // Step 1: Tally decrements for each category ID
      deletedAsWagl.forEach((categories) => {

          if (Array.isArray(categories.interested_categories)) {             
              categories.interested_categories.forEach((category) => { 
                
                if (categoryDecrementMap.has(category.id)) {
                    categoryDecrementMap.set(category.id, categoryDecrementMap.get(category.id) + 1);
                } else {
                    categoryDecrementMap.set(category.id, 1);
                }

            });
          }

          if (Array.isArray(categories.media)) {  
                categories.media.forEach(async (media) => {
                             
                  
                  });           
                }

            });

    //    return deletedAsWagl;
    
      // Step 2: Apply updates based on the tally
      const updateIC = await Promise.all(
      Array.from(categoryDecrementMap.entries()).map(async ([categoryId, decrementCount]) => {
          const totalWaglCount = await strapi.query("api::interested-category.interested-category").findOne({
          where: { id: categoryId },
          });
  
          if (totalWaglCount) {
          const newTotalWagls = totalWaglCount.totalWagls > 0 ? totalWaglCount.totalWagls-1 : 0; // Ensure it doesn't go below 0
          const updatedCategory = await strapi.query("api::interested-category.interested-category").update({
              where: { id: categoryId },
              data: {
              totalWagls: newTotalWagls,
              },
          });
  
         
          } else {
         
          return null;
          }
      })
      );
  

            // finding the users that i am following
             let followersList = await strapi.query('api::follower-list.follower-list').findMany({
                // @ts-ignore               
                  where: { userID: data.user_id },
                  populate: ['followersID','userID']
                });            

            

            followersList.forEach(async fl => {
                
                if(fl.followersID!=null && fl.followersID!="")
                {  
                    const entry2 = await strapi.query('plugin::users-permissions.user').findOne({ 
                        where: { id : fl.followersID.id }
                        // where: { userID:9 ,followersID:6 }
                    });

                    if(entry2) 
                    { 
                            // also his (followers) following count should decrement
                        let updatedEntry2 = await strapi.query('plugin::users-permissions.user').update({
                            where: { id : fl.followersID.id },
                            data: {
                                totalFollowers : entry2.totalFollowers > 0 ? entry2.totalFollowers - 1 : 0                       
                            },
                            });
                    }                                           
                }

              });


               // finding the users those are following me
               let followingList = await strapi.query('api::follower-list.follower-list').findMany({
                // @ts-ignore               
                  where: { followersID: data.user_id },
                  populate: ['followersID','userID']
                });

                followingList.forEach(async fl => {

                if(fl.userID!=null && fl.userID!="")
                {                  
                    const entry = await strapi.query('plugin::users-permissions.user').findOne({ 
                        where: { id : fl.userID.id }
                        // where: { userID:9 ,followersID:6 }
                    });                    
                    // then his (followers) totalFollowing count should be decrement. 
                    if(entry) 
                    {
                            let updatedEntry = await strapi.query('plugin::users-permissions.user').update({
                                where: { id : fl.userID.id },
                                data: {
                                        totalFollowing: entry.totalFollowing > 0 ? entry.totalFollowing - 1 : 0,                                        
                                      },
                                });  
                    } 
                }

              });
              


            // Also automatically followers should unfollow me
             await strapi.query('api::follower-list.follower-list').update({
            // @ts-ignore
            where: { followersID: data.user_id },
            data:{ 
                publishedAt: null 
                }
            }).then(res=>{
               
            });

            //I am unfollowing other users 
            await strapi.query('api::follower-list.follower-list').update({
            // @ts-ignore
            where: { userID: data.user_id },
            data:{ 
                publishedAt: null 
                }
            }).then(res=>{
               
            });


            // await strapi.query('api::wagl.wagl').update({})

           // wagl unpublish
            await strapi.query('api::wagl.wagl').update({
                // @ts-ignore
                where: { user_id: data.user_id },
                data:{ 
                    publishedAt: null 
                    }
                }).then(res=>{
               
                });
          
            // unpublish Comments
            await strapi.query('api::comment.comment').update({
                // @ts-ignore
                where: { user_id: data.user_id },
                data:{ 
                     publishedAt: null 
                    }
                }).then(res=>{
                   
                });

                 //delete user
         let deletedUser=  await strapi.query('plugin::users-permissions.user').delete({
            where:{id:data.user_id}    
            }).then(res=>{
                
            })
           
            return ctx.send({ 
                data:  {
                  message:"User and data deleted successfully." 
                },
                status:true
              });                
    
            } catch (err) {
                    
                    throw err;
            }        
            
    };

    plugin.controllers.user.uploadFile = async (ctx) => {      
      

        try {
            const { files } = ctx.request;

                 
            // Ensure a file is provided
            if (!files || !files.files) {
              return ctx.badRequest("No file uploaded");
            }
      
            const file = files.files;
            const uniqueFileName = `${uuidv4()}-${file.name}`;

           
            const publicPath = path.join(__dirname, "../../../public");
            console.log(publicPath);

            // return strapi.dirs.public;
            
            const uploadPath = path.join(publicPath, "uploads", uniqueFileName);
            

          
      
            // Move the file to the uploads directory
            const fileStream = fs.createReadStream(file.path);
            const writeStream = fs.createWriteStream(uploadPath);
            fileStream.pipe(writeStream);
      
            await new Promise((resolve, reject) => {
              writeStream.on("finish", resolve);
              writeStream.on("error", reject);
            });
      
            // Optionally save file metadata to Strapi
            const fileInfo = {
              name: file.name,
              size: file.size,
              type: file.type,
              path: `/uploads/${uniqueFileName}`,
            };
      
            const uploadedFile = await strapi.query("plugin::upload.file").create({ data: fileInfo });
      
            ctx.send({
              message: "File uploaded successfully",
              file: uploadedFile,
            });
          } catch (error) {
            ctx.throw(500, error.message);
          }

        // try {
        //     // Access the uploaded file
        //     const { files } = ctx.request.files;

        //     console.log(files);
      
        //     // Check if a file was uploaded
        //     if (!files) {
        //       return ctx.badRequest('No file uploaded');
        //     }
      
        //     // Use Strapi's upload plugin to handle the file upload
        //     const uploadService = strapi.plugin('upload').service('upload');
      
        //     const uploadedFiles = await uploadService.upload({
        //       data: {}, // Additional data (if needed)
        //       files,    // The file(s) to upload
        //     });
      
        //     return ctx.send({ uploadedFiles });
        //   } catch (err) {
        //     console.error('Upload error:', err);
        //     return ctx.internalServerError('File upload failed');
        //   }
    },

    plugin.controllers.user.forgetPasswordMail = async (ctx) => {

    try{

        const { data } = ctx.request.body;
        
        let userData = await strapi.query("plugin::users-permissions.user").findOne({where: { email: data.email }});
        
        const crypto = require('crypto');

          
        const otp = Math.floor(10000 + Math.random() * 90000);
        // const resetPasswordToken = crypto.createHash('sha1').update(new Date().toLocaleString()+data.email).digest('hex');
        if(userData)
        {
            await strapi.query('plugin::users-permissions.user').update({
                // @ts-ignore
                where: { email: userData.email },
                data:{ 
                    otp: otp ,
                    otpCreatedAt:new Date()
                    }
                }).then(res=>{
                
                });


                const mailData={
                    firstName:userData.firstName,
                    lastName:userData.lastName,
                    to:userData.email,
                    // to:"tp997511@gmail.com",
                    subject:"Wagl : Forgot Password",
                    template:'forgot-password.html',
                    otp:otp
                };

            
            const sendMailResponse = await strapi.service("api::wagl.mail").sendMail(mailData);
           
            return ctx.send({
                data:  {
                  message:"Verification code has sent on your email id."
                },
                status:true
              });

        } else {

            return ctx.throw(400, 'User not found');

        }
            

            } catch (err) {
              
                throw err;
        }
        
            };
            
//Routes
    plugin.routes["content-api"].routes.push({
        method:"PUT",
        path : "/user/me",
        handler:"user.updateMe",
        config:{
            prefix:"",
            policies:[]
        }
    },
    {
        method:"DELETE",
        path : "/removeProfilePic",
        handler:"user.removeProfilePic",
        config:{
            prefix:"",
            policies:[]
        }
    },
    {
        method:"POST",
        path : "/uploadFile ",
        handler:"user.uploadFile",
        config:{
            prefix:"",
            policies:[]
        }
    },
    {
        method:"POST",
        path : "/removeMediaFromLibrary ",
        handler:"user.removeMediaFromLibrary",
        config:{
            prefix:"",
            policies:[]
        }
    },
    {
        method:"POST",
        path : "/removeMediaFromLibrary ",
        handler:"user.removeMediaFromLibrary",
        config:{
            prefix:"",
            policies:[]
        }
    },
    {
        method:"POST",
        path : "/postProfileCount",
        handler:"user.postProfileCount",
        config:{
            prefix:"",
            policies:[]
        }
    },
    {       
        method:"POST",
        path : "/sendNotification",
        handler:"user.sendNotification",
        config:{
            prefix:"",
            policies:[]
        }
    },
    {
        method: 'POST',
        path: '/auth/local/fcm',
        handler: 'auth.saveFCM',
        config: {
            prefix: '',
            policies: []
        }
    },
    {
        method: 'POST',
        path: '/forgetPasswordMail',
        handler: 'user.forgetPasswordMail',
        config: {
            prefix: '',
            policies: []
        }
    },
    {
        method: 'POST',
        path: '/resetPassword',
        handler: 'user.resetPassword',
        config: {
            prefix: '',
            policies: []
        }
    },
    { 
        method: 'POST',
        path: '/checkwagluser',
        handler: 'user.checkwagluser',
        config: {
            prefix: '',
            policies: []
        }
    },
    { 
        method: 'POST',
        path: '/checkfiledata',
        handler: 'user.checkfiledata',
        config: {
            prefix: '',
            policies: []
        }
    },
    {
        method: 'POST',
        path: '/updatePassword',
        handler: 'user.updatePassword',
        config: {
            prefix: '',
            policies: []
        }
    }, 
    {
        method: 'POST',
        path: '/verifyOTP',
        handler: 'user.verifyOTP',
        config: {
            prefix: '',
            policies: []
        }
    }, 
    {
        method: 'POST',
        path: '/userProfileDelete',
        handler: 'user.userProfileDelete',
        config: {
            prefix: '',
            policies: []
        }
    },
    {
        method: 'POST',
        path: '/updateToken',
        handler: 'user.updateToken',
        config: {
            prefix: '',
            policies: []
        }
    },


)
plugin.contentTypes.user = user;
    return plugin
}