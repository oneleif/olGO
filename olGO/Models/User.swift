//
//  User.swift
//  olGO
//
//  Created by Zach Eriksen on 10/26/19.
//  Copyright © 2019 oneleif. All rights reserved.
//

import Foundation

struct SocialInformation: Codable {
    var id: Int?
    var username: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var discordUsername: String = ""
    var githubUsername: String = ""
    var tags: [String] = []
    var profileImage: String = ""
    var biography: String = ""
    var links: [String] = []
    var location: String = ""
}

class User: Codable {
    var id: Int?
    // Auth Information
    var email: String
    var password: String
    // Social Information
    var social: SocialInformation?
    
    init(id: Int? = nil, email: String, password: String) {
        self.id = id
        self.email = email
        self.password = password
    }
}
