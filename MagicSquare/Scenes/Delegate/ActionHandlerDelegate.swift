//
//  ActionHandlerDelegate.swift
//  MagicSquare
//
//  Created by Eduardo Fornari on 19/07/17.
//  Copyright © 2017 Marcelo Andrighetto Foltz. All rights reserved.
//

import Foundation

protocol ActionHandlerDelegate {
    func answerAction() -> Void
    func levelsAction() -> Void
    func configurationsAction() -> Void
}
