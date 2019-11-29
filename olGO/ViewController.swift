//
//  ViewController.swift
//  olGO
//
//  Created by Zach Eriksen on 11/14/19.
//  Copyright © 2019 oneleif. All rights reserved.
//

import UIKit
import SwiftUIKit
import Combine

class ViewController: UIViewController {
    private var username: String = ""
    private var password: String = ""
    private var bag: [AnyCancellable] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        Navigate.shared.configure(controller: navigationController)
        
        view.embed {
            SafeAreaView {
                Table(defaultCellHeight: 44) {
                    [
                        Label("Auth Calls"),
                        NavButton("Register",
                                  destination: UIViewController { View(backgroundColor: .white) { self.registerView } },
                                  style: .push)
                            .configure { $0.setTitleColor(.blue, for: .normal) },
                        NavButton("Login",
                                  destination: UIViewController { View(backgroundColor: .white) { self.loginView } },
                                  style: .push)
                            .configure { $0.setTitleColor(.blue, for: .normal) },
                        
                        NavButton("Logout",
                                  destination: UIViewController { View(backgroundColor: .white) { self.logoutView } },
                                  style: .push)
                            .configure { $0.setTitleColor(.blue, for: .normal) },
                        
                        Label("Post Calls"),
                        
                        allPostButton
                        
                    ]
                }
                .configureCell { $0.selectionStyle = .none }
            }
        }
        
    }
    
    
    var registerView: View {
        VStack(distribution: .equalCentering) {
            [
                Spacer(),
                VStack {
                    [
                        Field(value: "", placeholder: "Username", keyboardType: .default)
                            .inputHandler { (value) in
                                self.username = value
                        }
                        .frame(height: 60),
                        Field(value: "", placeholder: "Password", keyboardType: .default)
                            .configure {
                                $0.isSecureTextEntry = true
                        }
                        .inputHandler { (value) in
                            self.password = value
                        }
                        .frame(height: 60)
                    ]
                },
                Button("Register", titleColor: .blue) {
                    self.bag.append(API.instance.register(user: User(username: self.username,
                                                                     password: self.password))
                        .sink(receiveCompletion: { (result) in
                            switch result {
                            case .failure(let error):
                                print(error.localizedDescription)
                            case .finished:
                                DispatchQueue.main.async {
                                    Navigate.shared.go(from: self,
                                                       to: UIViewController {
                                                        View(backgroundColor: .white) {
                                                            self.loginView
                                                        }
                                    }, style: .push)
                                }
                            }
                        }) { (data, response) in
                            print("Attempt Log in")
                    })
                }
                .frame(height: 60),
                Spacer()
            ]
        }.padding()
    }
    
    var loginView: View {
        VStack(distribution: .equalCentering) {
            [
                Spacer(),
                VStack {
                    [
                        Field(value: "", placeholder: "Username", keyboardType: .default)
                            .inputHandler { (value) in
                                self.username = value
                        }
                        .frame(height: 60),
                        Field(value: "", placeholder: "Password", keyboardType: .default)
                            .configure {
                                $0.isSecureTextEntry = true
                        }
                        .inputHandler { (value) in
                            self.password = value
                        }
                        .frame(height: 60)
                    ]
                },
                Button("Login", titleColor: .blue) {
                    self.bag.append(API.instance.login(user: User(username: self.username,
                                                                  password: self.password))
                        .sink(receiveCompletion: { (result) in
                            switch result {
                            case .failure(let error):
                                print(error.localizedDescription)
                            case .finished:
                                DispatchQueue.main.async {
                                    Navigate.shared.go(from: self,
                                                       to: UIViewController {
                                                        View(backgroundColor: .white) {
                                                            Label("You are logged in")
                                                        }
                                    }, style: .push)
                                }
                            }
                        }) { (data, response) in
                            print("Attempt Log in")
                    })
                }
                .frame(height: 60),
                Spacer()
            ]
        }.padding()
    }
    
    var logoutView: View {
        Button("Logout", titleColor: .blue) {
            self.bag.append(API.instance.logout()
                .sink(receiveCompletion: { (result) in
                    print(result)
                }) { (data, response) in
                    print("Logout")
            })
            
        }
        .frame(height: 60)
        .padding()
    }
    
    var allPostButton: Button {
        Button("Load All Posts", titleColor: .blue, forEvent: .touchUpInside) {
            self.bag.append(API.instance.allPosts().sink(receiveCompletion: { (completion) in
                print(completion)
            }) { (data, response) in
                guard let posts = try? JSONDecoder().decode([PostItem].self, from: data) else {
                    print(response)
                    return
                }
                DispatchQueue.main.async {
                     Navigate.shared.go(UIViewController { View {
                         Table {
                             posts.map { post in
                                 View {
                                     VStack {
                                         [
                                             Label(post.title),
                                             Label(post.content)
                                         ]
                                     }
                                 }
                             }
                         }
                         }
                         
                     }, style: .push)
                }
                
            })
        }
    }
}

