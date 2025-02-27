'use strict';
const fs = require('fs');
const path = require('path');
const csv = require('csv-parser');
const brandName = require('../../brand-name/controllers/brand-name');
/**
 * product controller
 */

// @ts-ignore
const { createCoreController } = require('@strapi/strapi').factories;

module.exports = createCoreController('api::product.product',({strapi})=>({
   
    //Custom Api
     async uploadExcel(ctx){
         try {
        

        // @ts-ignore
        const { excel } = ctx.request.files;
          
            const filePath = excel.path;
          const results = await importCsv(filePath);
          ctx.send({ message: 'CSV Imported Successfully', results });
        } catch (error) {
          ctx.send({ error: 'Failed to import CSV', details: error }, 500);
        }
        },


    }));

function importCsv(filePath) {
    const results = [];
    
        return new Promise((resolve, reject) => {
          // @ts-ignore
          fs.createReadStream(filePath)
            .pipe(csv())
            .on('data', (data) => results.push(data))
            .on('end', async () => {
              for (const item of results) { 
               // check BrandName
                    let brandNameID
                    const checkBrandNameExist = await strapi.query("api::brand-name.brand-name").findOne({where: { brandName: item.Brand }});
                   
                    if(checkBrandNameExist){
                        brandNameID=checkBrandNameExist.id
                    }else{
                        // @ts-ignore
                        const newBrand = await strapi.entityService.create('api::brand-name.brand-name', {
                            data:{"brandName": item.Brand },
                          });
                        
                        
                        brandNameID=newBrand.id
                    }
                // Adjust this part to match your model and fields
                await strapi.entityService.create('api::product.product', {
                  data: {"name":item.Name,"brand_id":brandNameID,"product_url":item.Image,publishedAt: new Date()},
                });
              }
              resolve(results);
            })
            .on('error', (error) => {
              reject(error);
            });
        });
}

