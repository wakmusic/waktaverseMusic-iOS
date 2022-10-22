//
//  SimpleSong.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/08/11.
//

import Foundation

struct SimpleSong: Codable, Identifiable, Equatable {
    let id = UUID()
    let song_id: String
    let title: String
    let artist: String

    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.song_id == rhs.song_id
    }

    private enum CodingKeys: String, CodingKey {
        case song_id = "id"
        case title, artist
        // case viewsOfficial = "views_official"

    }
}
