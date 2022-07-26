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
    static let shared:Repository = Repository()
    
    
    
    func fetchTop100(category:TopCategory) -> AnyPublisher<[SimpleViwer],Error>
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
            .publishDecodable(type: [SimpleViwer].self)
            .value()
            .mapError { (err: AFError) in
                return err as Error
            }
            .eraseToAnyPublisher()
    }
    
    
    
    
    
}
