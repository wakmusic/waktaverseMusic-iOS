//
//  Artist.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/08/13.
//

import Foundation

struct Artist: Codable,Identifiable, Equatable {
    let id = UUID()
    let artistId, name: String
    let artistGroup: ArtistGroup
    let card: String
    let big: String
    //let youtube, twitch,String?
    
    static func == (lhs:Self,rhs:Self) -> Bool {
        return lhs.artistId == rhs.artistId
    }
    
    private enum CodingKeys: String,CodingKey {
        case artistId = "id"
        case name,card,big
        case artistGroup = "group"
       
        
    }

}

enum ArtistGroup: String, Codable {
    case ghost = "ghost"
    case gomem = "gomem"
    case isedol = "isedol"
    case woowakgood = "woowakgood"
}
