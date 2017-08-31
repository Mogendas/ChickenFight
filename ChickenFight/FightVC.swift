//
//  FightVC.swift
//  ChickenFight
//
//  Created by Johan Wejdenstolpe on 2017-08-30.
//  Copyright © 2017 Johan Wejdenstolpe. All rights reserved.
//

import Foundation
import SpriteKit

class FightVC: ViewController {
    var skView: SKView{
        return view as! SKView
    }
    
    let scene = SKScene(size: CGSize(width: 1280, height: 720))
    
    var challenge: Challenge?
    
    let idelAtlas = SKTextureAtlas(named: "idle.atlas")
    let attackHighAtlas = SKTextureAtlas(named: "attackhigh.atlas")
    let attackMidAtlas = SKTextureAtlas(named: "attackmid.atlas")
    let attackLowAtlas = SKTextureAtlas(named: "attacklow.atlas")
    let blockHighAtlas = SKTextureAtlas(named: "blockhigh.atlas")
    let blockMidAtlas = SKTextureAtlas(named: "blockmid.atlas")
    let blockLowAtlas = SKTextureAtlas(named: "blocklow.atlas")
    
    let attackerNode = SKSpriteNode(imageNamed: "chicken.png")
    let defenderNode = SKSpriteNode(imageNamed: "chicken.png")
    
