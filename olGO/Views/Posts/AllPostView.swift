//
//  AllPostView.swift
//  olGO
//
//  Created by Zach Eriksen on 11/30/19.
//  Copyright © 2019 oneleif. All rights reserved.
//

import UIKit
import SwiftUIKit


class AllPostView: UIView {
    
    init(posts: [PostItem]) {
        super.init(frame: .zero)
        
        embed {
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
