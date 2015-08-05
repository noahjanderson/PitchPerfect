//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Noah J Anderson on 7/23/15.
//  Copyright (c) 2015 Noah J Anderson. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var stopBtn: UIButton!
    @IBOutlet weak var recordBtn: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    var audioRecorder: AVAudioRecorder!
    var audioSession: AVAudioSession!
    var soundFile: NSURL!
    var errorRecorder: NSError?
    var recordedAudio: RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioSession = AVAudioSession.sharedInstance()
        audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        audioSession.setActive(true, error: nil)
        
        let docsDir: AnyObject = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
        let soundFilePath = docsDir.stringByAppendingPathComponent("recordedAudio.caf")
        soundFile = NSURL.fileURLWithPath(soundFilePath as String)
        
        var recordSettings = [AVFormatIDKey: kAudioFormatAppleIMA4,
            AVSampleRateKey:44100.0,
            AVNumberOfChannelsKey:2,
            AVEncoderBitRateKey:12800.0,
            AVLinearPCMBitDepthKey:16,
            AVEncoderAudioQualityKey:AVAudioQuality.Max.rawValue
        ]
        audioRecorder = AVAudioRecorder(URL: soundFile, settings: recordSettings as [NSObject : AnyObject], error: &errorRecorder)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        recordBtn.enabled = true
        stopBtn.hidden = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "StoppedRecording"){
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
            
        }
    
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        recordBtn.enabled = false
        stopBtn.hidden = false
        recordingLabel.hidden = false
        audioRecorder.record()
        
    }
    
    @IBAction func stopRecording(sender: UIButton) {
        audioRecorder.stop()
        recordingLabel.hidden = true
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool){
        if (flag){
            recordedAudio = RecordedAudio(title: recorder.url.lastPathComponent!, filePathUrl: recorder.url)
            performSegueWithIdentifier("StoppedRecording", sender: recordedAudio)
        }
        else{
            println("Some Error in Recording")
        }
    }
}

