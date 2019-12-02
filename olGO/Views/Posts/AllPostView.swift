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
                posts.map {
                    PostItemView(post: $0)
                }
            }
        .navigateSet(title: "All Posts")
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
