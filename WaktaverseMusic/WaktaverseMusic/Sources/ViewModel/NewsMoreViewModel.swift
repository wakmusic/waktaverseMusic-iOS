//
//  NewsMoreViewModel.swift
//  WaktaverseMusic
//
//  Created by YoungK on 2022/10/19.
//

import Foundation
import Combine

final class NewsMoreViewModel: ObservableObject {
    @Published var news: [NewsModel] = [NewsModel]()

    var subscription = Set<AnyCancellable>()

    init() {
        fetchNews()
    }

    deinit {
        print("❌ NewsMoreViewModel deinit")
        // clearCache()
    }

    func fetchNews() {
        Repository.shared.fetchNews(start: news.count).sink { (_) in

        } receiveValue: { [weak self] (data: [NewsModel]) in
            guard let self = self else {return}
            _ = data.map { self.news.append($0) }

        }.store(in: &subscription)
    }
}
