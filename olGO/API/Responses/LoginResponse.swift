//
//  LoginResponse.swift
//  App
//
//  Created by Arkadiusz Żmudzin on 13/03/2020.
//

struct LoginResponse: Codable {
    let token: AccessTokenResponse
    let user: PublicUserResponse
}
