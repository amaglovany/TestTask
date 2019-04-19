//
//  Contributor.swift
//  GitTest
//
//  Created by Developer on 4/19/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit

class Contributor: NSObject, Codable {
    let id:             Int
    let login:          String
    let node_id:        String
    let avatar_url:     String?
    let gravatar_id:    String?
    let url:            String?
    let html_url:       String?
    let followers_url:  String?
    let following_url:  String?
    let gists_url:      String?
    let starred_url:    String?
    let subscriptions_url: String?
    let organizations_url: String?
    let repos_url:      String?
    let events_url:     String?
    let received_events_url: String?
    let type:           String
    let site_admin:     Bool
    let contributions:  Int

    enum CodingKeys: String, CodingKey {
        case id
        case login
        case node_id
        case avatar_url
        case gravatar_id
        case url
        case html_url
        case followers_url
        case following_url
        case gists_url
        case starred_url
        case subscriptions_url
        case organizations_url
        case repos_url
        case events_url
        case received_events_url
        case type
        case site_admin
        case contributions
    }
}


class User: NSObject, Codable {
    
    let location: String?
    
    enum CodingKeys: String, CodingKey {
        case location
    }
}
