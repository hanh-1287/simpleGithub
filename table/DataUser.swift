//
//  File.swift
//  table
//
//  Created by Huy Hà on 7/28/22.
//

import Foundation

struct Users : Decodable {
    var items : [SearchUser]
}
struct SearchUser : Decodable {
    var login: String
    var avatar_url : String
    var url : String
    var html_url : String
    var followers_url : String
    var following_url: String
    
    enum CodingKeys: String, CodingKey {
        case login = "login"
        case avatar_url = "avatar_url"
        case url =  "url"
        case html_url = "html_url"
        case followers_url =  "followers_url"
        case following_url =  "following_url"
     }
}
