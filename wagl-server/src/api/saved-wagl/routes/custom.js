
module.exports={
    routes:[
        {
            method:'POST',
            path:'/removedSaved',
            handler:'saved-wagl.removedSaved',
            config:{
                // auth:false
            }
        },
        {
            method:'GET',
            path:'/getSavedWagls',
            handler:'saved-wagl.getSavedWagls',
            config:{
                // auth:false
            }
        }
    ]
}