    var idleArray = [SKTexture]()
    var startRunningArray = [SKTexture]()
    var runningArray = [SKTexture]()
    var blockHighArray = [SKTexture]()
    var blockHighResetArray = [SKTexture]()
    var blockMidArray = [SKTexture]()
    var blockMidResetArray = [SKTexture]()
    var blockLowArray = [SKTexture]()
    var blockLowResetArray = [SKTexture]()
    var attackHighArray = [SKTexture]()
    var attackHighResetArray = [SKTexture]()
    var attackMidArray = [SKTexture]()
    var attackMidResetArray = [SKTexture]()
    var attackLowArray = [SKTexture]()
    var attackLowResetArray = [SKTexture]()
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        let mask = UIInterfaceOrientationMask.landscape
        return mask
    }
    
    override var shouldAutorotate: Bool{
        return false
    }
    
    override func viewDidLoad() {
        view = SKView()
        scene.backgroundColor = SKColor.white
        setupAnimation()
        
        defenderNode.xScale = defenderNode.xScale * -1
        
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
        
        NotificationCenter.default.addObserver(self, selector: #selector(FightVC.deviceDidRotate), name: Notification.Name.UIDeviceOrientationDidChange, object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        skView.presentScene(scene)
        attackerNode.position = CGPoint(x: scene.frame.width / 3, y: scene.frame.height / 2)
        scene.addChild(attackerNode)
        defenderNode.position = CGPoint(x: (scene.frame.width / 3) * 2, y: scene.frame.height / 2)
        scene.addChild(defenderNode)

        showFight()

    }
    
    func deviceDidRotate(){
        print("Turn")
    }
    
    func showFight(){
        
//        showRound(attack: (challenge?.attackerMoves?.attack1)!, defence: (challenge?.defenderMoves?.attack1)!, reverse: false)
        
        showRound(attack: 1, defence: 1, reverse: false)

    }
    
    func showRound(attack: Int, defence: Int, reverse: Bool){
        let idleAction = SKAction.animate(with: idleArray, timePerFrame: 0.08)
        let repeatIdle = SKAction.repeat(idleAction, count: 2)

        var attackAction = SKAction()
        var attackResetAction = SKAction()
        var defenceAction = SKAction()
        var defenceResetAction = SKAction()
        
        switch attack {
        case 1:
            attackAction = SKAction.animate(with: attackHighArray, timePerFrame: 0.1)
            attackResetAction = SKAction.animate(with: attackHighResetArray, timePerFrame: 0.1)
            break
        case 2:
            attackAction = SKAction.animate(with: attackMidArray, timePerFrame: 0.1)
            attackResetAction = SKAction.animate(with: attackMidResetArray, timePerFrame: 0.1)
            break
        case 3:
            attackAction = SKAction.animate(with: attackLowArray, timePerFrame: 0.1)
            attackResetAction = SKAction.animate(with: attackLowResetArray, timePerFrame: 0.1)
            break
        default:
            break
        }
        
        switch defence {
        case 1:
            defenceAction = SKAction.animate(with: blockHighArray, timePerFrame: 0.1)
            defenceResetAction = SKAction.animate(with: blockHighResetArray, timePerFrame: 0.1)
            break
        case 2:
            defenceAction = SKAction.animate(with: blockMidArray, timePerFrame: 0.1)
            defenceResetAction = SKAction.animate(with: blockMidResetArray, timePerFrame: 0.1)
            break
        case 3:
            defenceAction = SKAction.animate(with: blockLowArray, timePerFrame: 0.1)
            defenceResetAction = SKAction.animate(with: blockLowResetArray, timePerFrame: 0.1)
            break
        default:
            
            break
        }
        
        let waitAction = SKAction.wait(forDuration: 2)
        
        if reverse {
            let attackerSequence = SKAction.sequence([
                SKAction.run {
                    
                    self.defenderNode.run(repeatIdle)
                },
                SKAction.wait(forDuration: 3),
                SKAction.run {
                    self.defenderNode.run(attackAction) {
                    }
                },
                waitAction,
                SKAction.run {
                    self.defenderNode.run(attackResetAction){
                        self.defenderNode.run(repeatIdle)
                    }
                }
                
                ])
            
            let defenderSequence = SKAction.sequence([
                SKAction.run {
                    self.attackerNode.run(repeatIdle)
                },
                SKAction.wait(forDuration: 3),
                SKAction.run {
                    self.attackerNode.run(defenceAction) {
                    }
                },
                waitAction,
                SKAction.run {
                    self.attackerNode.run(defenceResetAction){
                        self.attackerNode.run(repeatIdle)
                    }
                }
                
                ])
            self.attackerNode.run(defenderSequence)
            self.defenderNode.run(attackerSequence)
            
        }else{
        
        let attackerSequence = SKAction.sequence([
            SKAction.run {
                
                self.attackerNode.run(repeatIdle)
            },
            SKAction.wait(forDuration: 3),
            SKAction.run {
                self.attackerNode.run(attackAction) {
                }
            },
            waitAction,
            SKAction.run {
                self.attackerNode.run(attackResetAction){
                    self.attackerNode.run(repeatIdle)
                }
            }])
        
        let defenderSequence = SKAction.sequence([
            SKAction.run {
                self.defenderNode.run(repeatIdle)
            },
            SKAction.wait(forDuration: 3),
            SKAction.run {
                self.defenderNode.run(defenceAction) {
                }
            },
            waitAction,
            SKAction.run {
                self.defenderNode.run(defenceResetAction){
                    self.defenderNode.run(repeatIdle)
                }
            }])
            self.defenderNode.run(defenderSequence)
            self.attackerNode.run(attackerSequence)
        }
            
            
//        if reverse {
//            print("Reverse")
//            self.attackerNode.run(defendSequence)
//            self.defenderNode.run(attackSequence)
//        }else{
//            self.defenderNode.run(defendSequence)
//            self.attackerNode.run(attackSequence)
//            print("Regular")
//        }
        
    
    }
    
    func setupAnimation(){
        // Setup animations
        
        // Idle array
        idleArray.append(idelAtlas.textureNamed("idle01.png"))
        idleArray.append(idelAtlas.textureNamed("idle02.png"))
        idleArray.append(idelAtlas.textureNamed("idle03.png"))
        idleArray.append(idelAtlas.textureNamed("idle04.png"))
        idleArray.append(idelAtlas.textureNamed("idle05.png"))
        idleArray.append(idelAtlas.textureNamed("idle06.png"))
        idleArray.append(idelAtlas.textureNamed("idle07.png"))
        idleArray.append(idelAtlas.textureNamed("idle08.png"))
        idleArray.append(idelAtlas.textureNamed("idle09.png"))
        idleArray.append(idelAtlas.textureNamed("idle10.png"))
        idleArray.append(idelAtlas.textureNamed("idle11.png"))
        idleArray.append(idelAtlas.textureNamed("idle12.png"))
        idleArray.append(idelAtlas.textureNamed("idle13.png"))
        idleArray.append(idelAtlas.textureNamed("idle14.png"))
        idleArray.append(idelAtlas.textureNamed("idle15.png"))
        idleArray.append(idelAtlas.textureNamed("idle16.png"))
        
        // Attack high
        attackHighArray.append(attackHighAtlas.textureNamed("attackhigh01.png"))
        attackHighArray.append(attackHighAtlas.textureNamed("attackhigh02.png"))
        attackHighArray.append(attackHighAtlas.textureNamed("attackhigh03.png"))
        attackHighArray.append(attackHighAtlas.textureNamed("attackhigh04.png"))
        attackHighArray.append(attackHighAtlas.textureNamed("attackhigh05.png"))
        attackHighArray.append(attackHighAtlas.textureNamed("attackhigh06.png"))
        attackHighArray.append(attackHighAtlas.textureNamed("attackhigh07.png"))
        attackHighArray.append(attackHighAtlas.textureNamed("attackhigh08.png"))
        attackHighArray.append(attackHighAtlas.textureNamed("attackhigh09.png"))
        
        // Attack high reset
        
        attackHighResetArray.append(attackHighAtlas.textureNamed("attackhighback01.png"))
        attackHighResetArray.append(attackHighAtlas.textureNamed("attackhighback02.png"))
        
        // Attack mid
        attackMidArray.append(attackMidAtlas.textureNamed("attackmid01.png"))
        attackMidArray.append(attackMidAtlas.textureNamed("attackmid02.png"))
        attackMidArray.append(attackMidAtlas.textureNamed("attackmid03.png"))
        attackMidArray.append(attackMidAtlas.textureNamed("attackmid04.png"))
        attackMidArray.append(attackMidAtlas.textureNamed("attackmid05.png"))
        attackMidArray.append(attackMidAtlas.textureNamed("attackmid06.png"))
        attackMidArray.append(attackMidAtlas.textureNamed("attackmid07.png"))
        attackMidArray.append(attackMidAtlas.textureNamed("attackmid08.png"))
        attackMidArray.append(attackMidAtlas.textureNamed("attackmid09.png"))
        
        // Attack mid reset
        attackMidResetArray.append(attackMidAtlas.textureNamed("attackmidback01.png"))
        attackMidResetArray.append(attackMidAtlas.textureNamed("attackmidback02.png"))
        
        // Attack low
        attackLowArray.append(attackLowAtlas.textureNamed("attacklow01.png"))
        attackLowArray.append(attackLowAtlas.textureNamed("attacklow02.png"))
        attackLowArray.append(attackLowAtlas.textureNamed("attacklow03.png"))
        attackLowArray.append(attackLowAtlas.textureNamed("attacklow04.png"))
        attackLowArray.append(attackLowAtlas.textureNamed("attacklow05.png"))
        attackLowArray.append(attackLowAtlas.textureNamed("attacklow06.png"))
        attackLowArray.append(attackLowAtlas.textureNamed("attacklow07.png"))
        attackLowArray.append(attackLowAtlas.textureNamed("attacklow08.png"))
        attackLowArray.append(attackLowAtlas.textureNamed("attacklow09.png"))
        
        // Attack Low reset
        attackLowResetArray.append(attackLowAtlas.textureNamed("attacklowback01.png"))
        attackLowResetArray.append(attackLowAtlas.textureNamed("attacklowback02.png"))
        
        // Block high
        blockHighArray.append(blockHighAtlas.textureNamed("blockhigh01.png"))
        blockHighArray.append(blockHighAtlas.textureNamed("blockhigh02.png"))
        blockHighArray.append(blockHighAtlas.textureNamed("blockhigh03.png"))
        blockHighArray.append(blockHighAtlas.textureNamed("blockhigh04.png"))
        blockHighArray.append(blockHighAtlas.textureNamed("blockhigh05.png"))
        
        // Block high reset
        blockHighResetArray.append(blockHighAtlas.textureNamed("blockhighback01.png"))
        blockHighResetArray.append(blockHighAtlas.textureNamed("blockhighback02.png"))
        blockHighResetArray.append(blockHighAtlas.textureNamed("blockhighback03.png"))
        blockHighResetArray.append(blockHighAtlas.textureNamed("blockhighback04.png"))
        
        
        // Block mid
        blockMidArray.append(blockMidAtlas.textureNamed("blockmid01.png"))
        blockMidArray.append(blockMidAtlas.textureNamed("blockmid02.png"))
        blockMidArray.append(blockMidAtlas.textureNamed("blockmid03.png"))
        blockMidArray.append(blockMidAtlas.textureNamed("blockmid04.png"))
        blockMidArray.append(blockMidAtlas.textureNamed("blockmid05.png"))
        
        // Block mid reset
        blockMidResetArray.append(blockMidAtlas.textureNamed("blockmidback01.png"))
        blockMidResetArray.append(blockMidAtlas.textureNamed("blockmidback02.png"))
        blockMidResetArray.append(blockMidAtlas.textureNamed("blockmidback03.png"))
        blockMidResetArray.append(blockMidAtlas.textureNamed("blockmidback04.png"))
        
        // Block Low
        blockLowArray.append(blockLowAtlas.textureNamed("blocklow01.png"))
        blockLowArray.append(blockLowAtlas.textureNamed("blocklow02.png"))
        blockLowArray.append(blockLowAtlas.textureNamed("blocklow03.png"))
        blockLowArray.append(blockLowAtlas.textureNamed("blocklow04.png"))
        blockLowArray.append(blockLowAtlas.textureNamed("blocklow05.png"))
        
        // Block low reset
        blockLowResetArray.append(blockLowAtlas.textureNamed("blocklowback01.png"))
        blockLowResetArray.append(blockLowAtlas.textureNamed("blocklowback02.png"))
        blockLowResetArray.append(blockLowAtlas.textureNamed("blocklowback03.png"))
        blockLowResetArray.append(blockLowAtlas.textureNamed("blocklowback04.png"))
        
    }
    
}
