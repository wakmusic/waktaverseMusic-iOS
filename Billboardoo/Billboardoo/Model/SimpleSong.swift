//
//  SimpleViwer.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/07/20.
//

import Foundation

struct SimpleSong : Codable , Identifiable, Equatable{
    let id = UUID()
    let song_id: String
    let title: String
    let artist: String
    let image: String
    let url: String
    let last: Int
    
    static func == (lhs:Self,rhs:Self) -> Bool {
        return lhs.song_id == rhs.song_id
    }
    
    private enum CodingKeys: String,CodingKey {
        case song_id = "id"
        case title,artist,image,url,last
    }
}

