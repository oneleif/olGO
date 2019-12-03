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
    private var bag = CancelBag()
    
    private var isRequesting: Bool = false
    private var post: PostItem?
    
    private var postTitle: String = ""
    private var postDescription: String = ""
    private var postTags: [String] = []
    private var postUrl: String = ""
    private var postContent: String = ""
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        
        embed {
            VStack {
                [
                    
                    Label.title1("Add A Post")
                        .frame(height: 80),
                    VStack(withSpacing: 16) {
                        [
                            VStack(withSpacing: 16, distribution: .fillEqually) {
                                [
                                    Field(value: "", placeholder: "Title (ex: How to create a Post)", keyboardType: .default)
                                        .inputHandler {  self.postTitle = $0 },
                                    Field(value: "", placeholder: "Description", keyboardType: .default)
                                        .inputHandler { self.postDescription = $0 },
                                    Field(value: "", placeholder: "Tags (CSV ex: api, web, backend)", keyboardType: .default)
                                        .inputHandler { self.postTags = $0.replacingOccurrences(of: " ", with: "").split(separator: ",").map { String($0) } },
                                    Field(value: "", placeholder: "URL", keyboardType: .default)
                                        .inputHandler { self.postUrl = $0 },
                                    ]
                                    .map {
                                        $0
                                            .padding()
                                            .layer {
                                                $0.borderWidth = 1
                                                $0.borderColor = UIColor.darkGray.cgColor
                                                $0.cornerRadius = 8
                                        }
                                        
                                }
                            },
                            Label("Post Content"),
                            MultiLineField(value: "", keyboardType: .default)
                                .inputHandler { self.postContent = $0 }
                                .frame(height: 200)
                                .padding()
                                .layer {
                                    $0.borderWidth = 1
                                    $0.borderColor = UIColor.darkGray.cgColor
                                    $0.cornerRadius = 8
                            }
                            
                        ]
                        
                    }
                ]
            }
        .navigateSet(title: "Add Post")
        .navigateSetRight(barButton: UIBarButtonItem(customView: Button("Add Post", titleColor: .blue) {
            self.addPost()
        }))
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
        
        
        guard let author = API.instance.userInfo?.id else {
            self.isRequesting = false
            return
        }
        
        let post = PostItem(title: postTitle,
                            description: postDescription,
                            author: author,
                            tags: postTags,
                            url: postUrl,
                            content: postContent)
        
        API.instance.add(post: post)
            .sink(receiveCompletion: { (result) in
            
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
        }
        .canceled(by: &self.bag)
        
    }
}
