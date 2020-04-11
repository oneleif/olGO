//
//  API.swift
//  olGO
//
//  Created by Zach Eriksen on 10/26/19.
//  Copyright © 2019 oneleif. All rights reserved.
//

import Foundation
import Combine
import FLite

extension URLRequest {
    mutating func dataTaskPublish(method: String = "GET", withBody body: Data? = nil) -> URLSession.DataTaskPublisher {
        var headers = [
            "Content-Type": "application/json; charset=utf-8",
            "cache-control": "no-cache",
        ]
        
        if let token = API.instance.token {
            print("Expires: \(token.expiresAt)")
            headers["Authorization"] = "Bearer \(token.accessToken)"
        }
        
        httpMethod = method
        allHTTPHeaderFields = headers
        if let body = body {
            httpBody = body
        }
        
        let session = URLSession.shared
        return session.dataTaskPublisher(for: self)
    }
}

extension URL {
    func request(forRoute route: API.Route, withID id: Int? = nil) -> URLRequest {
        guard let id = id else {
            return URLRequest(url: appendingPathComponent("/\(route.rawValue)"),
                              cachePolicy: .useProtocolCachePolicy,
                              timeoutInterval: 10.0)
        }
        return URLRequest(url: appendingPathComponent("/\(route.rawValue)/\(id)"),
                          cachePolicy: .useProtocolCachePolicy,
                          timeoutInterval: 10.0)
    }
}

protocol AuthRequesting {
    func register(user: User) -> AnyPublisher<PublicUserResponse, Error>
    func login(user: User) -> AnyPublisher<LoginResponse, Error>
    func logout() -> URLSession.DataTaskPublisher
}

protocol SocialRequesting {
    func social() -> AnyPublisher<SocialInformation, Error>
    func update(social: SocialInformation) -> URLSession.DataTaskPublisher
}

protocol PostRequesting {
    func allPosts() -> AnyPublisher<[PostItem], Error>
    func post(withID id: Int) -> AnyPublisher<PostItem, Error>
    func add(post: PostItem) -> URLSession.DataTaskPublisher
    func update(post: PostItem) -> URLSession.DataTaskPublisher
    func delete(post: PostItem) -> URLSession.DataTaskPublisher
}

protocol ImageRequesting {
    func add(image: Data) -> URLSession.DataTaskPublisher
    func image(named name: String) -> URLSession.DataTaskPublisher
}

class API {
    enum Route: String {
        case register
        case login
        case logout
        case profile
        case posts
        case post
        case social
    }
    
    static var instance: API = {
        FLite.storage = .memory
        
        FLite.prepare(model: User.self)
        
        return API()
    }()
    
    // Configuations
    //    let path = "http://localhost:8080/api"
    let path: String = "https://dev.api.oneleif.com/api"
    
    // Lazy Variables
    lazy var url: URL = URL(string: path)!
    
    // Cached Values
    public var userInfo: SocialInformation?
    
    fileprivate var token: AccessTokenResponse?
}

extension API: AuthRequesting {
    func register(user: User) -> AnyPublisher<PublicUserResponse, Error> {
        let postData = try? JSONEncoder().encode(User(email: user.email,
                                                      password: user.password))
        
        var request = url.request(forRoute: .register)
        
        return request.dataTaskPublish(method: "POST",
                                       withBody: postData)
            .mapError { $0 as Error }
            .compactMap {
                guard let userInfo = try? JSONDecoder().decode(PublicUserResponse.self, from: $0.data) else {
                    return nil
                }
                self.userInfo = userInfo.social
                
                return userInfo
        }
        .eraseToAnyPublisher()
    }
    
    func login(user: User) -> AnyPublisher<LoginResponse, Error> {
        let postData = try? JSONEncoder().encode(User(email: user.email,
                                                      password: user.password))
        
        var request = url.request(forRoute: .login)
        
        return request.dataTaskPublish(method: "POST",
                                       withBody: postData)
            .mapError { $0 as Error }
            .compactMap {
                guard let loginInfo = try? JSONDecoder().decode(LoginResponse.self, from: $0.data) else {
                    return nil
                }
                self.token = loginInfo.token
                
                return loginInfo
        }
            .eraseToAnyPublisher()
    }
    
    func logout() -> URLSession.DataTaskPublisher {
        var request = url.request(forRoute: .logout)
        
        return request.dataTaskPublish()
    }
}

extension API: PostRequesting {
    func allPosts() -> AnyPublisher<[PostItem], Error> {
        var request = url.request(forRoute: .posts)
        
        return request.dataTaskPublish()
            .mapError { $0 as Error }
            .map { $0.data }
            .decode(type: [PostItem].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func post(withID id: Int) -> AnyPublisher<PostItem, Error> {
        var request = url.request(forRoute: .post, withID: id)
        
        return request.dataTaskPublish()
            .mapError { $0 as Error }
            .map { $0.data }
            .decode(type: PostItem.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func add(post: PostItem) -> URLSession.DataTaskPublisher {
        let postData = try? JSONEncoder().encode(post)
        
        var request = url.request(forRoute: .post)
        
        return request.dataTaskPublish(method: "POST",
                                       withBody: postData)
    }
    
    func update(post: PostItem) -> URLSession.DataTaskPublisher {
        let postData = try? JSONEncoder().encode(post)
        
        var request = url.request(forRoute: .post, withID: post.id)
        
        return request.dataTaskPublish(method: "PUT",
                                       withBody: postData)
    }
    
    func delete(post: PostItem) -> URLSession.DataTaskPublisher {
        var request = url.request(forRoute: .post, withID: post.id)
        
        return request.dataTaskPublish(method: "DELETE")
    }
    
}

extension API: SocialRequesting {
    func social() -> AnyPublisher<SocialInformation, Error> {
        var request = url.request(forRoute: .social)
        
        return request.dataTaskPublish()
            .mapError { $0 as Error }
            .map { $0.data }
            .decode(type: SocialInformation.self, decoder: JSONDecoder())
            .map {
                self.userInfo = $0
                return $0
        }
        .eraseToAnyPublisher()
        
    }
    
    func update(social: SocialInformation) -> URLSession.DataTaskPublisher {
        let socialData = try? JSONEncoder().encode(social)
        
        var request = url.request(forRoute: .social)
        
        return request.dataTaskPublish(method: "POST",
                                       withBody: socialData)
    }
}
