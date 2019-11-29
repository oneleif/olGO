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
                guard !self.isRequesting else {
                    return
                }
                self.isRequesting = true
                self.bag.append(API.instance.logout()
                    .sink(receiveCompletion: { (result) in
                        self.isRequesting = false
                        print(result)
                    }) { (data, response) in
                        print("Logout")
                })
                
            }
            .frame(height: 60)
            .padding()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
