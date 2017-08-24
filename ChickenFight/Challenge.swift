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
    
    init(){
        
    }
    
//    init(opponent: String, myMoves: Moves) {
//        self.opponent = opponent
//        self.myMoves = myMoves
//    }
//    
//    init(opponent: String, opponentMoves: Moves) {
//        self.opponent = opponent
//        self.opponentMoves = opponentMoves
//    }
//    
//    init(challengeID: Int, opponent: String){
//        self.challengeID = challengeID
//        self.opponent = opponent
//    }
//    
//    func addMyMoves(moves: Moves) {
//        self.myMoves = moves
//    }
//    
//    func addOpponentMoves(moves: Moves){
//        self.opponentMoves = moves
//    }
//    
//    func getMyMovesAsString() -> String {
//        let moves:String = (myMoves?.getMovesAsString())!
//        return moves
//    }
}
