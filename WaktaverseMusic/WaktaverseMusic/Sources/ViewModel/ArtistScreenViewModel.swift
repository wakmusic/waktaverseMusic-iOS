//
//  ArtistScreenViewModel.swift
//  WaktaverseMusic
//
//  Created by YoungK on 2022/10/02.
//

import Foundation
import Combine

final class ArtistScreenViewModel: ObservableObject {

    @Published var selectedid: String = "woowakgood"
    @Published var artists: [Artist] = [Artist]()
    @Published var currentShowChart: [NewSong] = [NewSong]()
    var subscription = Set<AnyCancellable>()

    init() {
        fetchArtist()
        fetchSongList("woowakgood")
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

    func fetchSongList(_ name: String) {
        Repository.shared.fetchSearchSongsList(name).sink { _ in

        } receiveValue: { [weak self] (data: [NewSong]) in
            guard let self = self else {return}

            self.currentShowChart = data
        }.store(in: &subscription)

    }

}
