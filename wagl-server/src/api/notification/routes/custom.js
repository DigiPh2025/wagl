
module.exports={
    routes:[
        {
            method:'POST',
            path:'/getNotificationList',
            handler:'notification.getNotificationList',
            config:{
                // auth:false
            }
        },
        
    ]
}