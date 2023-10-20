//
//  GameConfiguration.swift
//  ProjectSanFrancisco
//
//  Created by Nicolas Nascimento on 7/28/16.
//  Copyright © 2016 LastLeaf. All rights reserved.
//

import SpriteKit

class GameConfiguration {
    
    /// Enables debugging tools
    static var debugMode: Bool {
        #if DEBUG
            return true
        #else
            return false
        #endif
    }
}
