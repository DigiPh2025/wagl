const jwt = require('jsonwebtoken'); 
module.exports = (config, { strapi }) => {
    return async (ctx, next) => {
      if (ctx.request.path === '/api/auth/local') {
       
  
        const  data = ctx.request.body;

      } else {  
 
           
            const routesToSkip = ['/api/updateToken'];

           

            if (ctx.request.url.startsWith('/api/') && !routesToSkip.includes(ctx.request.url)) {
              
              const authHeader = ctx.request.header.authorization;
              let token = null;

            if (authHeader && authHeader.startsWith('Bearer ')) {
            token = authHeader.split(' ')[1]; // Extract the token part

              const decoded = jwt.decode(token);
              if(token)
              {
                  const checkUser = await strapi.query('plugin::users-permissions.user').findOne({ 
                      where: { activeToken : token }
                  });
          
                  // if(!checkUser)
                  // {
                  //     return ctx.throw(400, 'Invalid Token');
                  // } 
              }
            }  
         
        }

   
        
      }
  
      await next();
    };
  };
  