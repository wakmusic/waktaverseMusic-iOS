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

    func fetchChart(_ category: TopCategory) {
        Repository.shared.fetchTop100(category: category).sink { _ in

        } receiveValue: { [weak self] (data: [RankedSong]) in

            guard let self = self else {return}

            self.currentShowCharts = data

        }.store(in: &subscription)

    }

    func fetchUpdateTime(_ category: TopCategory) {
        Repository.shared.fetchUpdateTimeStmap(category: category).sink { _ in

        } receiveValue: { [weak self] time in

            guard let self = self else {return}

            self.updateTime = time
        }.store(in: &subscription)

    }
}
