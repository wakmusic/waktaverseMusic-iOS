//
//  TwitchModel.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/08/20.
//

import Foundation

struct TwitchModel: Codable,Identifiable, Equatable {
    let id = UUID()
    let twitchId,display_name,profile_image_url,provider:String
    
    static func == (lhs:Self,rhs:Self) -> Bool {
        return lhs.twitchId == rhs.twitchId
    }
    
    private enum CodingKeys: String,CodingKey {
        case twitchId = "id"
        case display_name,profile_image_url,provider
       
        
    }

}
/*
"id": "아이디",
"login": "로그인 아이디",
"display_name": "닉네임",
"type": "",
"broadcaster_type": "",
"description": "",
"profile_image_url": "프사",
"offline_image_url": "",
"view_count": 5,
"email": "이메일",
"created_at": "2020-02-07T07:26:44Z",
"provider": "twitch",
"accessToken": "",
"refreshToken": ""
 */
