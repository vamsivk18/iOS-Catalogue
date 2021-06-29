//
//  card.swift
//  15Puzzle
//
//  Created by Vamsi Krishna on 12/03/21.
//

import Foundation
import UIKit
struct card{
    let index : Int
    var value : Int
    var color : UIColor
    
    init(index:Int,value:Int) {
        self.index = index
        self.value = value
        if value == 0 {
            color = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        } else {
        color = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        }
    }
}
