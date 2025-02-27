// src/api/your-api/services/your-api.js

const { env } = require('strapi-utils');

require('dotenv').config();

module.exports = {
    // /**
    //  * Check if a user contains a specific country
    //  * @param {number} userId - The ID of the user
    //  * @param {number} countryId - The ID of the country to check
    //  * @returns {boolean} - True if user contains the country, otherwise false
    //  */
    async sendMail(userData) {
        const nunjucks = require('nunjucks');
        const axios = require('axios');
       
         nunjucks.configure('./email-templates', { autoescape: true });
    
            // Render the HTML with dynamic data
            const htmlContent = nunjucks.render(userData.template, userData);
       
            let mailData = JSON.stringify({
            "personalizations": [
                {
                "to": [
                    {
                    "email": userData.to
                    }
                ],
                // "cc": [
                //     {
                //     "email": "recipient2@example.com"
                //     }
                // ]
                }
            ],
            "from": {
                "email": env('FROM_MAIL')
            },
            "subject": userData.subject,
            content: [
                {
                  type: "text/html",
                  value: htmlContent, // Inject rendered HTML content
                },
              ]
            })

             let config = {
                method: 'post',
                maxBodyLength: Infinity,
                url: 'https://api.sendgrid.com/v3/mail/send',
                headers: { 
                    'authorization': env('SENDGRID_API_KEY'),                     
                    'Content-Type': 'application/json'
                },
                data : mailData
            };

          
            axios.request(config)
                .then((response) => {
                                  
            })
            .catch((error) => {
                
            });
    },
  };
  