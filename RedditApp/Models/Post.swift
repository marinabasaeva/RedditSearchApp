//
//  Post.swift
//  RedditApp
//
//  Created by Marina Basaeva on 7/20/22.
//

import Foundation

struct TopLevelObject: Decodable {
    let data: SecondLevelObject
}

struct SecondLevelObject: Decodable {
    let children: [ThirdLevelObject]
}

struct ThirdLevelObject: Decodable {
    let data: Post
}

struct Post: Decodable {
    let title: String
    let ups: Int
    let thumbnail: String
}
