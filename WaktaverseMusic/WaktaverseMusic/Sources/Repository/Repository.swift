//
//  Repository.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/07/15.
//

import Foundation
import Combine
import Alamofire

enum TopCategory: String {
    case total, hourly, daily, weekly, monthly
}

class Repository {
    static let shared: Repository = Repository() // 싱글톤 패턴

    /// category 차트 상위 limit 개의 곡 정보를 불러옵니다.
    /// - Parameter category: 차트 카테고리
    /// - Parameter limit: 불러올 갯수
    /// - Returns: [RankedSong]
    func fetchTopRankedSong(category: TopCategory, limit: Int = 100) -> AnyPublisher<[RankedSong], Error> {
        let url = Const.URL.base + Const.URL.api + Const.URL.charts + "/" + category.rawValue + "/" + String(limit)

        return AF.request(url)
            .validate(statusCode: 200..<300)
            .publishDecodable(type: [RankedSong].self) // RankedSong 타입으로 decoding
            .value() // return: AnyPublisher<[RankedSong], AFError>
            .mapError { (err: Error) in
                return err as Error
            }
            .eraseToAnyPublisher()
    }

    /// category 차트의 새로고침 타임스탬프를 불러옵니다.
    /// - Parameter category: 차트 카테고리
    /// - Returns: Int ex) 1664787831
    func fetchUpdateTimeStmap(category: TopCategory) -> AnyPublisher<Int, Error> {
        let url = "https://billboardoo.com" + Const.URL.api + Const.URL.charts + "/" + Const.URL.update + "/" + category.rawValue

        return AF.request(url)
            .validate(statusCode: 200..<300)
            .publishDecodable(type: Int.self)
            .value()
            .mapError { (err: AFError) in
                return err as Error
            }
            .eraseToAnyPublisher()
    }

    /// 이달의 신곡 정보들을 불러옵니다.
    /// - Returns: newMonthInfo
    func fetchNewMonthSong() -> AnyPublisher<newMonthInfo, Error> {
        let url = ApiCollections.newMonthly

        return AF.request(url)
            .validate(statusCode: 200..<300)
            .publishDecodable(type: newMonthInfo.self)
            .value()
            .mapError { (err: AFError) in
                return err as Error
            }
            .eraseToAnyPublisher()
    }

    /// 뉴스 정보를 불러옵니다.
    /// - Returns: [NewsModel]
    func fetchNews() -> AnyPublisher<[NewsModel], Error> {
        let url = ApiCollections.news

        return AF.request(url)
            .validate(statusCode: 200..<300)
            .publishDecodable(type: [NewsModel].self)
            .value()
            .mapError { (err: AFError) in
                return err as Error
            }
            .eraseToAnyPublisher()
    }

    /// 아티스트 정보들을 불러옵니다.
    /// - Returns: [Artist]
    func fetchArtists() -> AnyPublisher<[Artist], Error> {
        let url = ApiCollections.artist

        return AF.request(url)
            .validate(statusCode: 200..<300)
            .publishDecodable(type: [Artist].self)
            .value()
            .mapError { (err: AFError) in
                return err as Error
            }
            .eraseToAnyPublisher()
    }

    /// 해당 아티스트의 곡 정보들을 불러옵니다.
    /// - Parameter name: 아티스트의 이름
    /// - Returns [NewSong]
    func fetchSearchSongsList(_ name: String) -> AnyPublisher<[NewSong], Error> {
        let url = ApiCollections.albums + name

        return AF.request(url)
            .validate(statusCode: 200..<300)
            .publishDecodable(type: [NewSong].self)
            .value()
            .mapError { (err: AFError) in
                return err as Error
            }
            .eraseToAnyPublisher()
    }

    /// keyword로 검색한 곡 정보들을 불러옵니다.
    /// - Parameter keyword: 검색한 내용
    /// - Returns [NewSong]
    func fetchSearchWithKeyword(_ keyword: String) -> AnyPublisher<[NewSong], Error> {
        let url = ApiCollections.searchTitleOrArtiest + keyword
        let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! // 한글로 인한 인코딩
        
        return  AF.request(encodedUrl)
            .validate(statusCode: 200..<300)
            .publishDecodable(type: [NewSong].self)
            .value()
            .mapError { (err: AFError) in
                return err as Error
            }
            .eraseToAnyPublisher()
    }

}
