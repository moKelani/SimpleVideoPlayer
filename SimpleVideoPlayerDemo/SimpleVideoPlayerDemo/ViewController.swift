//
//  ViewController.swift
//  SimpleVideoPlayerDemo
//
//  Created by Mohamed El-Said on 2/21/20.
//  Copyright © 2020 Mohamed El-Said. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var videoView: CustomVideoPlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        videoView.setupVideoView(with: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")
        
        videoView.addTimeObserver()
    }


}

