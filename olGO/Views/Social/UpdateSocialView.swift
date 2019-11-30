//
//  UpdateSocialView.swift
//  olGO
//
//  Created by Zach Eriksen on 11/30/19.
//  Copyright © 2019 oneleif. All rights reserved.
//

import UIKit
import SwiftUIKit


class UpdateSocialView: UIView {
    
    init(social: SocialInformation) {
        super.init(frame: .zero)
        
        embed {
            
            VStack(distribution: .fillEqually) {
                [
                    Spacer(),
                    Field(value: "\(social.username)", placeholder: "Username", keyboardType: .default),
                    Field(value: "\(social.firstName)", placeholder: "First Name", keyboardType: .default),
                    Field(value: "\(social.lastName)", placeholder: "Last Name", keyboardType: .default),
                    Field(value: "\(social.email)", placeholder: "Email", keyboardType: .emailAddress),
                    Field(value: "\(social.discordUsername)", placeholder: "Discord Username", keyboardType: .default),
                    Field(value: "\(social.githubUsername)", placeholder: "GitHub Username", keyboardType: .default),
                    Field(value: "\(social.tags)", placeholder: "Tag (CSV ex: web, backend, vapor, api)", keyboardType: .default),
                    Field(value: "\(social.profileImage)", placeholder: "Profile Image URL", keyboardType: .default),
                    Field(value: "\(social.biography)", placeholder: "Biography", keyboardType: .default),
                    Field(value: "\(social.links)", placeholder: "Links (CSV)", keyboardType: .default),
                    Field(value: "\(social.location)", placeholder: "Location", keyboardType: .default),
                    Spacer(),
                    Button("Save",titleColor: .blue) {
                        print("Update")
                    }
                ]
            }
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
