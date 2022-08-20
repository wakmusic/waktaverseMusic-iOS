//
//  Repository.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/07/15.
//

import Foundation
import Combine
import Alamofire

enum TopCategory{
    
    case total
    case time
    case daily
    case weekly
    case monthly
}


class Repository{
    static let shared:Repository = Repository() //싱글톤 패턴
    
    
    
    func fetchTop20(category:TopCategory) -> AnyPublisher<[RankedSong],Error> //메인 화면에 20개만
    {
        var url:String
        switch category {
        case .total:
            url = ApiCollections.totalTop100
        case .time:
            url = ApiCollections.timeTop100
        case .daily:
            url = ApiCollections.dailyTop100
        case .weekly:
            url = ApiCollections.weaklyTop100
        case .monthly:
            url = ApiCollections.monthlyTop100
            
        }
        url = url.replacingOccurrences(of: "100", with: "20") //100을 20개로
        return AF.request(url)
            .publishDecodable(type: [RankedSong].self) //SimpleSong 타입으로 decoding
            .value() //  return:  AnyPublisher<[SimpleViwer], AFError>
            .mapError { (err: AFError) in
                return err as Error
            }
            .eraseToAnyPublisher() //UnWraaping
    }
    
    func fetchTop100(category:TopCategory) -> AnyPublisher<[RankedSong],Error>
    {
        let url:String
        switch category {
        case .total:
            url = ApiCollections.totalTop100
        case .time:
            url = ApiCollections.timeTop100
        case .daily:
            url = ApiCollections.dailyTop100
        case .weekly:
            url = ApiCollections.weaklyTop100
        case .monthly:
            url = ApiCollections.monthlyTop100
        }
        return AF.request(url)
            .publishDecodable(type: [RankedSong].self)
            .value()
            .mapError { (err: AFError) in
                return err as Error
            }
            .eraseToAnyPublisher()
    }
    
    
    func fetchUpdateTimeStmap(category:TopCategory) -> AnyPublisher<Int,Error>
    {
        let url:String
        switch category {
        case .total:
            url = ApiCollections.chartUpdateTotal
        case .time:
            url = ApiCollections.chartUpdateHourly
        case .daily:
            url = ApiCollections.chartUpdateDaily
        case .weekly:
            url = ApiCollections.chartUpdateWeekly
        case .monthly:
            url = ApiCollections.chartUpdateMonthly
        }
        
        return AF.request(url)
            .publishDecodable(type: Int.self)
            .value()
            .mapError { (err:AFError) in
                return err as Error
            }
            .eraseToAnyPublisher()
    }
    
    
    func fetchNewMonthSong() -> AnyPublisher<newMonthInfo,Error>
    {
        let url = ApiCollections.newMonthly
        
        return AF.request(url)
            .publishDecodable(type:newMonthInfo.self)
            .value()
            .mapError { (err:AFError) in
                return err as Error
            }
            .eraseToAnyPublisher()
    }
    
    
    func fetchNews() -> AnyPublisher<[NewsModel],Error>
    {
        
        let url = ApiCollections.news
        
        return AF.request(url)
            .publishDecodable(type:[NewsModel].self)
            .value()
            .mapError { (err:AFError) in
                return err as Error
            }
            .eraseToAnyPublisher()
    }
    
    func fetchArtists() -> AnyPublisher<[Artist],Error>
    {
        let url = ApiCollections.artiest
        
        return AF.request(url)
            .publishDecodable(type: [Artist].self)
            .value()
            .mapError { (err:AFError) in
                return err as Error
            }
            .eraseToAnyPublisher()
    }
    
    func fetchSearchSongsList(_ name:String) -> AnyPublisher<[NewSong],Error>
    {
        let url = "\(ApiCollections.albums)\(name)"
        return  AF.request(url)
            .publishDecodable(type: [NewSong].self)
            .value()
            .mapError { (err:AFError) in
                return err as Error
            }
            .eraseToAnyPublisher()
    }
    
    func fetchSearchWithKeyword(_ keyword:String) -> AnyPublisher<[NewSong],Error>
    {
        let url = "\(ApiCollections.searchTitleOrArtiest)\(keyword)"
        let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! //한글로 인한 인코딩
        return  AF.request(encodedUrl)
            .publishDecodable(type: [NewSong].self)
            .value()
            .mapError { (err:AFError) in
                return err as Error
            }
            .eraseToAnyPublisher()
    }
    
    
    
    
}
