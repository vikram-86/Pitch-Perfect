//
//  PlaySoundViewController.swift
//  PitchPerfect
//
//  Created by Suthananth Arulanantham on 07.03.15.
//  Copyright (c) 2015 Suthananth Arulanantham. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile : AVAudioFile!
    
    @IBOutlet weak var stopButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathURL, error: nil)
        audioPlayer.enableRate = true
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathURL, error: nil)
        //resetButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func slowButtonPressed(sender: UIButton) {
        
        audioEngine.stop()
        audioPlayer.rate = 0.5
        audioPlayer.play()
        
    }
    
    @IBAction func fastButtonPressed(sender: UIButton) {
        
        audioEngine.stop()
        audioPlayer.rate = 2.0
        audioPlayer.play()
        
    }
    
    @IBAction func stopButtonPressed(sender: UIButton) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
       
    }
    
    @IBAction func playChipmunkAudio(sender: AnyObject) {
        
        playAudioWithPitch(1200)
        
    }
    
    
    @IBAction func playDarthVarderAudio(sender: UIButton) {
        
        playAudioWithPitch(-1200)
        
    }
    
    func playAudioWithPitch(pitch:Float){
        
        //reset audio
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        // create a audioengine and a audio player node and connect them
        // together
        var playerNode = AVAudioPlayerNode()
        audioEngine.attachNode(playerNode)
        
        // create a pitch node for changing pitch
        var changePitch = AVAudioUnitTimePitch()
        changePitch.pitch = pitch
        audioEngine.attachNode(changePitch)
        
        // connect all the nodes together source -> pitch -> output
        audioEngine.connect(playerNode, to: changePitch, format: nil)
        
        audioEngine.connect(changePitch, to: audioEngine.outputNode, format: nil)
        playerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        playerNode.play()
    
    }

}