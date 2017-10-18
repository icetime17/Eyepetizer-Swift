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

import RxSwift
import CSSwiftExtension


class VideoPlayViewController: UIViewController {
    
    var realmModelVideo: RealmModelVideo!
    
    var avPlayer: AVPlayer!
    var avPlayerItem: AVPlayerItem!
    
    var isVideoPlaying = false
    var isVideoOperationViewShowing = true
    
    
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
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbCategory: UILabel!
    @IBOutlet weak var textViewDescription: UITextView!
    
    @IBOutlet weak var btnMore: UIButton!
    
    // tool bar
    @IBOutlet weak var viewToolBar: UIView!
    @IBOutlet weak var progressViewVideoDownload: UIProgressView!
    @IBOutlet weak var btnDownload: UIButton!
    @IBOutlet weak var btnFavorite: UIButton!
    
    
    let CS_DisposeBag = DisposeBag()
    
    
    // Hero
    var heroTransitionID: String? {
        willSet {
            self.isHeroEnabled = true
        }
    }
    
    deinit {
        //cs_print("deinit")
    }
}

extension VideoPlayViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupRx()
        
        setupSliderGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        videoCover.heroID = heroTransitionID
        
        addNotification()
    }
    
    /*
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let avAsset = AVAsset(url: URL(string: RealmModelVideo.playUrl)!)
        guard let naturalSize = avAsset.tracks.first?.naturalSize else { return }
        print(naturalSize)
        let screenSize = UIScreen.main.cs.screenSize
        let height = naturalSize.height / naturalSize.width * screenSize.width
        print(height)
        videoCover.cs.height = height
    }
    */
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.cs.delay(0.5) { 
            self.actionPlayVideoNetwork()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if avPlayer != nil {
            avPlayer.pause()
        }
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
    func setupUI() {
        videoCover.kf.setImage(with: URL(string: realmModelVideo.coverForFeed))
        
        lbTitle.text = realmModelVideo.title
        lbCategory.text = "#\(realmModelVideo.category) / \(realmModelVideo.duration.eyepetizerTimeDuration)"
        textViewDescription.text = realmModelVideo.videoDescription
        
        if realmModelVideo.playUrl.contains("http") {
            btnDownload.isHidden = false
        } else {
            btnDownload.isHidden = true
        }
    }
    
    func setupSliderGesture() {
        sliderPlayProgress.addTarget(self, action: #selector(startSeeking), for: .touchDown)
        sliderPlayProgress.addTarget(self, action: #selector(seek), for: .touchUpInside)
    }
    
    func startSeeking() {
        avPlayer.pause()
    }
    
    func seek() {
        let cmTime = CMTimeMake(Int64(sliderPlayProgress.value * 100) * Int64(realmModelVideo.duration), 100)
//        let progress = Int64(sliderPlayProgress.value * 100)
//        avPlayer.seek(to: CMTime(value: CMTimeValue(progress), timescale: CMTimeScale(CMTimeValue(100))))
        avPlayer.seek(to: cmTime)
        avPlayer.play()
    }
}

// MARK: - Rx
extension VideoPlayViewController {
    func setupRx() {
        btnBack.rx.tap
            .subscribe(
                onNext: { [weak self] in
                    self?.actionStopPlaying()
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
        
        sliderPlayProgress.rx.value
            .asObservable()
            .subscribe(
                onNext: { [weak self] value in
                    print(value)
                }
            )
            .addDisposableTo(CS_DisposeBag)
        
        // tool bar
        btnDownload.rx.tap
            .subscribe(
                onNext: { [weak self] in
                    self?.actionVideoDownload()
                }
            )
            .addDisposableTo(CS_DisposeBag)
        
        btnFavorite.rx.tap
            .subscribe(
                onNext: { [weak self] in
                    self?.actionVideoFavorite()
                }
            )
            .addDisposableTo(CS_DisposeBag)
    }
}

// MARK: - Actions
extension VideoPlayViewController {
    
    fileprivate func actionPlayVideoNetwork() {
        isVideoPlaying = !isVideoPlaying
        
        if avPlayer == nil {
            self.p_startPlayingVideo()
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
        
        let videoURLString = "https://devimages.apple.com.edgekey.net/streaming/examples/bipbop_16x9/bipbop_16x9_variant.m3u8"
        
        let videoURL = URL(string: videoURLString)
        
        // info of video
        let avPlayerItem = AVPlayerItem(url: videoURL!)
        
        // use replace item to switch video
        avPlayer.replaceCurrentItem(with: avPlayerItem)
        
        avPlayer.play()
    }
    
    fileprivate func actionLastVideoNetwork() {
        avPlayer.pause()
        
        let videoURLString = "http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4"
        
        let videoURL = URL(string: videoURLString)
        
        // info of video
        let avPlayerItem = AVPlayerItem(url: videoURL!)
        
        avPlayer.replaceCurrentItem(with: avPlayerItem)
        
        avPlayer.play()
    }
    
    fileprivate func actionStopPlaying() {
        if avPlayer != nil {
            avPlayer.pause()
            avPlayer = nil
            
            avPlayerItem.removeObserver(self, forKeyPath: "loadedTimeRanges", context: nil)
        }
    }
    
    func actionTapGesture(_ sender: UITapGestureRecognizer) {
        p_hideVideoOperationView()
    }
    
    fileprivate func p_hideVideoOperationView() {
        if isVideoPlaying {
            isVideoOperationViewShowing = !isVideoOperationViewShowing
            
            btnPlayVideoNetwork.isHidden = isVideoOperationViewShowing
            btnLastVideoNetwork.isHidden = isVideoOperationViewShowing
            btnNextVideoNetwork.isHidden = isVideoOperationViewShowing
            sliderPlayProgress.isHidden = isVideoOperationViewShowing
            progressViewVideoNetworkLoading.isHidden = isVideoOperationViewShowing
            lbPlayProgress.isHidden = isVideoOperationViewShowing
        } else {
            isVideoOperationViewShowing = !isVideoOperationViewShowing
            
            btnPlayVideoNetwork.isHidden = isVideoOperationViewShowing
            btnLastVideoNetwork.isHidden = isVideoOperationViewShowing
            btnNextVideoNetwork.isHidden = isVideoOperationViewShowing
            sliderPlayProgress.isHidden = isVideoOperationViewShowing
            progressViewVideoNetworkLoading.isHidden = isVideoOperationViewShowing
            lbPlayProgress.isHidden = isVideoOperationViewShowing
        }
        
        isVideoPlaying = !isVideoPlaying
    }
    
    func actionPlayVideoNetworkDone(_ sender: Notification) {
        print("Done")
    }
    
    func actionVideoDownload() {
        let docDir = FileManager.default.cs.documentsDirectory
        let videosDir = "\(docDir)/downloads/videos"
        let filePath = "\(videosDir)/\(realmModelVideo.title).mp4"
        if FileManager.default.fileExists(atPath: filePath) {
            print("already exists : \(realmModelVideo.title)")
            return
        }
        
        let urlSession = URLSession(configuration: URLSessionConfiguration.default,
                                         delegate: self,
                                    delegateQueue: OperationQueue.main)
        let downloadTask = urlSession.downloadTask(with: URL(string: realmModelVideo.playUrl)!)
        downloadTask.resume()
    }
    
    func actionVideoFavorite() {
        print("favorite")
    }
}

// MARK: - Video Play
extension VideoPlayViewController {
    
    fileprivate func p_startPlayingVideo() {
        // video from network
        var videoURL: URL!
        if realmModelVideo.playUrl.contains("/downloads/") {
            videoURL = URL(fileURLWithPath: realmModelVideo.playUrl)
        } else if realmModelVideo.playUrl.contains("http") {
            videoURL = URL(string: realmModelVideo.playUrl)
        } else {
            cs_print("unknown video source.")
            return
        }
        
        // info of video
        avPlayerItem = AVPlayerItem(url: videoURL!)
        // use status to check whether can be played now.
        // video can be played once received AVPlayerStatusReadyToPlay
        // loadedTimeRanges means caching progress which can be monitored using KVO
        avPlayerItem.addObserver(self, forKeyPath: "loadedTimeRanges", options: .new, context: nil)
        
        avPlayer = AVPlayer(playerItem: avPlayerItem)
        
        // monitor video playing progress
        avPlayer.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 1),
                                         queue: DispatchQueue.main,
                                         using: { [weak self] (time) in
            guard let strongSelf = self else { return }
            
            let total = lroundf(Float(CMTimeGetSeconds(strongSelf.avPlayerItem.duration)))
            let current = lroundf(Float(CMTimeGetSeconds(time)))
            if current > 0 {
                strongSelf.sliderPlayProgress.value = Float(current) / Float(total)
                
                strongSelf.lbPlayProgress.text = timeString(total - current)
                
//                if !strongSelf.isVideoPlaying {
//                    strongSelf.p_hideVideoOperationView()
//                }
            }
            
            // also can use notification AVPlayerItemDidPlayToEndTime
            if strongSelf.sliderPlayProgress.value == 1 {
                strongSelf.btnPlayVideoNetwork.setImage(UIImage(named: "btnPlay"), for: .normal)
                strongSelf.sliderPlayProgress.value = 0
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
    }

    // Use KVO to monitor cache progress
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let keyPath = keyPath else { return }
        
        if keyPath == "loadedTimeRanges" {
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
}

// MARK: - URLSessionDownloadDelegate
extension VideoPlayViewController: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("done")
        let docDir = FileManager.default.cs.documentsDirectory
        let videosDir = "\(docDir)/downloads/videos"
        if FileManager.default.fileExists(atPath: videosDir) == false {
            do {
                try FileManager.default.createDirectory(atPath: videosDir,
                                                        withIntermediateDirectories: true,
                                                        attributes: nil)
            } catch {
                cs_print("fail to create directory \(videosDir)")
            }
        }
        let videoPath = "\(videosDir)/\(realmModelVideo.title).mp4"
        let toURL = NSURL(fileURLWithPath: videoPath)
        do {
            try FileManager.default.moveItem(at: location, to: toURL as URL)
            realmModelVideo.playUrl = "\(realmModelVideo.title).mp4"
            realmModelVideo.save()
        } catch {
            cs_print("fail to move video \(realmModelVideo.title)")
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        print("downloading \(progress)")
        progressViewVideoDownload.progress = progress
    }
}

