//
//  Label.swift
//  MagicSquare
//
//  Created by Eduardo Fornari on 26/07/17.
//  Copyright © 2017 Marcelo Andrighetto Foltz. All rights reserved.
//

import SpriteKit
import UIKit

class Label: SKNode {

    var labels = [SKLabelNode]()
    public var height = CGFloat(0)

    init(text: String, style: UIFont.TextStyle, width: CGFloat, fontColor: UIColor) {
        super.init()

        var words = text.components(separatedBy: " ")
        var textLabel = ""
        var space = false

        while !words.isEmpty {

            let labelNode = SKLabelNode()
            labelNode.text("", style: style, color: fontColor)
            labels.append(labelNode)

            for word in words {
                var addWord = ""
                if space {
                    addWord = " \(word)"
                }
                else{
                    addWord = "\(word)"
                    space = true
                }

                let lastLabel = labels[labels.count-1]
                let lastLabelText = lastLabel.attributedText?.string ?? ""

                if lastLabelText.isEmpty {
                    labels[labels.count-1].text(addWord, style: style, color: fontColor)
                } else {
                    labels[labels.count-1].updateText(lastLabelText + addWord)
                }

                if labels[labels.count-1].frame.size.width > width {
                    space = false
                    break
                } else {
                    textLabel += "\(addWord)"
                    words.removeFirst()
                }
            }

            labels[labels.count-1].updateText(textLabel)
            textLabel = ""
        }

        var maxHeight = CGFloat(0)
        height = maxHeight * CGFloat(labels.count)

        for label in labels {
            if label.frame.height > maxHeight {
                maxHeight = label.frame.height
            }
        }

        var y = CGFloat(0)
        if labels.count % 2 == 0 {
            y = CGFloat(labels.count/2)
            y -= 1
            y *= maxHeight
            y += maxHeight*0.5
        } else {
            y = (labels.count / 2) * maxHeight
        }

        for label in labels {
            label.position = CGPoint(x: 0.0, y: y)
            addChild(label)
            y -= maxHeight
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
