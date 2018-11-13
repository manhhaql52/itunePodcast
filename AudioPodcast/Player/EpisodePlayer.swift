//
//  EpisodePlayer.swift
//  AudioPodcast
//
//  Created by Manh Ha Nguyen on 11/8/18.
//  Copyright © 2018 Manh Ha Nguyen. All rights reserved.
//

import UIKit
import AVKit

class EpisodePlayer: UIView {
    
    //MARK: - @IBOulet
    @IBOutlet weak var episodeImageView: UIImageView!
    @IBOutlet weak var episodeTitleLabel: UILabel!
    @IBOutlet weak var episodeAuthorLabel: UILabel!
    
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var currentTimeslider: UISlider!
    @IBOutlet weak var currentVolumeSlider: UISlider!
    
    @IBOutlet weak var playPauseButton: UIButton! {
        didSet {
            playPauseButton.setImage(#imageLiteral(resourceName: "play64"), for: .normal)
            playPauseButton.addTarget(self, action: #selector(handlePlayPause), for: .touchUpInside)
        }
    }
    
    var episode: Episode! {
        didSet {
            guard let url = URL(string: episode.imageUrl!) else {return}
            
            episodeImageView.sd_setImage(with: url, completed: nil)
            
            episodeTitleLabel.text = episode.title
            episodeAuthorLabel.text = episode.author
            
            playPodcast()
        }
    }
    
    var episodes = [Episode]()
    
    
    
    //MARK: awakeFromNib - time observer
    override func awakeFromNib() {
        super.awakeFromNib()
        
        timeObserver()
        
//        if let currentSliderValue = UserDefaults.standard.value(forKey: "sliderValue") {
//            currentTimeslider.value = currentSliderValue as! Float
//            
//        }
//        
//        if let currentTime = UserDefaults.standard.string(forKey: "timeKey") {
//            self.currentTimeLabel.text = currentTime
//            
//            let string = currentTime.components(separatedBy: CharacterSet.decimalDigits.inverted)
//            for char in string {
//                if let value = Int(char) {
//                    let currentTimePlay = CMTimeMakeWithSeconds(Float64(value), 1)
//                    let timeSeeker = CMTimeAdd(player.currentTime(), currentTimePlay)
//                    player.seek(to: timeSeeker)
//                }
//            }
//            
//        }
        
        if let currentVolume = UserDefaults.standard.value(forKey: "volumeKey") {
            self.currentVolumeSlider.value = currentVolume as! Float
            player.volume = currentVolume as! Float
        }
    }
    //[ weak self ] is for interrupt Retain Cycle,(stop playing the podcast when dismiss)
    
    func timeObserver() {
        let interval = CMTime(seconds: 1, preferredTimescale: 3)
        player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] (time) in
            
            //current player time
            let timePlayed = Int(CMTimeGetSeconds(time))
            print("Time played: ", timePlayed)
            let secondsPlayed = timePlayed % 60
            let minutesPlayed = timePlayed / 60
            let formattedCurrentTimeString = String(format: "%02d:%02d", minutesPlayed, secondsPlayed)
            self?.currentTimeLabel.text = formattedCurrentTimeString
            
            //save current playing time value to UserDefaults
            UserDefaults.standard.set(formattedCurrentTimeString, forKey: "timeKey")
            
            //duration time
            guard let duration = self?.player.currentItem?.duration else { return }
            let durationInt = Int(CMTimeGetSeconds(duration))
            let secondsDuration = durationInt % 60
            let minutesDuration = durationInt / 60
            let formattedDurationTimeString = String(format: "%02d:%02d", minutesDuration, secondsDuration)
            self?.durationLabel.text = formattedDurationTimeString
            
            self?.observerCurrentTimeSlider()
        }
    }
    
    //observe current time value change on slider value
    func observerCurrentTimeSlider(){
        let currentTime = CMTimeGetSeconds(player.currentTime())
        let duration = CMTimeGetSeconds((player.currentItem?.duration)!)
        let sliderBarPercentage = currentTime / duration
        self.currentTimeslider.value = Float(sliderBarPercentage)
        
        //save current slider value to UserDefaults
        UserDefaults.standard.set(Float(sliderBarPercentage), forKey: "sliderValue")
    }
    
    //MARK: - AVKit
    @objc func handlePlayPause() {
        if player.timeControlStatus == .paused {
            player.play()
            playPauseButton.setImage(#imageLiteral(resourceName: "pause64"), for: .normal)
            print("Playing", episode.title ?? "")
            
        } else {
            player.pause()
            playPauseButton.setImage(#imageLiteral(resourceName: "play64"), for: .normal)
            print("Paused", episode.title ?? "")
        }
    }
    
    
    
    let player: AVPlayer = {
        let avPlayer = AVPlayer()
        
        //set player delay to false
        avPlayer.automaticallyWaitsToMinimizeStalling = false
        return avPlayer
    }()
    
    func playPodcast() {
        
        if episode.fileUrl != nil {
            playEpisodeFileUrl()
        } else {
            playEpisodeStreamUrl()
        }

    }
    
    func playEpisodeFileUrl() {
        print("Playing episode at fileUrl: ", episode.fileUrl ?? "")
        guard let url = URL(string: episode.fileUrl ?? "") else { return }
        
        let fileName = url.lastPathComponent
        
        guard var location = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        location.appendPathComponent(fileName)
        
        print(location.absoluteString)
        
        
        let playerItem = AVPlayerItem(url: location)
        player.replaceCurrentItem(with: playerItem)
    }
    
    func playEpisodeStreamUrl () {
        print("Playing episode at streamUrl: ", episode.streamUrl ?? "" )
        guard let url = URL(string: episode.streamUrl!) else { return }
        let playerItem = AVPlayerItem(url: url)
        player.replaceCurrentItem(with: playerItem)
    }
    
    //MARK: - @IBAction
    
    @IBAction func handleTimeSliderChange(_ sender: UISlider) {
        let currentTimeSliderValue = currentTimeslider.value
        guard let duration = player.currentItem?.duration else { return }
        
        let timeSeekValue = Float64(currentTimeSliderValue) * CMTimeGetSeconds(duration)
        let timeSeeker = CMTimeMakeWithSeconds(timeSeekValue, Int32(NSEC_PER_SEC))
        player.seek(to: timeSeeker)
    }
    
    
    @IBAction func handleRewind(_ sender: Any) {
        let rewindValueInSecond = CMTimeMakeWithSeconds(-10, 1)
        let timeSeeker = CMTimeAdd(player.currentTime(), rewindValueInSecond)
        player.seek(to: timeSeeker)
    }
    
    @IBAction func handleForward(_ sender: Any) {
        let forwardValueInSecond = CMTimeMakeWithSeconds(10, 1)
        let timeSeeker = CMTimeAdd(player.currentTime(), forwardValueInSecond)
        player.seek(to: timeSeeker)
    }
    
    @IBAction func handleVolumeChange(_ sender: UISlider) {
        player.volume = sender.value
        
        //save current volume to Userdefaults
        UserDefaults.standard.set(Float(sender.value), forKey: "volumeKey")
    }
    
    @IBAction func dismissPressed(_ sender: Any) {
        self.removeFromSuperview()
    }
    
}
