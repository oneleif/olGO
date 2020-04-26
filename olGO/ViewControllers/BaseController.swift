//
//  BaseController.swift
//  olGO
//
//  Created by Zach Eriksen on 11/14/19.
//  Copyright © 2019 oneleif. All rights reserved.
//

import UIKit
import SwiftUIKit
import SwiftUI
import Combine

class BaseController: UIViewController {
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
                                  destination: UIViewController { UIView(backgroundColor: .white) { UIHostingController(rootView: SignUpView()).view } },
                                  style: .push)
                            .configure { $0.setTitleColor(.blue, for: .normal) },
                        NavButton("Login",
                                  destination: UIViewController { UIView(backgroundColor: .white) { LoginView() } },
                                  style: .push)
                            .configure { $0.setTitleColor(.blue, for: .normal) },
                        
                        NavButton("Logout",
                                  destination: UIViewController { UIView(backgroundColor: .white) { LogoutView() } },
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
            API.instance.allPosts()
                .sink(receiveCompletion: { (completion) in
                    DispatchQueue.main.async {
                        self.handle(completion: completion)
                    }
                }) { posts in
                    DispatchQueue.main.async {
                        Navigate.shared.go(ViewController {
                            UIView(backgroundColor: .white) {
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
                UIView(backgroundColor: .white) {
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
                DispatchQueue.main.async {
                    self.handle(completion: completion)
                }
            }) { social in
                DispatchQueue.main.async {
                    Navigate.shared.go(ViewController {
                        UIView(backgroundColor: .white) {
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
    
    private func handle(completion: Subscribers.Completion<Error>) {
        if case .failure(let error) = completion {
            print(error.localizedDescription)
            Navigate.shared.toast(style: .error, secondsToPersist: 3) {
                Label(error.localizedDescription).number(ofLines: 3)
            }
        } else {
            Navigate.shared.toast(style: .success, secondsToPersist: 1) {
                Label("Success!")
            }
        }
    }
}

