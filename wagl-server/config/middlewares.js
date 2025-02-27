// module.exports = [
//   'strapi::logger',
//   'strapi::errors',
//   'strapi::security',
//   'strapi::cors',
//   'strapi::poweredBy',
//   'strapi::query',
//   'strapi::body',
//   'strapi::session',
//   'strapi::favicon',
//   'strapi::public',
// ];

    // ~/strapi-aws-s3/backend/config/middlewares.js
    
    module.exports = [
      'strapi::errors',
      /* Replace 'strapi::security', with this snippet */
      /* Beginning of snippet */
      {
        name: 'strapi::security',
        config: {
          contentSecurityPolicy: {
            useDefaults: true,
            directives: {
              'connect-src': ["'self'", 'https:'],
              'img-src': [
                "'self'",
                'data:',
                'blob:',
                'dl.airtable.com',
                // 'waglmedia.s3.ap-southeast-2.amazonaws.com',
                `${process.env.AWS_BUCKET}.s3.${process.env.AWS_REGION}.amazonaws.com`
              ],
              'media-src': [
                "'self'",
                'data:',
                'blob:',
                'dl.airtable.com',
                // 'waglmedia.s3.ap-southeast-2.amazonaws.com',
                `${process.env.AWS_BUCKET}.s3.${process.env.AWS_REGION}.amazonaws.com`
              ],
              upgradeInsecureRequests: null,
            },
          },
        },
      },
      {
        name: "strapi::cors",
        config: {
          enabled: true,
          headers: "*",
        },
      },     
      {
        name: "strapi::body",
        config: {
          enabled: true,
          formLimit: "2gb", // Allow 2GB form data
          jsonLimit: "2gb", // Allow 2GB JSON requests
          textLimit: "2gb",
          timeout: 1200000, // 20 minutes
        },
      },
      /* End of snippet */
      // 'strapi::cors',
      'strapi::poweredBy',
      'strapi::logger',
      'strapi::query',
      // {
      //   name: 'strapi::body',
      //   config: {
      //     timeout: 1200000, // 600 seconds (20  minutes)
      //   },
      // },
      // 'strapi::body',
      'strapi::session',
      'strapi::favicon',
      'strapi::public', 
      
    ];