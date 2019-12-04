//
//  UpdateSocialView.swift
//  olGO
//
//  Created by Zach Eriksen on 11/30/19.
//  Copyright © 2019 oneleif. All rights reserved.
//

import UIKit
import SwiftUIKit
import Combine


class UpdateSocialView: UIView {
    private var bag = CancelBag()
    
    private var isRequesting: Bool = false
    
    private var socialUsername: String?
    private var socialFirstName: String?
    private var socialLastName: String?
    private var socialEmail: String?
    private var socialDiscord: String?
    private var socialGithub: String?
    private var socialTags: [String]?
    private var socialProfileImage: String?
    private var socialBiography: String?
    private var socialLinks: [String]?
    private var socialLocation: String?
    
    init(social: SocialInformation) {
        super.init(frame: .zero)
        
        embed {
            
            VStack(distribution: .fillEqually) {
                [
                    Spacer(),
                    Field(value: "\(social.username)", placeholder: "Username", keyboardType: .default)
                        .inputHandler { self.socialUsername = $0 },
                    Field(value: "\(social.firstName)", placeholder: "First Name", keyboardType: .default)
                        .inputHandler { self.socialFirstName = $0 },
                    Field(value: "\(social.lastName)", placeholder: "Last Name", keyboardType: .default)
                        .inputHandler { self.socialLastName = $0 },
                    Field(value: "\(social.email)", placeholder: "Email", keyboardType: .emailAddress)
                        .inputHandler { self.socialEmail = $0 },
                    Field(value: "\(social.discordUsername)", placeholder: "Discord Username", keyboardType: .default)
                        .inputHandler { self.socialDiscord = $0 },
                    Field(value: "\(social.githubUsername)", placeholder: "GitHub Username", keyboardType: .default)
                        .inputHandler { self.socialGithub = $0 },
                    Field(value: "\(social.tags)", placeholder: "Tag (CSV ex: web, backend, vapor, api)", keyboardType: .default)
                        .inputHandler { self.socialTags = $0.replacingOccurrences(of: " ,", with: ",").replacingOccurrences(of: ", ", with: ",").split(separator: ",").map { String($0) } },
                    Field(value: "\(social.profileImage)", placeholder: "Profile Image URL", keyboardType: .default)
                        .inputHandler { self.socialProfileImage = $0 },
                    Field(value: "\(social.biography)", placeholder: "Biography", keyboardType: .default)
                        .inputHandler { self.socialBiography = $0 },
                    Field(value: "\(social.links)", placeholder: "Links (CSV)", keyboardType: .default)
                        .inputHandler { self.socialLinks = $0.replacingOccurrences(of: " ,", with: ",").replacingOccurrences(of: ", ", with: ",").split(separator: ",").map { String($0) } },
                    Field(value: "\(social.location)", placeholder: "Location", keyboardType: .default)
                        .inputHandler { self.socialLocation = $0 },
                    Spacer(),
                    Button("Save",titleColor: .blue) {
                        API.instance.update(social: SocialInformation(id: social.id,
                                                                      username: self.socialUsername ?? social.username,
                                                                      firstName: self.socialFirstName ?? social.firstName,
                                                                      lastName: self.socialLastName ?? social.lastName,
                                                                      email: self.socialEmail ?? social.email,
                                                                      discordUsername: self.socialDiscord ?? social.discordUsername,
                                                                      githubUsername: self.socialGithub ?? social.githubUsername,
                                                                      tags: self.socialTags ?? social.tags,
                                                                      profileImage: self.socialProfileImage ?? social.profileImage,
                                                                      biography: self.socialBiography ?? social.biography,
                                                                      links: self.socialLinks ?? social.links,
                                                                      location: self.socialLocation ?? social.location))
                            .sink(receiveCompletion: { result in
                                if case .failure(let error) = result {
                                    print(error.localizedDescription)
                                }
                            }) { (data: Data, response: URLResponse) in
                                
                                guard let response = response as? HTTPURLResponse else {
                                    return
                                }
                                
                                print("Update Social Response Status Code: \(response.statusCode)")
                        }
                        .canceled(by: &self.bag)
                    }
                ]
            }
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
