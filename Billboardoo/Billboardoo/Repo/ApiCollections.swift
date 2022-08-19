//
//  ApiCollections.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/07/15.
//

import Foundation

class ApiCollections{

    // - MARK: top 100
    static let totalTop100:String = "https://billboardoo.com/api/charts/total/100" // 누적 top 100
    static let timeTop100: String = "https://billboardoo.com/api/charts/hourly/100" //실시간 top 100
    static let dailyTop100: String = "https://billboardoo.com/api/charts/daily/100" //일간 top 100
    static let weaklyTop100: String = "https://billboardoo.com/api/charts/weekly/100" //주간 top 100
    static let monthlyTop100: String = "https://billboardoo.com/api/charts/monthly/100" //월간 top 100
    /*
     {"id":"pl38om066m0","title":"전하지 못한 진심","artist":"해루석, 아이네, 릴파, 비챤","image":"https://i.ytimg.com/vi/pl38om066m0/hqdefault.jpg","url":"https://youtu.be/pl38om066m0","reaction":"https://youtu.be/HiLXC6TWE2k","date":220703,"views":886270,"last_views":452424,"increase":433846,"last":693}
     
     */
   
    
    // - MARK: new Songs
    static let newWeekly: String = "https://billboardoo.com/api/charts/new/weekly" //이주의 신곡
    static let newMonthly: String = "https://billboardoo.com/api/charts/new/monthly" //이달의 신곡
    
    // - MARK: monthly, yearly
    static let monthly: String = "https://billboardoo.com/api/charts/new/monthly/" //월별 노래
    static let yearly: String = "https://billboardoo.com/api/charts/new/yearly/" //연도별 노래

    // - MARK: newest
    static let newest: String = "https://billboardoo.com/api/charts/new" //최신곡
   
    // - MARK: others
    
    static let news: String = "https://billboardoo.com/api/news" //news
    static let newsThumbnail: String = "https://billboardoo.com/news/thumbnail/"
    static let newsCafe: String = "https://cafe.naver.com/steamindiegame/"
    static let videos: String = "https://billboardoo.com/api/videos" //videos
    
    static let artiest: String = "https://billboardoo.com/api/artists/" //+artiest id
    static let albums: String = "https://billboardoo.com/api/albums/" //+artiest id
    
   
    static let searchOneSong: String = "https://billboardoo.com/api/charts/search/id/" //id
    static let searchSongs: String = "https://billboardoo.com/api/charts/search/ids/" //ids (아이디1,아이디2,아이디3,...)
    
    static let searchTitleOrArtiest: String = "https://billboardoo.com/api/charts/search/keyword/" //(제목 또는 아티스트명)
    
    
    
    
    static let chartUpdateTotal: String = "https://billboardoo.com/api/charts/update/total"
    
    static let chartUpdateHourly: String = "https://billboardoo.com/api/charts/update/hourly"
    
    static let chartUpdateDaily: String = "https://billboardoo.com/api/charts/update/daily"
    
    static let chartUpdateWeekly: String = "https://billboardoo.com/api/charts/update/weekly"
    
    static let chartUpdateMonthly: String = "https://billboardoo.com/api/charts/update/monthly"
    
    
    
    static let tiwtch:String = "https://billboardoo.com/auth/login/twitch"
    static let google:String = "https://billboardoo.com/auth/login/google"
    static let naver:String = "https://billboardoo.com/auth/login/naver"
    
    static let verify:String = "https://billboardoo.com/auth/api"
   
    
 
}
