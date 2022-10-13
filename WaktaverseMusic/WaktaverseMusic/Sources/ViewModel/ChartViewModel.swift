//
//  ChartViewModel.swift
//  WaktaverseMusic
//
//  Created by YoungK on 2022/10/02.
//

import Foundation
import Combine

final class ChartViewModel: ObservableObject {
    @Published var currentShowCharts: [RankedSong] = [RankedSong]()
    @Published var updateTime: Int = 0
    var subscription = Set<AnyCancellable>()

    deinit {
        clearCache()
        print("❌ ChartViewModel deinit")
    }

    func fetchChart(_ category: TopCategory) {
        Repository.shared.fetchTopRankedSong(category: category).sink { completion in
            switch completion {
            case .failure(let err):
                print(#file, #function, #line, err.localizedDescription)

            case .finished:
                print(#function, "Finish")
            }
        } receiveValue: { [weak self] (data: [RankedSong]) in
            guard let self = self else {return}
            self.currentShowCharts = data
        }.store(in: &subscription)

    }

    func fetchUpdateTime(_ category: TopCategory) { // 카데고리 사라짐 
        Repository.shared.fetchUpdateTimeStmap(category: category).sink { completion in
            switch completion {
            case .failure(let err):
                print(#file, #function, #line, err.localizedDescription)

            case .finished:
                print(#function, "Finish")
            }
        } receiveValue: { [weak self] time in
            guard let self = self else {return}
            self.updateTime = time
        }.store(in: &subscription)

    }
}
