import Foundation

struct AccessTokenResponse: Codable {
    let accessToken: String
    let refreshToken: String
    let expiresAt: Date
}


