
module.exports={
    routes:[
        {
            method:'POST',
            path:'/uploadExcel',
            handler:'product.uploadExcel',
            config:{
                // auth:false
            }
        },
        // {
        //     method:'POST',
        //     path:'/createProduct',
        //     handler:'product.createProduct',
        //     config:{
        //         // auth:false
        //     }
        // }
    ]
}