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
    let blockHighAtlas = SKTextureAtlas(named: "defendhigh.atlas")
    let blockMidAtlas = SKTextureAtlas(named: "defendmid.atlas")
    let blockLowAtlas = SKTextureAtlas(named: "defendlow.atlas")
    let attackerNode = SKSpriteNode(imageNamed: "chicken.png")
    let defenderNode = SKSpriteNode(imageNamed: "chicken.png")
    let youwinNode = SKSpriteNode(texture: SKTexture(imageNamed: "youwin.png"), size: CGSize(width: 700, height: 200))
    let youlooseNode = SKSpriteNode(texture: SKTexture(imageNamed: "youloose.png"), size: CGSize(width: 920, height: 200))
    let tieNode = SKSpriteNode(texture: SKTexture(imageNamed: "tie.png"), size: CGSize(width: 320, height: 200))
    let challengeControllerNode:SKNode = SKNode()
    let lblAttackerName = SKLabelNode(text: "Attacker")
    let lblDefenderName = SKLabelNode(text: "Defender")
    let lblAttackerScore = SKLabelNode(text: "Hits: 0")
    let lblDefenderScore = SKLabelNode(text: "Hits: 0")
    let lblResult = SKLabelNode(text: "")
    let rotatePhone = SKSpriteNode(imageNamed: "turnphone.png")
    
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
    var attackerScore = 0
    var defenderScore = 0
    
    struct Layer {
        static let Defender: CGFloat = 0
        static let Attacker: CGFloat = 1
        static let UI: CGFloat = 2
        static let Messages: CGFloat = 3
    }
    
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
        
        let userSettings = UserDefaults()
        if (userSettings.string(forKey: "userPhonenumber") != nil){
            let userPhonenumber = userSettings.string(forKey: "userPhonenumber")
            if challenge?.attacker == userPhonenumber {
                // You are attacking
                lblAttackerName.text = "You"
                lblDefenderName.text = challenge?.defender
            }else{
                // You are defending
                lblDefenderName.text = "You"
                lblAttackerName.text = challenge?.attacker
            }
        }
        
