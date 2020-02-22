//
//  CustomVideoPlayerView.swift
//  SimpleVideoPlayerDemo
//
//  Created by Mohamed El-Said on 2/21/20.
//  Copyright © 2020 Mohamed El-Said. All rights reserved.
//

import UIKit
import AVFoundation

class CustomVideoPlayerView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var timeSlider: UISlider!
    
    var playButton: UIButton = UIButton()
    var backwardButton: UIButton = UIButton()
    var forwardButton: UIButton = UIButton()
    var buttonStackView: UIStackView = UIStackView()
    
 
    var player: AVPlayer!
    var playerLayer: AVPlayerLayer!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }

    func initSubviews() {
        // standard initialization logic
        let nib = UINib(nibName: "CustomVideoPlayerView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        //setupVideoView()
    }
    
    func configuration(with path: String) {
        setupVideoView(with: path)
        addTimeObserver()
    }
    
    func setupVideoView(with path: String) {
        if let url = URL(string: path) {
          player = AVPlayer(url: url)
          player.currentItem?.addObserver(self, forKeyPath: "duration", options: [.new, .initial], context: nil)
        }
        
        playerLayer = AVPlayerLayer(player: player)
    
        playerLayer.videoGravity = .resizeAspect
        playerLayer.bounds = videoView.bounds
        playerLayer.frame = videoView.frame
        
        videoView.layer.addSublayer(playerLayer)
    
    }
    
    
    func addTimeObserver() {
        let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        let mainQueue = DispatchQueue.main
        _ = player.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue, using: { [weak self] time in
            guard let currentItem = self?.player.currentItem else {return}
            self?.timeSlider.minimumValue = 0
            self?.timeSlider.maximumValue = Float(currentItem.duration.seconds)
            self?.timeSlider.value = Float(currentItem.currentTime().seconds)
            self?.currentTimeLabel.text = self?.getTime(from: currentItem.currentTime())
        })
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "duration", let duration = player.currentItem?.duration.seconds, duration > 0.0 {
            durationLabel.text = getTime(from: player.currentItem!.duration)
        }
    }
    
    func getTime(from time: CMTime) -> String {
        let totalSeconds = CMTimeGetSeconds(time)
        let hours = Int64(totalSeconds/3600)
        let minutes = Int64(totalSeconds/60) % 60
        let seconds = Int64(totalSeconds.truncatingRemainder(dividingBy: 60))
        print(hours, minutes, seconds)
        if hours > 0 {
            return "\(hours):\(minutes):\(seconds)"
        } else {
            return "\(minutes):\(seconds)"
        }
        
    }

    @IBAction func sliderValueDidChanged(_ sender: UISlider) {
        player.seek(to: CMTimeMake(value: Int64(sender.value*1000), timescale: 1000))
    }
    var isVideoPlaying = false
    @IBAction func onTappedPlayButton(_ sender: UIButton) {
        if isVideoPlaying {
            player.pause()
            sender.setImage(UIImage(systemName: "Pause"), for: .normal)
        } else {
            player.play()
            sender.setImage(UIImage(systemName: "Play"), for: .normal)
            
        }
        isVideoPlaying = !isVideoPlaying
    }
    
    @IBAction func onTappedForwardButton(_ sender: UIButton) {
        guard let duration = player.currentItem?.duration else {
            return
        }
        
        let currentTime = CMTimeGetSeconds(player.currentTime())
        
        let newTime = currentTime + 5.0
        
        if newTime < (CMTimeGetSeconds(duration) - 5.0) {
            let time: CMTime = CMTimeMake(value: Int64(newTime*1000), timescale: 1000)
            player.seek(to: time)
        }
    }
    
    @IBAction func onTappedBackwardButton(_ sender: UIButton) {
        let currentTime = CMTimeGetSeconds(player.currentTime())
        
        var newTime = currentTime - 5.0
        
        if newTime < 0 {
            newTime = 0
        }
        
        let time: CMTime = CMTimeMake(value: Int64(newTime*1000), timescale: 1000)
        player.seek(to: time)
        
    }
}
