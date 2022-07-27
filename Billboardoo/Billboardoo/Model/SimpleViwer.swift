//
//  SimpleViwer.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/07/20.
//

import Foundation

struct SimpleViwer : Codable , Identifiable{
    let id = UUID()
    let song_id: String
    let title: String
    let artist: String
    let image: String
    let url: String
    let last: Int
    
    private enum CodingKeys: String,CodingKey {
        case song_id = "id"
        case title,artist,image,url,last
    }
}

