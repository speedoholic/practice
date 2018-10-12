//
//  ConfigurationManager.swift
//  Samples
//
//  Created by Kushal Ashok on 7/26/18.
//  Copyright © 2018 speed. All rights reserved.
//

import UIKit

@objc class ConfigurationManager: NSObject {
    
    // MARK: - Properties
    
    @objc var configuration: Configuration
    
    // MARK: -
    
    lazy private var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy:MM:dd HH:mm:ss"
        return dateFormatter
    }()
    
    // MARK: -
    
    var createdAt: String {
        return dateFormatter.string(from: configuration.createdAt)
    }
    
    var updatedAt: String {
        return dateFormatter.string(from: configuration.updatedAt)
    }
    
    // MARK: - Initialization
    
    init(withConfiguration configuration: Configuration) {
        self.configuration = configuration
        
        super.init()
    }
    
    // MARK: - Public Interface
    
    func updateConfiguration() {
        configuration.updatedAt = Date()
    }
    
}

