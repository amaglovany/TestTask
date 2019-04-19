//
//  Error.swift
//  GitTest
//
//  Created by Developer on 4/19/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import Foundation

class ErrorData: Codable {
    let errors: [String]
    
    enum CodingKeys: String, CodingKey {
        case errors
    }
    
    init(errors: [String]) {
        self.errors = errors
    }
}
