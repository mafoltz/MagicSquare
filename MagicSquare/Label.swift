//
//  Label.swift
//  MagicSquare
//
//  Created by Eduardo Fornari on 26/07/17.
//  Copyright © 2017 Marcelo Andrighetto Foltz. All rights reserved.
//

import SpriteKit

class Label: SKNode{
    
    var labels = [SKLabelNode]()
    public var height = CGFloat(0)
    
    init(text: String, fontName: String, fontSize: CGFloat, width: CGFloat, fontColor: UIColor){
        super.init()
        labels = [SKLabelNode]()
        
        
        
        var words = text.components(separatedBy: " ")
        var textLabel = ""
        var space = false
        
        while !words.isEmpty {
            labels.append(createNewLabel(withFontName: fontName, andFontColor: fontColor, andFontSize: fontSize))
            for word in words {
                var addWord = ""
                if space {
                    addWord = " \(word)"
                }
                else{
                    addWord = "\(word)"
                    space = true
                }
                labels[labels.count-1].text! += "\(addWord)"
                if labels[labels.count-1].frame.size.width > width {
                    space = false
                    break
                }
                else{
                    textLabel += " \(addWord)"
                    
                    words.removeFirst()
                }
            }
            labels[labels.count-1].text! = textLabel
            textLabel = ""
        }
        
        var maxHeight = CGFloat(0)
        height = maxHeight * CGFloat(labels.count)
        
        for label in labels{
            if label.frame.height > maxHeight{
                maxHeight = label.frame.height
            }
        }
        
        var y = CGFloat(0)
        if labels.count % 2 == 0{
            y = CGFloat(labels.count/2)
            y -= 1
            y *= maxHeight
            y += maxHeight*0.5
        }
        else{
            y = (labels.count/2)*maxHeight
        }
        
        for label in labels{
            label.position = CGPoint(x: 0.0, y: y)
            addChild(label)
            y -= maxHeight
        }
        
        
    }
    
    private func createNewLabel(withFontName fontName: String, andFontColor fontColor: UIColor, andFontSize fontSize: CGFloat) -> SKLabelNode{
        let label = SKLabelNode(fontNamed: fontName)
        label.fontColor = fontColor
        label.fontSize = fontSize
        label.text = ""
        return label
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
