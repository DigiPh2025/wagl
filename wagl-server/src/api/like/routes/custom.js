
module.exports={
    routes:[
        {
            method:'POST',
            path:'/unLike',
            handler:'like.unLike',
            config:{
                // auth:false
            }
        },
        {
            method:'GET',
            path:'/getLikeWagls',
            handler:'like.getLikeWagls',
            config:{
                // auth:false
            }
        }
    ]
}