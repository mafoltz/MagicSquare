//
//  World.swift
//  MagicSquare
//
//  Created by Arthur Giachini on 11/07/17.
//  Copyright © 2017 Marcelo Andrighetto Foltz. All rights reserved.
//

import UIKit

class World {
    
    static func loadLevel (numberOfLevel : Int) -> Level? {
        do {
            if let file = Bundle.main.url(forResource: "World", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let world = json as? [[String: Any]] {
                    let level = Level(levelJson: world[numberOfLevel-1], numberLevel: numberOfLevel)
                    return level
                }
                else {
                    print("JSON is invalid")
                }
            } else {
                print("World file was not found")
            }
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}

