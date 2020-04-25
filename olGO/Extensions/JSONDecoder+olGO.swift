//
//  JSONDecoder+olGO.swift
//  olGO
//
//  Created by Zach Eriksen on 4/11/20.
//  Copyright © 2020 oneleif. All rights reserved.
//

import Foundation

extension JSONDecoder {
    static var dateDecoder: JSONDecoder = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(formatter)
        
        return decoder
    }()
}
