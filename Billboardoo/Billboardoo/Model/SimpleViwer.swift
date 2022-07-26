//
//  SimpleViwer.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/07/20.
//

import Foundation

struct SimpleViwer : Codable , Identifiable{
    let id: String
    let title: String
    let artist: String
    let image: String
    let url: String
    let last: Int
}

