//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Suthananth Arulanantham on 05.03.15.
//  Copyright (c) 2015 Suthananth Arulanantham. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController,AVAudioRecorderDelegate {
    
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var StopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!

    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    var filePath:NSURL!
    var recordingIsPaused:Bool!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        StopButton.hidden = true
        recordButton.enabled = true
        pauseButton.hidden = true
        infoLabel.text = "Tap to Record"
        recordingIsPaused = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: UIButton) {
        //UI Maintanance
        recordButton.enabled = false
        StopButton.hidden = false
        pauseButton.hidden = false
        pauseButton.enabled = true
        infoLabel.text = "Recording Audio"
        
        
        // checking is recording is paused
        // if so, continue recoring
        // otherwise create a new file and 
        // start recording
        if recordingIsPaused == true{
            audioRecorder.record()
            recordingIsPaused = false
        }
        else{
            
            filePath = createAFilePath()
        
            // create a recording session
            var session = AVAudioSession.sharedInstance()
            session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
            
            //start recording a audio
            audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
            audioRecorder.delegate = self
            audioRecorder.meteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
        }
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if flag {
            recordedAudio = RecordedAudio(fileUrl: recorder.url, title: recorder.url.lastPathComponent)
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        else{
            println("error occured druing recording")
            recordButton.enabled = true
            StopButton.hidden = true
        }
        
    }
    @IBAction func stopRecording(sender: UIButton) {
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        StopButton.hidden = true
    }
    
    
    @IBAction func pauseRecording(sender: UIButton) {
        recordingIsPaused = true
        audioRecorder.pause()
        recordButton.enabled = true
        pauseButton.enabled = false
        infoLabel.text = "Recording Paused"
        
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "stopRecording"){
            let playSoundVS:PlaySoundViewController = segue.destinationViewController as PlaySoundViewController
            let data = sender as RecordedAudio
            playSoundVS.receivedAudio = data
        }
    }
    
    
    // function for creating a filename for our audioRecorder
    func createAFilePath()->NSURL?{
        // first Create a path to store our recored file
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        // using current date and time as filename format "ddMMyyy-HHmmss"
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime) + ".wav"
        
        //Creating a pathURL for the session to use consisting of directory and filename
        let pathArray = [dirPath,recordingName]
        return NSURL.fileURLWithPathComponents(pathArray)
    }
}

