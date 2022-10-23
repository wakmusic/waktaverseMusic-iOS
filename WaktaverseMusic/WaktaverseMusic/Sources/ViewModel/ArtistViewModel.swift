//
//  ArtistViewModel.swift
//  WaktaverseMusic
//
//  Created by YoungK on 2022/10/02.
//

import Foundation
import Combine

final class ArtistViewModel: ObservableObject {

    @Published var selectedArtist: String = "woowakgood"
    @Published var artists: [Artist] = [Artist]()
    @Published var currentShowChart: [NewSong] = [NewSong]()
    @Published var selectedIndex: Int = 0
    var selectedSort: String = "new"
    var subscription = Set<AnyCancellable>()

    init() {
        fetchArtist()
        fetchSongList("woowakgood", sort: "new")
    }

    deinit {

        print("❌ ArtistViewModel deinit")
    }

    func fetchArtist() {
        Repository.shared.fetchArtists().sink { _ in

        } receiveValue: { [weak self] (data: [Artist]) in
            guard let self = self else {return}

            self.artists = data.filter { (artist: Artist) in
                artist.artistId != nil // 더미데이터 제거
            }

        }.store(in: &subscription)

    }

    func fetchSongList(_ name: String, sort: String) {
        Repository.shared.fetchSearchSongsList(selectedArtist, start: currentShowChart.count, sort: sort).sink { _ in

        } receiveValue: { [weak self] (data: [NewSong]) in
            guard let self = self else {return}

            _ = data.map { self.currentShowChart.append($0) }
        }.store(in: &subscription)

    }

    func clearSongList() {
        self.currentShowChart = []
    }

}