//        UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
        
        NotificationCenter.default.addObserver(self, selector: #selector(FightVC.deviceDidRotate), name: Notification.Name.UIDeviceOrientationDidChange, object: nil)
        
        attackerNode.size = CGSize(width: 600, height: 500)
        defenderNode.size = CGSize(width: 600, height: 500)
        
        
        attackerNode.anchorPoint = CGPoint(x: 1, y: 0.5)
        defenderNode.anchorPoint = CGPoint(x: 1, y: 0.5)
        lblAttackerName.horizontalAlignmentMode = .left
        lblDefenderName.horizontalAlignmentMode = .right
        lblAttackerScore.horizontalAlignmentMode = .left
        lblDefenderScore.horizontalAlignmentMode = .right
        lblAttackerScore.verticalAlignmentMode = .top
        lblDefenderScore.verticalAlignmentMode = .top
        
        
        
        lblAttackerName.position = CGPoint(x: 10, y: scene.frame.height - lblAttackerName.frame.height - 40)
        lblDefenderName.position = CGPoint(x: scene.frame.width - 10, y: scene.frame.height - lblDefenderName.frame.height - 40)
        lblAttackerScore.position = CGPoint(x: lblAttackerName.frame.minX, y: lblAttackerName.frame.minY - lblAttackerName.frame.height)
        lblDefenderScore.position = CGPoint(x: lblDefenderName.frame.maxX, y: lblDefenderName.frame.minY - lblDefenderName.frame.height)
        
        
//        print(lblDefenderName.frame.minX)
        
        lblAttackerName.fontColor = UIColor.black
        lblDefenderName.fontColor = UIColor.black
        lblAttackerScore.fontColor = UIColor.black
        lblDefenderScore.fontColor = UIColor.black
        
        
        lblAttackerName.fontSize = 72
        lblDefenderName.fontSize = 72
        lblAttackerScore.fontSize = 58
        lblDefenderScore.fontSize = 58
        
        lblAttackerName.fontName = "Planet Benson 2"
        lblDefenderName.fontName = "Planet Benson 2"
        lblAttackerScore.fontName = "Planet Benson 2"
        lblDefenderScore.fontName = "Planet Benson 2"
        
        lblAttackerName.zPosition = Layer.UI
        lblDefenderName.zPosition = Layer.UI
        lblAttackerScore.zPosition = Layer.UI
        lblDefenderScore.zPosition = Layer.UI
        
        attackerNode.position = CGPoint(x: (scene.frame.width / 2) + (0.325 * attackerNode.frame.size.width), y: scene.frame.height / 2)
        defenderNode.position = CGPoint(x: (scene.frame.width / 2) - (0.325 * defenderNode.frame.size.width), y: scene.frame.height / 2)
        
        scene.addChild(attackerNode)
        scene.addChild(defenderNode)
        scene.addChild(lblAttackerName)
        scene.addChild(lblDefenderName)
        scene.addChild(lblAttackerScore)
        scene.addChild(lblDefenderScore)
//        scene.addChild(kapowNode)
        
        skView.presentScene(scene)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        switch UIDevice.current.orientation {
        case .portrait:
            showRotatePhone()
            break
            
        case .portraitUpsideDown:
            showRotatePhone()
            break
            
        case .landscapeLeft:
            startChallenge()
            break
            
        case .landscapeRight:
            startChallenge()
            break
            
        default:
            //            print("Another")
            break
            
        }
        
    }
    
    func showResult(){
        var resultNode = SKSpriteNode()
        
        
        let userSettings = UserDefaults()
        if (userSettings.string(forKey: "userPhonenumber") != nil){
            let userPhonenumber = userSettings.string(forKey: "userPhonenumber")
            if attackerScore != defenderScore {
                if challenge?.attacker == userPhonenumber{
                    // You are the attacker
                    if attackerScore > defenderScore {
                        // You win
                        resultNode = youwinNode
                    }else{
                        // You loose
                        resultNode = youlooseNode
                    }
                }else{
                    // You are the defender
                    if defenderScore > attackerScore{
                        // You win
                        resultNode = youwinNode
                    }else{
                        // You loose
                        resultNode = youlooseNode
                    }
                }
            }else{
                // Draw
//                print("Draw")
                resultNode = tieNode
            }
        }
        resultNode.position = CGPoint(x: scene.frame.width / 2, y: scene.frame.height / 2)
        resultNode.zPosition = Layer.Messages
        scene.addChild(resultNode)
    }
    
    func showRotatePhone(){
        rotatePhone.position = CGPoint(x: scene.frame.width / 2, y: scene.frame.height / 2)
        rotatePhone.size = CGSize(width: 400, height: 400)
        rotatePhone.zRotation = CGFloat(Double.pi / 2)
        rotatePhone.zPosition = Layer.Messages
        scene.addChild(rotatePhone)
    }
    
    func deviceDidRotate(){
        switch UIDevice.current.orientation {
        case .portrait:
//            print("Portrait")
            pauseChallenge()
            showRotatePhone()
            break
            
        case .portraitUpsideDown:
//            print("PortraitUpsideDown")
            pauseChallenge()
            showRotatePhone()
            break
            
        case .landscapeLeft:
//            print("LandscapeLeft")
            startChallenge()
            scene.removeChildren(in: [rotatePhone])
            break
            
        case .landscapeRight:
//            print("LandscapeRight")
            startChallenge()
            scene.removeChildren(in: [rotatePhone])
            break

        default:
//            print("Another")
            break
            
        }
    }
    
    func showHitAnimation(){
//        scene.addChild(kapowNode)
        let kapowNode = SKSpriteNode(imageNamed: "kapow.png")
        kapowNode.position = CGPoint(x: scene.frame.width / 2, y: scene.frame.height / 2)
        kapowNode.size.height = 19
        kapowNode.size.width = 25
        kapowNode.zPosition = Layer.Messages
        let hitAnimationControllerNode = SKNode()
        let growAction = SKAction.scale(to: 20, duration: 0.1)
        let fadeAction = SKAction.fadeOut(withDuration: 0.5)
        let moveAction = SKAction.move(to: CGPoint(x: scene.frame.width / 2, y: scene.frame.height * 0.8), duration: 0.5)
        scene.addChild(hitAnimationControllerNode)
        
////        print("Hit")
//        
        let showKapow = SKAction.sequence([
            SKAction.run {
//                print("Add")
                self.scene.addChild(kapowNode)
                kapowNode.run(growAction)
            },
            SKAction.wait(forDuration: 0.1),
            SKAction.run {
                kapowNode.run(moveAction)
            },
            SKAction.wait(forDuration: 0.1),
            SKAction.run {
                kapowNode.run(fadeAction)
            },
            SKAction.wait(forDuration: 0.7),
            SKAction.run {
                self.scene.removeChildren(in: [kapowNode])
//                print("Remove")
            }
        
        ])
        hitAnimationControllerNode.run(showKapow)
        
    }
    
    func showBlockAnimation(){
        let blockAnimationControllerNode = SKNode()
        scene.addChild(blockAnimationControllerNode)
        let blockNode = SKSpriteNode(imageNamed: "thud.png")
//        let scaleBy:CGFloat = 0.6
        blockNode.size.height = 20
        blockNode.size.width = 20
        blockNode.position = CGPoint(x: scene.frame.width / 2, y: scene.frame.height / 2)
//        CGPoint(x: scene.frame.width / 2, y: scene.frame.height * 0.6)
        blockNode.zPosition = Layer.Messages
        let growAction = SKAction.scale(to: 20, duration: 0.1)
        let fadeAction = SKAction.fadeOut(withDuration: 0.4)
        let moveAction = SKAction.move(to: CGPoint(x: scene.frame.width / 2, y: scene.frame.height * 0.8), duration: 0.5)
        let showBlock = SKAction.sequence([
            SKAction.run{
                self.scene.addChild(blockNode)
                blockNode.run(growAction)
            },
            SKAction.wait(forDuration: 0.1),
            SKAction.run {
                blockNode.run(moveAction)
            },
            SKAction.wait(forDuration: 0.2),
            SKAction.run {
                blockNode.run(fadeAction)
            },
            SKAction.wait(forDuration: 0.7),
            SKAction.run {
                self.scene.removeChildren(in: [blockNode])
            }
            
            ])
        blockAnimationControllerNode.run(showBlock)
    }
    
    func addHitForAttacker(){
        attackerScore += 1
        lblAttackerScore.text = "Hits: \(attackerScore)"
    }
    
    func addHitForDefender(){
        defenderScore += 1
        lblDefenderScore.text = "Hits: \(defenderScore)"
    }
    
    func startChallenge(){
        if challengeControllerNode.parent == nil {
            self.showChallenge()
        }else{
            if challengeControllerNode.isPaused == true {
                challengeControllerNode.isPaused = false
                self.defenderNode.isPaused = false
                self.attackerNode.isPaused = false
            }
        }
    }
    
    func pauseChallenge(){
        if challengeControllerNode.isPaused == false {
            challengeControllerNode.isPaused = true
            self.defenderNode.isPaused = true
            self.attackerNode.isPaused = true
        }
    }
    
    func showChallenge(){
        let waitRound = SKAction.wait(forDuration: 3.8)
        let waitToSeque = SKAction.wait(forDuration: 15)
        scene.addChild(challengeControllerNode)
//        showRound(attack: (challenge?.attackerMoves?.attack1)!, defence: (challenge?.defenderMoves?.attack1)!, reverse: false)
        let showFightSequence = SKAction.sequence([
            SKAction.run {
                self.showRound(attack: (self.challenge?.attackerMoves?.attack1)!, defence: (self.challenge?.defenderMoves?.defence1)!, reverse: false)
            },
            waitRound,
            SKAction.run {
                self.showRound(attack: (self.challenge?.defenderMoves?.attack1)!, defence: (self.challenge?.attackerMoves?.defence1)!, reverse: true)
            },
            waitRound,
            SKAction.run {
                self.showRound(attack: (self.challenge?.attackerMoves?.attack2)!, defence: (self.challenge?.defenderMoves?.defence2)!, reverse: false)
            },
            waitRound,
            SKAction.run {
                self.showRound(attack: (self.challenge?.defenderMoves?.attack2)!, defence: (self.challenge?.attackerMoves?.defence2)!, reverse: true)
            },
            waitRound,
            SKAction.run {
                self.showRound(attack: (self.challenge?.attackerMoves?.attack3)!, defence: (self.challenge?.defenderMoves?.defence3)!, reverse: false)
            },
            waitRound,
            SKAction.run {
                self.showRound(attack: (self.challenge?.defenderMoves?.attack3)!, defence: (self.challenge?.attackerMoves?.defence3)!, reverse: true)
            },
            waitRound,
            SKAction.run {
                self.showResult()
            },
            waitToSeque,
            SKAction.run {
                self.performSegue(withIdentifier: "BackToMenu", sender: self)
            },
            
            ])
        self.challengeControllerNode.run(showFightSequence)
        
//        showRound(attack: 1, defence: 1, reverse: false)

    }
    
    func showRound(attack: Int, defence: Int, reverse: Bool){
        attackerNode.removeAllActions()
        defenderNode.removeAllActions()
        let idleAction = SKAction.animate(with: idleArray, timePerFrame: 0.06)
//        let repeatIdle = SKAction.repeat(idleAction, count: 2)
        let repeatIdle = SKAction.repeatForever(idleAction)
        attackerNode.run(repeatIdle, withKey: "attackerIdle")
        defenderNode.run(repeatIdle, withKey: "defenderIdle")

        var attackAction = SKAction()
        var attackResetAction = SKAction()
        var defenceAction = SKAction()
        var defenceResetAction = SKAction()
        
//        scene.childNode(withName: "test").
//        attackerNode.zPosition = 
        
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
        
        let waitIdleAction = SKAction.wait(forDuration: 2.4)
        let waitToShowPunchAnimation = SKAction.wait(forDuration: 0.9)
        let waitAfterPunchAnimation = SKAction.wait(forDuration: 0.1)
        let waitForResetAction = SKAction.wait(forDuration: TimeInterval(waitToShowPunchAnimation.duration + waitAfterPunchAnimation.duration))
        
        if reverse {
            
            defenderNode.zPosition = Layer.Attacker
            attackerNode.zPosition = Layer.Defender
            
            let attackerSequence = SKAction.sequence([
//                SKAction.run {
//                    
//                    self.defenderNode.run(repeatIdle)
//                },
                waitIdleAction,
                SKAction.run {
                    self.defenderNode.removeAction(forKey: "defenderIdle")
//                    self.defenderNode.removeAllActions()
                    self.defenderNode.run(attackAction)
                },
                waitToShowPunchAnimation,
                SKAction.run {
                    if attack != defence{
                        self.addHitForDefender()
                        self.showHitAnimation()
                    }else{
                        self.showBlockAnimation()
                    }
                },
                waitAfterPunchAnimation,
                SKAction.run {
//                    print("Reset")
                    
                    self.defenderNode.run(attackResetAction){
//                        self.defenderNode.run(repeatIdle)
                    }
                }])
            
            let defenderSequence = SKAction.sequence([
//                SKAction.run {
//                    self.attackerNode.run(repeatIdle)
//                },
                waitIdleAction,
                SKAction.run {
                    self.attackerNode.removeAction(forKey: "attackerIdle")
//                    self.attackerNode.removeAllActions()
                    self.attackerNode.run(defenceAction)
                },
                waitForResetAction,
                SKAction.run {
//                    print("Reset")
                    self.attackerNode.run(defenceResetAction){
//                        self.attackerNode.run(repeatIdle)
                    }
                }])
            
            self.attackerNode.run(defenderSequence)
            self.defenderNode.run(attackerSequence)
            
        }else{
            
            attackerNode.zPosition = Layer.Attacker
            defenderNode.zPosition = Layer.Defender
        
            let attackerSequence = SKAction.sequence([
    //            SKAction.run {
    //                
    //                self.attackerNode.run(repeatIdle)
    //            },
                waitIdleAction,
                SKAction.run {
                    self.attackerNode.removeAction(forKey: "attackerIdle")
    //                self.attackerNode.removeAllActions()
                    self.attackerNode.run(attackAction)
                },
                waitToShowPunchAnimation,
                SKAction.run {
                    if attack != defence{
                        self.addHitForAttacker()
                        self.showHitAnimation()
                    }else{
                        self.showBlockAnimation()
                    }
                },
                waitAfterPunchAnimation,
                SKAction.run {
    //                print("Reset")
                    
                    self.attackerNode.run(attackResetAction){
    //                    self.attackerNode.run(repeatIdle)
                    }
                }])
            
            let defenderSequence = SKAction.sequence([
    //            SKAction.run {
    //                self.defenderNode.run(repeatIdle)
    //            },
                waitIdleAction,
                SKAction.run {
                    self.defenderNode.removeAction(forKey: "defenderIdle")
    //                self.defenderNode.removeAllActions()
                    self.defenderNode.run(defenceAction)
                },
                waitForResetAction,
                SKAction.run {
    //                print("Reset")
                    self.defenderNode.run(defenceResetAction){
    //                    self.defenderNode.run(repeatIdle)
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
        idleArray.append(idelAtlas.textureNamed("idle17.png"))
        idleArray.append(idelAtlas.textureNamed("idle18.png"))
        idleArray.append(idelAtlas.textureNamed("idle19.png"))
        idleArray.append(idelAtlas.textureNamed("idle20.png"))
        
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
        attackHighArray.append(attackHighAtlas.textureNamed("attackhigh10.png"))
        attackHighArray.append(attackHighAtlas.textureNamed("attackhigh11.png"))
        
        // Attack high reset
        
        attackHighResetArray.append(attackHighAtlas.textureNamed("attackhighreset01.png"))
        attackHighResetArray.append(attackHighAtlas.textureNamed("attackhighreset02.png"))
        attackHighResetArray.append(attackHighAtlas.textureNamed("attackhighreset03.png"))
        attackHighResetArray.append(attackHighAtlas.textureNamed("attackhighreset04.png"))
        attackHighResetArray.append(attackHighAtlas.textureNamed("attackhighreset05.png"))
        
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
        attackMidArray.append(attackMidAtlas.textureNamed("attackmid10.png"))
        attackMidArray.append(attackMidAtlas.textureNamed("attackmid11.png"))
        
        // Attack mid reset
        attackMidResetArray.append(attackMidAtlas.textureNamed("attackmidreset01.png"))
        attackMidResetArray.append(attackMidAtlas.textureNamed("attackmidreset02.png"))
        attackMidResetArray.append(attackMidAtlas.textureNamed("attackmidreset03.png"))
        attackMidResetArray.append(attackMidAtlas.textureNamed("attackmidreset04.png"))
        attackMidResetArray.append(attackMidAtlas.textureNamed("attackmidreset05.png"))
        
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
        attackLowArray.append(attackLowAtlas.textureNamed("attacklow10.png"))
        attackLowArray.append(attackLowAtlas.textureNamed("attacklow11.png"))
        
        // Attack Low reset
        attackLowResetArray.append(attackLowAtlas.textureNamed("attacklowreset01.png"))
        attackLowResetArray.append(attackLowAtlas.textureNamed("attacklowreset02.png"))
        attackLowResetArray.append(attackLowAtlas.textureNamed("attacklowreset03.png"))
        attackLowResetArray.append(attackLowAtlas.textureNamed("attacklowreset04.png"))
        attackLowResetArray.append(attackLowAtlas.textureNamed("attacklowreset05.png"))
        
        // Defend high
        blockHighArray.append(blockHighAtlas.textureNamed("defendhigh01.png"))
        blockHighArray.append(blockHighAtlas.textureNamed("defendhigh02.png"))
        blockHighArray.append(blockHighAtlas.textureNamed("defendhigh03.png"))
        blockHighArray.append(blockHighAtlas.textureNamed("defendhigh04.png"))
        blockHighArray.append(blockHighAtlas.textureNamed("defendhigh05.png"))
        blockHighArray.append(blockHighAtlas.textureNamed("defendhigh06.png"))
        
        // Defend high reset
        blockHighResetArray.append(blockHighAtlas.textureNamed("defendhighreset01.png"))
        blockHighResetArray.append(blockHighAtlas.textureNamed("defendhighreset02.png"))
        blockHighResetArray.append(blockHighAtlas.textureNamed("defendhighreset03.png"))
        blockHighResetArray.append(blockHighAtlas.textureNamed("defendhighreset04.png"))
        blockHighResetArray.append(blockHighAtlas.textureNamed("defendhighreset05.png"))
        
        // Defend mid
        blockMidArray.append(blockMidAtlas.textureNamed("defendmid01.png"))
        blockMidArray.append(blockMidAtlas.textureNamed("defendmid02.png"))
        blockMidArray.append(blockMidAtlas.textureNamed("defendmid03.png"))
        blockMidArray.append(blockMidAtlas.textureNamed("defendmid04.png"))
        blockMidArray.append(blockMidAtlas.textureNamed("defendmid05.png"))
        blockMidArray.append(blockMidAtlas.textureNamed("defendmid06.png"))
        
        // Defend mid reset
        blockMidResetArray.append(blockMidAtlas.textureNamed("defendmidreset01.png"))
        blockMidResetArray.append(blockMidAtlas.textureNamed("defendmidreset02.png"))
        blockMidResetArray.append(blockMidAtlas.textureNamed("defendmidreset03.png"))
        blockMidResetArray.append(blockMidAtlas.textureNamed("defendmidreset04.png"))
        blockMidResetArray.append(blockMidAtlas.textureNamed("defendmidreset05.png"))
        
        // Defend Low
        blockLowArray.append(blockLowAtlas.textureNamed("defendlow01.png"))
        blockLowArray.append(blockLowAtlas.textureNamed("defendlow02.png"))
        blockLowArray.append(blockLowAtlas.textureNamed("defendlow03.png"))
        blockLowArray.append(blockLowAtlas.textureNamed("defendlow04.png"))
        blockLowArray.append(blockLowAtlas.textureNamed("defendlow05.png"))
        blockLowArray.append(blockLowAtlas.textureNamed("defendlow06.png"))
        
        // Defend low reset
        blockLowResetArray.append(blockLowAtlas.textureNamed("defendlowreset01.png"))
        blockLowResetArray.append(blockLowAtlas.textureNamed("defendlowreset02.png"))
        blockLowResetArray.append(blockLowAtlas.textureNamed("defendlowreset03.png"))
        blockLowResetArray.append(blockLowAtlas.textureNamed("defendlowreset04.png"))
        blockLowResetArray.append(blockLowAtlas.textureNamed("defendlowreset05.png"))
        
    }
    
}
