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
    
    
    
    func fetchTop20(category:TopCategory) -> AnyPublisher<[DetailSong],Error> //메인 화면에 20개만
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
            .publishDecodable(type: [DetailSong].self) //SimpleSong 타입으로 decoding
            .value() //  return:  AnyPublisher<[SimpleViwer], AFError>
            .mapError { (err: AFError) in
                return err as Error
            }
            .eraseToAnyPublisher() //UnWraaping
    }
    
    func fetchTop100(category:TopCategory) -> AnyPublisher<[DetailSong],Error>
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
            .publishDecodable(type: [DetailSong].self)
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
    
    
    
    
    
    
}
