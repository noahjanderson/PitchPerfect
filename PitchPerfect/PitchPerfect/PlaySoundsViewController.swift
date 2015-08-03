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
    var playingWithRate: Bool = false
    
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
        if playingWithRate{
            if audioPlayer.playing{
                audioPlayer.pause()
                togglePauseResumeButton(false)
            }
            else{
                audioPlayer.play()
                togglePauseResumeButton(true)
            }
        }
        else{
            if audioEngine.running{
                audioEngine.pause()
                togglePauseResumeButton(false)
            }
            else{
                audioEngine.startAndReturnError(nil)
                togglePauseResumeButton(true)
            }
        }
    }

    @IBAction func playAudio(sender: UIButton) {
        pauseResumeButton.enabled = true
        togglePauseResumeButton(true)
        switch sender{
            case slowButton:
                playAudioAtRate(0.5)
                break
            case fastButton:
                playAudioAtRate(2.0)
                break
            case sender:
                playAudioAtPitch(1000.0)
                break
            case lowPitchButton:
                playAudioAtPitch(-500.0)
                break
            default:
                break
        }
    }
    
    func playAudioAtRate(rate: Float){
        playingWithRate = true
        audioPlayer.stop()
        audioEngine.stop()
        audioPlayer.currentTime = 0.0
        audioPlayer.rate = rate
        audioPlayer.play()
    }
    
    func playAudioAtPitch(pitch: Float){
        playingWithRate = false
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        var audioPlayerNode: AVAudioPlayerNode! = AVAudioPlayerNode()
        var audioPitchNode: AVAudioUnitTimePitch! = AVAudioUnitTimePitch()
        audioPitchNode.pitch = pitch
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(audioPitchNode)
        audioEngine.connect(audioPlayerNode, to: audioPitchNode, format: nil)
        audioEngine.connect(audioPitchNode, to: audioEngine.outputNode, format: nil)
        audioPlayerNode.scheduleFile(audioFile, atTime: nil,completionHandler: { () -> Void in
            self.pauseResumeButton.enabled = false
            self.togglePauseResumeButton(true)
        })
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
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
