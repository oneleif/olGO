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
    private var bag = CancelBag()
    
    private var email: String = ""
    private var password: String = ""
    
    private var isRequesting: Bool = false
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        embed {
            VStack(distribution: .equalCentering) {
                [
                    Spacer(),
                    VStack {
                        [
                            Field(value: "", placeholder: "Email", keyboardType: .emailAddress)
                                .inputHandler { (value) in
                                    self.email = value
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
                        self.login()
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
    
    private func login() {
        guard !self.isRequesting else {
            return
        }
        self.isRequesting = true
        
        API.instance.login(user: User(email: self.email,
                                      password: self.password))
            .sink(receiveCompletion: { (result) in
                
                self.isRequesting = false
                if case .failure(let error) = result {
                    print(error.localizedDescription)
                }
                
            }, receiveValue: { (response) in
                print(response)
                
                DispatchQueue.main.async {
                    Navigate.shared.go(UIViewController {
                        UIView(backgroundColor: .white) {
                            Label("You are logged in")
                        }
                    }, style: .modal)
                }
            })
            .canceled(by: &bag)
    }
}
