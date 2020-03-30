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
        
        let profileImageURL = URL(string: social.profileImage)
        
        embed {
            
            VStack {
                [
                    VStack(withSpacing: 8) {
                        [
                            profileImageURL.map { url in
                                LoadingImage(url)
                                    .contentMode(.scaleAspectFit)
                                    .frame(height: 168)
                                    .configure { $0.isHidden = !UIApplication.shared.canOpenURL(url) }
                                    .layer { $0.cornerRadius = 8 }
                            },
                            Label.title3("\(social.firstName) \(social.lastName)"),
                            Label.headline("\(social.email)"),
                            Label.subheadline("Location: \(social.location)"),
                            
                            Divider(),
                            
                            HStack {
                                [
                                    Label.callout("Discord: \(social.discordUsername)"),
                                    Label.callout("GitHub: \(social.githubUsername)")
                                ]
                            },
                            Label.subheadline("Interests: \(social.tags.joined(separator: " "))"),
                            Label.caption1("Links: \(social.links.joined(separator: " "))"),
                            
                            Divider(),
                            
                            Label.body("\(social.biography)"),
                            
                            Spacer()
                        ]
                    }
                    
                ]
            }
            .navigateSet(title: social.username)
            .navigateSetRight(barButton: UIBarButtonItem(customView:
                NavButton("Edit",
                          destination: UIViewController {
                            UIView {
                                UpdateSocialView(social: social)
                            }
                    },
                          style: .modal,
                          titleColor: .blue)))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
