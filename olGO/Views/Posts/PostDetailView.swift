//
//  PostDetailView.swift
//  olGO
//
//  Created by Zach Eriksen on 12/2/19.
//  Copyright © 2019 oneleif. All rights reserved.
//

import UIKit
import SwiftUIKit

class PostDetailView: UIView {
    
    init(post: PostItem) {
        super.init(frame: .zero)
        
        embed {
            SafeAreaView {
                VStack {
                    [
                        VStack(distribution: .fillEqually) {
                            [
                                Label.title1(post.title),
                                Label.body(post.description),
                                Label.callout("Tags: \(post.tags.map { $0 }.joined(separator: ", "))")
                                    .configure { $0.isHidden = post.tags.isEmpty }
                            ]
                        },
                        Label.body(post.content).configure { $0.numberOfLines = 100 },
                    ]
                }
                .padding()
            }
            .navigateSetRight(barButton: UIBarButtonItem(customView: Button("Edit", titleColor: .blue) { print("Edit") }))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
