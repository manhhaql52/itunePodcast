//
//  PodcastCell.swift
//  AudioPodcast
//
//  Created by Manh Ha Nguyen on 11/6/18.
//  Copyright © 2018 Manh Ha Nguyen. All rights reserved.
//

import UIKit
import SDWebImage

class PodcastCell: UITableViewCell {
    
    @IBOutlet weak var podcastImageView: UIImageView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var episodeLabel: UILabel!
    
    var podcast: Podcast! {
        didSet {
            trackNameLabel.text = podcast.trackName
            artistNameLabel.text = podcast.artistName
            episodeLabel.text = "\(podcast.trackCount ?? 0) episodes"
            
            guard let url = URL(string: podcast.artworkUrl600 ?? "") else { return }
            
//            URLSession.shared.dataTask(with: url) { (data, _, _) in
//                print(url)
//
//                guard let data = data else { return }
//                self.podcastImageView.image = UIImage(data: data)
//            }.resume()
            
            
            //use SDwebImage for cache image
            podcastImageView.sd_setImage(with: url, completed: nil)
        }
    }
    
}
