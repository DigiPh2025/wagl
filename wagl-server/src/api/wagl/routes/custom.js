
module.exports={
    routes:[
        {
            method:'POST',
            path:'/postWagl',
            handler:'wagl.postWagl',
            config:{
                // auth:false
            }
        },
        {
            method:'POST',
            path:'/viewCount',
            handler:'wagl.viewCount',
            config:{
                // auth:false
            }
        },
        {
            method:'POST',
            path:'/homefeeds',
            handler:'wagl.homefeeds',
            config:{
                // auth:false
            }
        },
        {
            method:'POST',
            path:'/discoveryWagl',
            handler:'wagl.discoveryWagl',
            config:{
                // auth:false
            }
        },
        {
            method:'POST',
            path:'/searchSuggestions',
            handler:'wagl.searchSuggestions',
            config:{
                // auth:false
            }
        },
        {
            method:'POST',
            path:'/getProfileWagls',
            handler:'wagl.getProfileWagls',
            config:{
                // auth:false
            }
        },
        {
            method:'POST',
            path:'/getSavedWagls',
            handler:'wagl.getSavedWagls',
            config:{
                // auth:false
            }
        },
        {
            method:'POST',
            path:'/totalWaglCount',
            handler:'wagl.totalWaglCount',
            config:{
                // auth:false
            }
        }
    ]
}