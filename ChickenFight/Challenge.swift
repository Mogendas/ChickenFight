//
//  Challenge.swift
//  ChickenFight
//
//  Created by Johan Wejdenstolpe on 2017-08-07.
//  Copyright © 2017 Johan Wejdenstolpe. All rights reserved.
//

import Foundation

class Challenge {
    var challengeID: Int?
    var attacker: String?
    var defender: String?
    var attackerMoves: Moves?
    var defenderMoves: Moves?
    var watched: Bool = false
    
    init(){
        
    }
    
    init(challenge: Challenge) {
        if challenge.challengeID != nil {
            challengeID = challenge.challengeID
        }
        if challenge.attacker != nil {
            attacker = challenge.attacker
        }
        if challenge.defender != nil {
            defender = challenge.defender
        }
        if challenge.attackerMoves != nil {
            attackerMoves = challenge.attackerMoves
        }
        if challenge.defenderMoves != nil {
            defenderMoves = challenge.defenderMoves
        }
        
        watched = challenge.watched
    }
    
}
