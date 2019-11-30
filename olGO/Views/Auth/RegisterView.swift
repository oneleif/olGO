//
//  RegisterView.swift
//  olGO
//
//  Created by Zach Eriksen on 11/29/19.
//  Copyright © 2019 oneleif. All rights reserved.
//

import UIKit
import SwiftUIKit
import Combine

class RegisterView: UIView {
    private var username: String = ""
    private var password: String = ""
    private var bag: [AnyCancellable] = []
    
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
                        self.register()
                    }
                    .frame(height: 60),
                    Spacer()
                ]
            }
            .padding()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func register() {
        guard !self.isRequesting else {
            return
        }
        self.isRequesting = true
        self.bag.append(API.instance.register(user: User(username: self.username,
                                                         password: self.password))
            .sink(receiveCompletion: { (result) in
                self.isRequesting = false
                if case .failure(let error) = result {
                    print(error.localizedDescription)
                }
            }) { (data, response) in
                guard let response = response as? HTTPURLResponse else {
                    return
                }
                
                print("Register Response Status Code: \(response.statusCode)")
                
                if 200 ... 300 ~= response.statusCode {
                    DispatchQueue.main.async {
                        Navigate.shared.go(UIViewController {
                            LoginView()
                        }, style: .push)
                    }
                }
                
        })
    }
}

