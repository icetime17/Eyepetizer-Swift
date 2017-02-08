//
//  VideoPlayViewController.swift
//  Eyepetizer-Swift
//
//  Created by Chris Hu on 17/2/8.
//  Copyright © 2017年 com.icetime17. All rights reserved.
//

import UIKit

import AVKit
import AVFoundation


class VideoPlayViewController: UIViewController {
    
    var video: ModelVideo!
    var videoURLString = ""
    var avPlayerVC: AVPlayerViewController!
    var avPlayer: AVPlayer!
    
    var isVideoPlaying = false
    var isOperationShowing = true
    
    
    @IBOutlet weak var btnBack: UIButton!
    
    @IBOutlet weak var viewVideoNetwork: UIView!
    @IBOutlet weak var videoCover: UIImageView!
    
    
    @IBOutlet weak var viewVideoNetworkOperation: UIView!
    @IBOutlet weak var btnPlayVideoNetwork: UIButton!
    @IBOutlet weak var btnNextVideoNetwork: UIButton!
    @IBOutlet weak var btnLastVideoNetwork: UIButton!
    
    // cache progress
    @IBOutlet weak var progressViewVideoNetworkLoading: UIProgressView!
    
    // play progress
    @IBOutlet weak var sliderPlayProgress: UISlider!
    @IBOutlet weak var lbPlayProgress: UILabel!
    
    deinit {
        print("deinit VideoPlayViewController")
    }
}

extension VideoPlayViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareUI()
        prepareRx()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        addNotification()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        removeNotification()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: - Notification
