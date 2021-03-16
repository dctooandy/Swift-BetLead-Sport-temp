//
//  VideoManager.swift
//  betlead
//
//  Created by Victor on 2019/6/20.
//  Copyright © 2019 Andy Chen. All rights reserved.
//

import Foundation
import AVFoundation
import AVKit
extension AVPlayer {
    var isPlaying: Bool {
        get {
            return rate != 0 && error == nil
        }
    }
}

protocol VideoManagerDelegate {
    func videoDidFinish()
    func videoReadyToPlay()
}

extension VideoManagerDelegate {
    func videoDidFinish() {}
    func videoReadyToPlay() {}
}

class VideoManager: NSObject {
    lazy var delegate: VideoManagerDelegate? = nil
    static var share: VideoManager = VideoManager()
    private var avPlayer: AVPlayer?
    private var avPlayerLayer: AVPlayerLayer?
    var isRepeat: Bool = false
    var isPlaying: Bool {
        get {
            return avPlayer?.isPlaying ?? false
        }
    }
    
    deinit {
        print("video manager deinit.")
    }
    
    override init() {
        print("manager did init")
        super.init()
        addObserver()
    }
    
    private func addObserver() {
        
        NotificationCenter.default
            .addObserver(forName:NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                         object:nil,
                         queue:nil) { [weak self] notification in
                            
                            guard let strongSelf = self else { return }
                            strongSelf.delegate?.videoDidFinish()
                            if !strongSelf.isRepeat { return }
                            strongSelf.repeatVideo()
        }
    
    }
    
    
    
    func videoFrom(url: URL?) -> AVPlayerLayer? {
        if let url = url {
            avPlayer = AVPlayer(url:url)
            avPlayerLayer = AVPlayerLayer(player: self.avPlayer)
            avPlayerLayer?.videoGravity = .resizeAspectFill
            avPlayer?.addObserver(self, forKeyPath: "status", options: .initial, context: nil)
            
        }
        
        return avPlayerLayer
    }
    
    func play() {
        self.avPlayer?.play()
    }
    
    func pause() {
        self.avPlayer?.pause()
    }
    
    func replayVideo() {
        avPlayer?.seek(to:CMTime.zero)
        avPlayer?.play()
    }
    
    private func repeatVideo() {
        avPlayer?.seek(to:CMTime.zero)
        avPlayer?.play()
    }

    func closeVideo() {
        if isPlaying {
            avPlayer?.pause()
        }
        avPlayerLayer?.removeFromSuperlayer()
        avPlayer = nil
        avPlayerLayer = nil
    }
    
    func setVideoLayer(hidden: Bool) {
        self.avPlayerLayer?.isHidden = hidden
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "status" , let avPlayer = avPlayer {
        
            switch avPlayer.status {
    
            case .readyToPlay:
                self.delegate?.videoReadyToPlay()
            default:
                break
            }
        }
    
    }
    
}
