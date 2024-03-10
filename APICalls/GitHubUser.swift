//
//  GitHubUser.swift
//  APICalls
//
//  Created by Vladyslav Dikhtiaruk on 10/03/2024.
//

import Foundation


struct GitHubUser: Codable { // decoding - downoloading data from json, encodable - uploading data
    let login: String
//    let avatar_url: String // it's snake case, in swift we use camel case
    let avatarUrl: String // later i will use decoder with property .convertFromSnakeCase
    let bio: String
    
}

