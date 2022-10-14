//
//  ApiCollections.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/07/15.
//

import Foundation

class ApiCollections {

    // - MARK: Chart , -> RankedSong
    static let totalTop100: String = "\(Const.URL.base)/api/charts/total/100" // 누적 top 100
    static let timeTop100: String = "\(Const.URL.base)/api/charts/hourly/100" // 실시간 top 100
    static let dailyTop100: String = "\(Const.URL.base)/api/charts/daily/100" // 일간 top 100
    static let weaklyTop100: String = "\(Const.URL.base)/api/charts/weekly/100" // 주간 top 100
    static let monthlyTop100: String = "\(Const.URL.base)/api/charts/monthly/100" // 월간 top 100

    // - MARK: new Songs , 무한 스크롤
    static let newWeekly: String = "\(Const.URL.base)/api/charts/new/weekly" // 이주의 신곡
    static let newMonthly: String =  "\(Const.URL.base)/api/charts/new/monthly" // 이달의 신곡

    // "\(Const.URL.base)/api/charts/new/monthly/220501"

    // - MARK: monthly, yearly
    static let monthly: String = "\(Const.URL.base)/api/charts/new/monthly/" // 월별 노래
    static let yearly: String = "\(Const.URL.base)/api/charts/new/yearly/" // 연도별 노래

    // - MARK: newest
    static let newest: String = "\(Const.URL.base)/api/charts/new" // 최신곡

    // - MARK: others

    static let news: String = "\(Const.URL.base)/api/news" // news
    // - MARK: 주간 왁타버스 뮤직, 이세돌 뮤직
    //   0 -> 1 -> 2
    static let newsThumbnail: String = "\(Const.URL.base)/news/thumbnail/"
    static let newsCafe: String = "https://cafe.naver.com/steamindiegame/"

    // - MARK: 무한스크롤
    static let artist: String = "\(Const.URL.base)/api/artists/" // +artist id
    static let albums: String = "\(Const.URL.base)/api/albums/" // +artist id

    static let searchOneSong: String = "\(Const.URL.base)/api/charts/search/id/" // id
    static let searchSongs: String = "\(Const.URL.base)/api/charts/search/ids/" // ids (아이디1,아이디2,아이디3,...)

    // - MARK: 무한스크롤
    static let searchTitleOrArtiest: String = "\(Const.URL.base)/api/charts/search/keyword/" // (제목 또는 아티스트명)

    static let chartUpdateTotal: String = "\(Const.URL.base)/api/charts/update/total"

    static let chartUpdateHourly: String = "\(Const.URL.base)/api/charts/update/hourly"

    static let chartUpdateDaily: String = "\(Const.URL.base)/api/charts/update/daily"

    static let chartUpdateWeekly: String = "\(Const.URL.base)/api/charts/update/weekly"

    static let chartUpdateMonthly: String = "\(Const.URL.base)/api/charts/update/monthly"

}
