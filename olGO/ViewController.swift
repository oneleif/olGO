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
        View {
            RegisterView()
        }
    }
    
    var loginView: View  {
        View {
            LoginView()
        }
    }
    
    var logoutView: View {
        View {
            LogoutView()
        }
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

