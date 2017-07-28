//
//  GameConfiguration.swift
//  ProjectSanFrancisco
//
//  Created by Nicolas Nascimento on 7/28/16.
//  Copyright © 2016 LastLeaf. All rights reserved.
//

import SpriteKit

//enum OperationSystemType {
//    case macOs
//    case iOS
//    case tvOS
//    case watchOS
//}

class GameConfiguration {
    
    /// Enables debugging tools
    static var debugMode: Bool {
        #if DEBUG
            return true
        #else
            return false
        #endif
    }
//    /// Tells the type of operational system the App is running in
//    static var osType: OperationSystemType {
//        #if os(OSX)
//            return .MacOS
//        #elseif os(tvOS)
//            return .tvOS
//        #elseif os(watchOS)
//            return .watchOS
//        #else
//            return .iOS
//        #endif
//    }
}
