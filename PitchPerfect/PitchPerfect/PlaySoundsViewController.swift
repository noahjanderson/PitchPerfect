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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
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
        }
        else if sender == lowPitchButton{
            println("Low Pitch Button")
        }
    }
    
    func playAudioAtRate(rate: Float){
        audioPlayer.stop()
        audioPlayer.currentTime = 0.0
        audioPlayer.rate = rate
        audioPlayer.play()
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
