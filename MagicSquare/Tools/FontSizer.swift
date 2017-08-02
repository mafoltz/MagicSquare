//
//  FontSizer.swift
//  MagicSquare
//
//  Created by Athos Lagemann on 02/08/17.
//  Copyright © 2017 Marcelo Andrighetto Foltz. All rights reserved.
//

import UIKit

func getFontSize(fontSize: CGFloat, screenHeight: CGFloat) -> CGFloat {
	
	return floor(fontSize * screenHeight/667)
}
