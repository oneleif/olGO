//
//  AddPostView.swift
//  olGO
//
//  Created by Zach Eriksen on 11/30/19.
//  Copyright © 2019 oneleif. All rights reserved.
//

import UIKit
import SwiftUIKit
import Combine

class AddPostView: UIView {
    private var bag: [AnyCancellable] = []
    
    private var isRequesting: Bool = false
    private var post: PostItem?
    
    private var postTitle: String?
    private var postDescription: String?
    private var postAuthor: Int? // Get from the user object
    private var postTags: [String]?
    private var postUrl: String?
    private var postContent: String?
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        embed {
            VStack {
                [
                    
                    Label.title1("Add A Post")
                        .frame(height: 80),
                    VStack(distribution: .fillEqually) {
                        [
                            Field(value: "", placeholder: "Title (ex: How to create a Post)", keyboardType: .default),
                            Field(value: "", placeholder: "Description", keyboardType: .default),
                            Field(value: "", placeholder: "Tags (CSV ex: api, web, backend)", keyboardType: .default),
                            Field(value: "", placeholder: "URL", keyboardType: .default),
                            Field(value: "", placeholder: "Content", keyboardType: .default)
                        ]
                    },
                    Button("Add Post", titleColor: .blue) {
                        self.addPost()
                    }
                    .frame(height: 60)
                ]
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addPost() {
        guard !self.isRequesting else {
                return
        }
        self.isRequesting = true
        
        
        guard let title = postTitle,
                let description = postDescription,
            let author = postAuthor,
            let tags = postTags,
            let url = postUrl,
            let content = postContent else {
                return
        }
        
        let post = PostItem(title: title,
                            description: description,
                            author: author,
                            tags: tags,
                            url: url,
                            content: content)
        
        self.bag.append(API.instance.add(post: post).sink(receiveCompletion: { (result) in
            
            self.isRequesting = false
            if case .failure(let error) = result {
                print(error.localizedDescription)
            }
            
        }) { (data, response) in
            
            guard let response = response as? HTTPURLResponse else {
                return
            }
            
            print("Add Post Response Status Code: \(response.statusCode)")
            
            if 200 ... 300 ~= response.statusCode {
                DispatchQueue.main.async {
                    Navigate.shared.go(UIViewController {
                        View(backgroundColor: .white) {
                            Label("You added a post!")
                        }
                    }, style: .modal)
                }
            }
        })
        
    }
}
