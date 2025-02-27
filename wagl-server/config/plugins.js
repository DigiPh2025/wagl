 
    module.exports = ({ env }) => ({
        upload: {
          config: {
            provider: 'aws-s3',
            providerOptions: {
              accessKeyId: env('AWS_ACCESS_KEY_ID'),
              secretAccessKey: env('AWS_ACCESS_SECRET'),
              region: env('AWS_REGION'),
              sizeLimit:1500000000,
              params: {
                // ACL: env('AWS_ACL', 'public-read'),
                ACL:'private',
                // signedUrlExpires: env('AWS_SIGNED_URL_EXPIRES', 30 * 60),
                signedUrlExpires: env('AWS_SIGNED_URL_EXPIRES', 86400),  //for one day
                Bucket: env('AWS_BUCKET'),
              },
              s3ClientConfig: {
                maxAttempts: 10, // Retry up to 10 times for failed requests
                httpOptions: {
                  connectTimeout: 1200000, // Connection timeout (10 minutes in milliseconds)
                  timeout: 1200000,        // Socket timeout (10 minutes in milliseconds)
                },
              },
            },
            actionOptions: {
              upload: {},
              uploadStream: {},
              delete: {},
            },
          },
        },
       'import-export-entries': {
    enabled: true,
    config: {
      // See `Config` section.
    },
  },
  });