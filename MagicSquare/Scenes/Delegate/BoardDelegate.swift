//
//  BoardDelegate.swift
//  MagicSquare
//
//  Created by Athos Lagemann on 20/07/17.
//  Copyright © 2017 Marcelo Andrighetto Foltz. All rights reserved.
//

import Foundation

protocol BoardDelegate {
	func updateMatrixAction(orientation: Orientation, columnOrRow: Int, moves: Int) -> Void
}
