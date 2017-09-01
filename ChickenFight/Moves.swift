//
//  Moves.swift
//  ChickenFight
//
//  Created by Johan Wejdenstolpe on 2017-08-07.
//  Copyright © 2017 Johan Wejdenstolpe. All rights reserved.
//

import UIKit

class Moves {
    var attack1: Int
    var attack2: Int
    var attack3: Int
    var defence1: Int
    var defence2: Int
    var defence3: Int
    
    init(moves: String) {
        self.attack1 = Int(moves[0])!
        self.attack2 = Int(moves[1])!
        self.attack3 = Int(moves[2])!
        self.defence1 = Int(moves[3])!
        self.defence2 = Int(moves[4])!
        self.defence3 = Int(moves[5])!
    }
    
    func getMovesAsString()-> String{
        let moves = "\(attack1)\(attack2)\(attack3)\(defence1)\(defence2)\(defence3)"
        return moves
    }
    
//    func getFirstAttack() -> Int {
//        return attack1
//    }
//    
//    func getSecondAttack() -> Int {
//        return attack2
//    }
//    
//    func getThirdAttack() -> Int {
//        return attack3
//    }
//    
//    func getFirstDefence() -> Int {
//        return defence1
//    }
//    
//    func getSecondDefence() -> Int {
//        return defence2
//    }
//    
//    func getThirdDefence() -> Int {
//        return defence3
//    }
    
}

extension String {
    
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
}
