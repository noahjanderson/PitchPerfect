//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Noah J Anderson on 7/26/15.
//  Copyright (c) 2015 Noah J Anderson. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    @IBOutlet weak var slowButton: UIButton!
    @IBOutlet weak var fastButton: UIButton!
    @IBOutlet weak var highPitchButton: UIButton!
    @IBOutlet weak var lowPitchButton: UIButton!
    var audioPlayer: AVAudioPlayer!
    var receivedAudio: RecordedAudio!
    var audioEngine: AVAudioEngine!
    var audioFile: AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playAudio(sender: UIButton) {
        
        if sender == slowButton{
            println("Slow Button")
            playAudioAtRate(0.5)
        }
        else if sender == fastButton{
            println("Fast Button")
            playAudioAtRate(1.5)
        }
        else if sender == highPitchButton{
            println("High Pitch Button")
            playAudioAtPitch(1000.0)
        }
        else if sender == lowPitchButton{
            println("Low Pitch Button")
            playAudioAtPitch(-500.0)
        }
    }
    
    func playAudioAtRate(rate: Float){
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
        audioPlayer.rate = rate
        audioPlayer.play()
    }
    
    func playAudioAtPitch(pitch: Float){
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
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
