struct ErrorResponse: Codable {
    /// Always `true` to indicate this is a non-typical JSON response.
    var error: Bool

    /// The reason for the error.
    var reason: String
}

