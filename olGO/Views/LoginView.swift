//
//  LoginView.swift
//  olGO
//
//  Created by Zach Eriksen on 11/29/19.
//  Copyright © 2019 oneleif. All rights reserved.
//

import UIKit
import SwiftUIKit
import Combine

class LoginView: UIView {
    private var username: String = ""
    private var password: String = ""
    private var bag: [AnyCancellable] = []
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        embed {
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
                                        Navigate.shared.go(UIViewController {
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
