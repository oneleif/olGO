//
//  LogoutView.swift
//  olGO
//
//  Created by Zach Eriksen on 11/29/19.
//  Copyright © 2019 oneleif. All rights reserved.
//

import UIKit
import SwiftUIKit
import Combine

class LogoutView: UIView {
    private var bag: [AnyCancellable] = []
    
    private var isRequesting: Bool = false
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        embed {
            Button("Logout", titleColor: .blue) {
                self.logout()
            }
            .padding()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func logout() {
        guard !self.isRequesting else {
            return
        }
        self.isRequesting = true
        self.bag.append(API.instance.logout()
            .sink(receiveCompletion: { (result) in
                DispatchQueue.main.async {

                    Navigate.shared.set(title: "This is something")
                    Navigate.shared.alert(title: "You have been logged out..", message: "We are sorry", withActions: [.dismiss])
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        Navigate.shared.dismiss()
                    }
                }
                
                self.isRequesting = false
                if case .failure(let error) = result {
                    print(error.localizedDescription)
                }
                
            }) { (data, response) in
                
                guard let response = response as? HTTPURLResponse else {
                    return
                }
                
                print("Logout Response Status Code: \(response.statusCode)")
                
        })
    }
}
