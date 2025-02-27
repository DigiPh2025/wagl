
module.exports={
    routes:[
        {
            method:'POST',
            path:'/unfollow',
            handler:'follower-list.unFollow',
            config:{
                // auth:false
            }
        },
        {
            method:'GET',
            path:'/getFollowersList',
            handler:'follower-list.getFollowersList',
            config:{
                // auth:false
            }
        }
    ]
}