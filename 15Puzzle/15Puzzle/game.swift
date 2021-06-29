//
//  game.swift
//  15Puzzle
//
//  Created by Vamsi Krishna on 12/03/21.
//

import Foundation

struct game {
    var cards = [card]()
    init() {
        var array = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,0]
        for i in 0...15{
            let v = Int(arc4random_uniform(UInt32(array.count)))
            cards.append(card(index:i,value:array[v]))
            array.remove(at: v)
        }
    }
    mutating func findEmptyCell(index:Int) -> Bool{
        let leftIndex = index - 1
        let rightIndex = index + 1
        let topIndex = index - 4
        let bottomIndex = index + 4
        
        guard (isSolvable()[1] != 0 || isSolvable()[2] != 0) else {
            return false
        }
        if rightIndex%4 != 0 && cards[rightIndex].value == 0{
            cards[rightIndex].value = cards[index].value
            cards[rightIndex].color = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            cards[index].color = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cards[index].value = 0
        } else if (leftIndex+1)%4 != 0 && cards[leftIndex].value == 0 {
            cards[leftIndex].value = cards[index].value
            cards[leftIndex].color = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            cards[index].color = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cards[index].value = 0
        } else if topIndex>=0 && cards[topIndex].value == 0 {
            cards[topIndex].value = cards[index].value
            cards[topIndex].color = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            cards[index].color = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cards[index].value = 0
        } else if bottomIndex<=15 && cards[bottomIndex].value == 0 {
            cards[bottomIndex].value = cards[index].value
            cards[bottomIndex].color = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            cards[index].color = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            cards[index].value = 0
        }
        else {
            return false
        }
        return true
    }
    mutating func isSolvable()->[Int]{
        var blank = 0
        var invCount = 0
        for i in 0...15{
            if cards[i].value == 0{
               blank = 4 - Int((cards[i].index)/4)
               break
            }
        }
        for i in 0...15{
            for j in i...15{
                if (cards[i].value > cards[j].value) && cards[i].value != 0 && cards[j].value != 0{
                    invCount += 1
                }
            }
        }
        if blank%2 == invCount%2 {
            return [0,invCount,cards[15].value]
        }
        else {
            return [1,invCount,cards[15].value]
        }
    }
}
