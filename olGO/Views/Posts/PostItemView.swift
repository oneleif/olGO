//
//  PostItemView.swift
//  olGO
//
//  Created by Zach Eriksen on 12/1/19.
//  Copyright © 2019 oneleif. All rights reserved.
//

import UIKit
import SwiftUIKit

class PostItemView: UIView {
    
    init(post: PostItem) {
        super.init(frame: .zero)
        
        embed {
            NavButton(destination: UIViewController { View { PostDetailView(post: post) } },
                      style: .push) {
                        VStack(distribution: .fillEqually) {
                            [
                                Label.title1(post.title),
                                Label.body(post.description),
                                Label.callout("Tags: \(post.tags.map { $0 }.joined(separator: ", "))")
                                    .configure { $0.isHidden = post.tags.isEmpty }
                            ]
                        }
                        .padding()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
