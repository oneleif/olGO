//
//  BaseController.swift
//  olGO
//
//  Created by Zach Eriksen on 11/14/19.
//  Copyright © 2019 oneleif. All rights reserved.
//

import UIKit
import SwiftUIKit
import Combine

class BaseController: UIViewController {
    private var username: String = ""
    private var password: String = ""
    private var bag = CancelBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        Navigate.shared.configure(controller: navigationController)
        
        view.embed {
            SafeAreaView {
                Table(defaultCellHeight: 44) {
                    [
                        Label("Auth Calls"),
                        NavButton("Register",
                                  destination: UIViewController { View(backgroundColor: .white) { RegisterView() } },
                                  style: .push)
                            .configure { $0.setTitleColor(.blue, for: .normal) },
                        NavButton("Login",
                                  destination: UIViewController { View(backgroundColor: .white) { LoginView() } },
                                  style: .push)
                            .configure { $0.setTitleColor(.blue, for: .normal) },
                        
                        NavButton("Logout",
                                  destination: UIViewController { View(backgroundColor: .white) { LogoutView() } },
                                  style: .push)
                            .configure { $0.setTitleColor(.blue, for: .normal) },
                        
                        Label("Post Calls"),
                        
                        allPostButton,
                        
                        addPostButton,
                        
                        Label("Social Calls"),
                        
                        socialButton
                        
                    ]
                }
                .configureCell { $0.selectionStyle = .none }
            }
        }
        
    }
    
    var allPostButton: UIView {
        Button("Load All Posts", titleColor: .blue, forEvent: .touchUpInside) {
            API.instance.allPosts().sink(receiveCompletion: { (completion) in
                print(completion)
            }) { posts in
                DispatchQueue.main.async {
                    Navigate.shared.go(ViewController {
                        View {
                            SafeAreaView {
                                AllPostView(posts: posts)
                            }
                        }
                    }, style: .push)
                }
            }
            .canceled(by: &self.bag)
            
        }
    }
    
    var addPostButton: UIView {
        Button("Add Post", titleColor: .blue, forEvent: .touchUpInside) {
            
            Navigate.shared.go(ViewController {
                View {
                    SafeAreaView {
                        AddPostView()
                    }
                }
            }, style: .push)
        }
    }
    
    var socialButton: UIView {
        Button("SocialInformation", titleColor: .blue, forEvent: .touchUpInside) {
            API.instance.social().sink(receiveCompletion: { (completion) in
                print(completion)
            }) { social in
                DispatchQueue.main.async {
                    Navigate.shared.go(UIViewController {
                        View {
                            SafeAreaView {
                                SocialView(social: social)
                            }
                        }
                    }, style: .push)
                }
            }
            .canceled(by: &self.bag)
            
        }
    }
}

