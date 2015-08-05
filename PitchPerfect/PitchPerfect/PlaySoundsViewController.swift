//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Noah J Anderson on 7/26/15.
//  Copyright (c) 2015 Noah J Anderson. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController, AVAudioPlayerDelegate {
    @IBOutlet weak var slowButton: UIButton!
    @IBOutlet weak var fastButton: UIButton!
    @IBOutlet weak var highPitchButton: UIButton!
    @IBOutlet weak var lowPitchButton: UIButton!
    @IBOutlet weak var pauseResumeButton: UIButton!
    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        audioPlayer.delegate = self
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        pauseResumeButton.enabled = false

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func pauseResumePlayBack(sender: AnyObject) {
        
        if audioEngine.running{
            audioEngine.pause()
            togglePauseResumeButton(false)
        }
        else{
            audioEngine.startAndReturnError(nil)
            togglePauseResumeButton(true)
        }
        
    }

    @IBAction func playAudio(sender: UIButton) {
        pauseResumeButton.enabled = true
        togglePauseResumeButton(true)
        switch sender{
            case slowButton:
                playAudio(0.5, pitch: 1.0)
                break
            case fastButton:
                playAudio(2.0, pitch: 1.0)
                break
            case highPitchButton:
                playAudio(1.0, pitch: 1000.0)
                break
            case lowPitchButton:
                playAudio(1.0, pitch: -500.0)
                break
            default:
                break
        }
    }
    
    func playAudio(rate: Float, pitch: Float){
        resetAudioObjects()
        var audioPlayerNode: AVAudioPlayerNode! = AVAudioPlayerNode()
        var audioPitchNode: AVAudioUnitTimePitch! = AVAudioUnitTimePitch()
        var audioRateNode: AVAudioUnitVarispeed! = AVAudioUnitVarispeed()
        audioPitchNode.pitch = pitch
        audioPitchNode.rate = rate
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(audioPitchNode)
        audioEngine.attachNode(audioRateNode)
        audioEngine.connect(audioPlayerNode, to: audioPitchNode, format: nil)
        audioEngine.connect(audioPitchNode, to: audioRateNode, format: nil)
        audioEngine.connect(audioRateNode, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil,completionHandler: { () -> Void in
            self.pauseResumeButton.enabled = false
            self.togglePauseResumeButton(true)
        })
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }
    
    func resetAudioObjects(){
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
        audioEngine.stop()
        audioEngine.reset()
    }
    
    func togglePauseResumeButton(pause: Bool){
        if pause{
            self.pauseResumeButton.setImage(UIImage(named: "pause_80_blue"), forState: UIControlState.Normal)
        }
        else{
            self.pauseResumeButton.setImage(UIImage(named: "resume_80_blue"), forState: UIControlState.Normal)
        }
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        if flag{
            pauseResumeButton.enabled = false
            togglePauseResumeButton(true)
        }
    }
}
