//
//  MainInterface.swift
//  FlockApp
//
//  Created by Stephanie Ramirez on 5/16/19.
//

import UIKit
import MediaPlayer


class MainInterface: UIViewController {
    
    var player: AVPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadVideo()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    private func loadVideo() {
        
        //this line is important to prevent background music stop
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.ambient, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        } catch { }
        
        let path = Bundle.main.path(forResource: "FlockIntroFinal", ofType:"mp4")
        let filePathURL = NSURL.fileURL(withPath: path!)
        let player = AVPlayer(url: filePathURL)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.backgroundColor = UIColor.white.cgColor
        playerLayer.frame = self.view.frame
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerLayer.zPosition = -1
        self.view.layer.addSublayer(playerLayer)
        player.seek(to: CMTime.zero)
        player.play()
    }
}