extension VideoPlayViewController {
    fileprivate func addNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(actionPlayVideoNetworkDone(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    fileprivate func removeNotification() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
}

// MARK: - UI
extension VideoPlayViewController {
    func prepareUI() {
        videoCover.kf.setImage(with: URL(string: video.coverForFeed))
    }
}

// MARK: - Rx
extension VideoPlayViewController {
    func prepareRx() {
        btnBack.rx.tap
            .subscribe(
                onNext: { [weak self] in
                    self?.dismiss(animated: true, completion: nil)
                }
            )
            .addDisposableTo(CS_DisposeBag)
        
        btnPlayVideoNetwork.rx.tap
            .subscribe(
                onNext: { [weak self] in
                    self?.actionPlayVideoNetwork()
                }
            )
            .addDisposableTo(CS_DisposeBag)
        
        btnNextVideoNetwork.rx.tap
            .subscribe(
                onNext: { [weak self] in
                    self?.actionNextVideoNetwork()
                }
            )
            .addDisposableTo(CS_DisposeBag)
        
        btnLastVideoNetwork.rx.tap
            .subscribe(
                onNext: { [weak self] in
                    self?.actionLastVideoNetwork()
                }
            )
            .addDisposableTo(CS_DisposeBag)
    }
}

// MARK: - Video Play
extension VideoPlayViewController {
    
    func timeString(_ time: Int) -> String {
        let hour = time / 3600
        let min = time / 60
        let sec = time % 60
        
        var minStr = ""
        var secStr = ""
        minStr = min > 9 ? "\(min)" : "0\(min)"
        secStr = sec > 9 ? "\(sec)" : "0\(sec)"
        
        if hour == 0 {
            return "\(minStr):\(secStr)"
        } else {
            var hourStr = ""
            hourStr = hour > 9 ? "\(hour)" : "0\(hour)"
            return "\(hourStr):\(minStr):\(secStr)"
        }
    }
    
    fileprivate func actionPlayVideoNetwork() {
        isVideoPlaying = !isVideoPlaying
        
        if avPlayer == nil {
            // video from network
            videoURLString = video.playUrl
            let videoURL = URL(string: videoURLString)
            
            // info of video
            let avPlayerItem = AVPlayerItem(url: videoURL!)
            // use status to check whether can be played now.
            // video can be played once received AVPlayerStatusReadyToPlay
            // loadedTimeRanges means caching progress which can be monitored using KVO
            avPlayerItem.addObserver(self, forKeyPath: "loadedTimeRanges", options: .new, context: nil)
            
            avPlayer = AVPlayer(playerItem: avPlayerItem)
            
            // monitor video playing progress
            avPlayer.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 1), queue: DispatchQueue.main, using: { (time) in
                
                let total = lroundf(Float(CMTimeGetSeconds(avPlayerItem.duration)))
                let current = lroundf(Float(CMTimeGetSeconds(time)))
                if current > 0 {
                    self.sliderPlayProgress.value = Float(current) / Float(total)
                    
                    self.lbPlayProgress.text = self.timeString(total - current)
                }
                
                // also can use notification AVPlayerItemDidPlayToEndTime
                if self.sliderPlayProgress.value == 1 {
                    self.btnPlayVideoNetwork.setImage(UIImage(named: "btnPlay"), for: .normal)
                    self.sliderPlayProgress.value = 0
                }
                
            })
            
            // AVPlayerLayer
            let avPlayerLayer = AVPlayerLayer(player: avPlayer)
            avPlayerLayer.frame = viewVideoNetwork.bounds
            avPlayerLayer.backgroundColor = UIColor.black.cgColor
            avPlayerLayer.videoGravity = AVLayerVideoGravityResize
            viewVideoNetwork.layer.addSublayer(avPlayerLayer)
            
            avPlayer.play()
            
            btnPlayVideoNetwork.setImage(UIImage(named: "btnPause"), for: .normal)
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(actionTapGesture(_:)))
            viewVideoNetworkOperation.addGestureRecognizer(tapGesture)
        } else {
            if isVideoPlaying {
                // also can use avPlayer.rate == 1.0 to judge
                avPlayer.play()
                
                btnPlayVideoNetwork.setImage(UIImage(named: "btnPause"), for: .normal)
            } else {
                avPlayer.pause()
                
                btnPlayVideoNetwork.setImage(UIImage(named: "btnPlay"), for: .normal)
            }
        }
    }
    
    fileprivate func actionNextVideoNetwork() {
        avPlayer.pause()
        
        videoURLString = "https://devimages.apple.com.edgekey.net/streaming/examples/bipbop_16x9/bipbop_16x9_variant.m3u8"
        
        let videoURL = URL(string: videoURLString)
        
        // info of video
        let avPlayerItem = AVPlayerItem(url: videoURL!)
        
        // use replace item to switch video
        avPlayer.replaceCurrentItem(with: avPlayerItem)
        
        avPlayer.play()
    }
    
    fileprivate func actionLastVideoNetwork() {
        avPlayer.pause()
        
        videoURLString = "http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4"
        
        let videoURL = URL(string: videoURLString)
        
        // info of video
        let avPlayerItem = AVPlayerItem(url: videoURL!)
        
        avPlayer.replaceCurrentItem(with: avPlayerItem)
        
        avPlayer.play()
    }
    
    fileprivate func actionStopPlaying() {
        avPlayer.pause()
        
    }
    
    func actionTapGesture(_ sender: UITapGestureRecognizer) {
        if isVideoPlaying {
            isOperationShowing = !isOperationShowing
            
            btnPlayVideoNetwork.isHidden = isOperationShowing
            btnLastVideoNetwork.isHidden = isOperationShowing
            btnNextVideoNetwork.isHidden = isOperationShowing
            sliderPlayProgress.isHidden = isOperationShowing
            progressViewVideoNetworkLoading.isHidden = isOperationShowing
            lbPlayProgress.isHidden = isOperationShowing
        }
    }
    
    func actionPlayVideoNetworkDone(_ sender: Notification) {
        print("Done")
    }
    
}

// MARK: - Use KVO to monitor cache progress
extension VideoPlayViewController {
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        let loadedTimeRanges = avPlayer.currentItem?.loadedTimeRanges
        guard let timeRange = loadedTimeRanges?.first else { return }// cache range
        let cmTimeRange = timeRange as CMTimeRange
        let start = cmTimeRange.start
        let duration = cmTimeRange.duration
        let loading = lroundf(Float(start.value) + Float(duration.value))
        let total = lroundf(Float(CMTimeGetSeconds((avPlayer.currentItem?.duration)!)))
        
        progressViewVideoNetworkLoading.progress = Float(loading) / Float(total)
        
    }
}
