//
//  LoginView.swift
//  olGO
//
//  Created by Zach Eriksen on 11/29/19.
//  Copyright © 2019 oneleif. All rights reserved.
//

import SwiftUI
import SwiftUIKit
import Combine

struct LoginView: View {
    @State var email: String = ""
    @State var password: String = ""
    @State var showingAlert = false
    @State private var bag = CancelBag()
    @State private var isRequesting: Bool = false
    
    var body: some View {
        let cornerRadius: CGFloat = 10
        
        return VStack {
            HStack {
                Image("oneleifgoodlogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .cornerRadius(cornerRadius)
                Text("Sign Up for OneLeif!")
                    .font(.title)
                    .fontWeight(.bold)
            }
            .padding(.top, 10)
            
            HStack {
                Text("Email:       ")
                TextField(" \"John@gmail.com\" ", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            HStack {
                Text("Password:")
                SecureField("Abc123", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            Button(action: { self.login() }, label: { Text("Login")})
                .alert(isPresented: $showingAlert, content: {
                    Alert( title: Text("Error"),
                           message: Text("Password or Email incorrect"),
                           dismissButton: .default(Text("Dismiss")))})
                .font(.headline)
                .padding(.vertical, 10)
                .padding(.horizontal)
                .foregroundColor(.white)
                .background(Color.blue)
            .clipShape( Capsule() )
        }
        .frame(
            minWidth: 350,
            idealWidth: 400,
            maxWidth: 450,
            minHeight: 500,
            idealHeight: 600,
            maxHeight: 700,
            alignment: .center)
            .cornerRadius(cornerRadius)
            .padding(.horizontal, 10)
            .padding(.bottom, 100)
    }
    
    
    private func login() {
        guard !self.isRequesting else {
            return
        }
        self.isRequesting = true
      
        API.instance.login(user: User(username: self.email,
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
                
                print("Login Response Status Code: \(response.statusCode)")
                
                if 200 ... 300 ~= response.statusCode {
                    DispatchQueue.main.async {
                        Navigate.shared.go(UIViewController {
                                            UIView(backgroundColor: .white) {
                                                Label("You are logged in")
                                            }
                        }, style: .modal)
                    }
                }
        }
        .canceled(by: &self.bag)
    }
}
