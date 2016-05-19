//
//  SCWaveScrollViewController.swift
//  WaveFormRepresentation
//
//  Created by Maneesh Madan on 10/1/15.
//  Copyright (c) 2015 Example. All rights reserved.
//

import UIKit
import MediaPlayer

class SCWaveScrollViewController: UIViewController,MPMediaPickerControllerDelegate {
   
    var mediaPicker: MPMediaPickerController?
    var myMusicPlayer: MPMusicPlayerController?
    
    @IBOutlet weak var musicLabel: UILabel!
    @IBOutlet weak var scrollableWaveformView: SCScrollableWaveformView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func mediaPicker(mediaPicker: MPMediaPickerController,
        didPickMediaItems mediaItemCollection: MPMediaItemCollection){
            myMusicPlayer = MPMusicPlayerController()
                myMusicPlayer!.setQueueWithItemCollection(mediaItemCollection)
                myMusicPlayer!.play()
            if (myMusicPlayer!.nowPlayingItem != nil) {
                let assetURL: NSURL = self.myMusicPlayer!.nowPlayingItem!.valueForProperty(MPMediaItemPropertyAssetURL) as! NSURL
                self.scrollableWaveformView.waveformView.precision = 1
                self.scrollableWaveformView.waveformView.lineWidthRatio = 1
                
                self.scrollableWaveformView.waveformView.channelsPadding = 10
                self.scrollableWaveformView.alpha = 0.8
                
                let asset:AVAsset = AVURLAsset(URL: assetURL, options: nil)
                self.scrollableWaveformView.waveformView.normalColor = UIColor.redColor()
                
                scrollableWaveformView.waveformView.asset = asset
                let progressTime: CMTime = CMTimeMakeWithSeconds(100, 100000)
                scrollableWaveformView.waveformView.timeRange = CMTimeRangeMake(CMTimeMakeWithSeconds(1, 10000), progressTime)
                updateNowPlayingItem()
            }
            mediaPicker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func updateNowPlayingItem(){
        musicLabel.hidden=false
        if let nowPlayingItem=self.myMusicPlayer!.nowPlayingItem{
            let nowPlayingTitle=nowPlayingItem.title
            self.musicLabel.text=nowPlayingTitle
        }else{
            self.musicLabel.text="Please select song to play"
        }
    }
    
    func mediaPickerDidCancel(mediaPicker: MPMediaPickerController) {
        mediaPicker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func displayMediaPickerAndPlayItem(){
        mediaPicker = MPMediaPickerController(mediaTypes: .AnyAudio)
        if let picker = mediaPicker{
            picker.delegate = self
            self.view.addSubview(picker.view)
            self.presentViewController(picker, animated: true, completion: nil)
            
        } else {
            print("Could not instantiate a media picker", terminator: "")
        }
    }
    
    @IBAction func openItunesButtonTapped(sender: AnyObject) {
         displayMediaPickerAndPlayItem()
    }
}
