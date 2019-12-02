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
            VStack {
                [
                    Label(post.title),
                    Label(post.content)
                ]
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
