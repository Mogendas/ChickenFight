//
//  Challenge.swift
//  ChickenFight
//
//  Created by Johan Wejdenstolpe on 2017-08-07.
//  Copyright © 2017 Johan Wejdenstolpe. All rights reserved.
//

import Foundation

class Challenge {
    let opponent: String!
    
    var myMoves: Moves?
    var opponentMoves: Moves?
    
    init(opponent: String, myMoves: Moves) {
        self.opponent = opponent
        self.myMoves = myMoves
    }
    
    init(opponent: String, opponentMoves: Moves) {
        self.opponent = opponent
        self.opponentMoves = opponentMoves
    }
    
    func addMyMoves(moves: Moves) {
        self.myMoves = moves
    }
    
    func addOpponentMoves(moves: Moves){
        self.opponentMoves = moves
    }
}
