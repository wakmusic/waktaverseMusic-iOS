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
    static let videos: String = "https://billboardoo.com/api/videos" //videos
    
    static let artiest: String = "https://billboardoo.com/api/artist/" //+artiest id
    static let albums: String = "https://billboardoo.com/api/albums/" //+artiest id
    
   
    static let searchOneSong: String = "https://billboardoo.com/api/charts/search/id/" //id
    static let searchSongs: String = "https://billboardoo.com/api/charts/search/ids/" //ids (아이디1,아이디2,아이디3,...)
    
    static let searchTitleOrArtiest: String = "https://billboardoo.com/api/charts/search/keyword/" //(제목 또는 아티스트명)
    
    
    
    
    /*
  
    
     업데이트 시각(아직 본 서버 추가 안됨): /api/charts/update/(total, hourly, daily, weekly, monthly)
     */
}
