//
//  SocialView.swift
//  olGO
//
//  Created by Zach Eriksen on 11/30/19.
//  Copyright © 2019 oneleif. All rights reserved.
//

import UIKit
import SwiftUIKit


class SocialView: UIView {
    
    init(social: SocialInformation) {
        super.init(frame: .zero)
        
        embed {
            
            VStack(distribution: .fillEqually) {
                [
                    Spacer(),
                    Label("\(social.id)"),
                    Label("\(social.username)"),
                    Label("\(social.firstName)"),
                    Label("\(social.lastName)"),
                    Label("\(social.email)"),
                    Label("\(social.discordUsername)"),
                    Label("\(social.githubUsername)"),
                    Label("\(social.tags)"),
                    Label("\(social.profileImage)"),
                    Label("\(social.biography)"),
                    Label("\(social.links)"),
                    Label("\(social.location)"),
                    Spacer(),
                    NavButton("Update Social",
                              destination: UIViewController {
                                View {
                                    UpdateSocialView(social: social)
                                }
                        },
                              style: .modal,
                              titleColor: .blue)
                ]
            }
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
