//
//  PostItem.swift
//  olGO
//
//  Created by Zach Eriksen on 10/26/19.
//  Copyright © 2019 oneleif. All rights reserved.
//

import Foundation

struct PostItem: Codable {
    var id: Int?
    var title: String
    var description: String
    var author: Int
    var tags: [String]
    var url: String
    var content: String
}
