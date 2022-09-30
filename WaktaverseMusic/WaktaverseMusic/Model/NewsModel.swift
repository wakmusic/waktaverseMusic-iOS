//
//  NewsModel.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/08/12.
//

import Foundation



struct NewsModel: Codable, Identifiable, Equatable {
    
    let id = UUID()
    let newsId:Int
    let title: String
    let time: Int
    
    
    static func == (lhs:Self,rhs:Self) -> Bool {
        return lhs.newsId == rhs.newsId
    }
    
    private enum CodingKeys: String,CodingKey {
        case newsId = "id"
        case title,time
       
        
    }
}
