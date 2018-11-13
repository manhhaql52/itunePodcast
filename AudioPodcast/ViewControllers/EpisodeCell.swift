//
//  EpisodeCell.swift
//  AudioPodcast
//
//  Created by Manh Ha Nguyen on 11/8/18.
//  Copyright © 2018 Manh Ha Nguyen. All rights reserved.
//

import UIKit

class EpisodeCell: UITableViewCell {

    @IBOutlet weak var pubdateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var episodeImageView: UIImageView!
    
    var episode: Episode! {
        didSet {
            let dateForm = DateFormatter()
            dateForm.dateFormat = "MMM dd, yyyy"
            pubdateLabel.text = dateForm.string(from: episode.pudDate!)
            
            titleLabel.text = episode.title
            descriptionLabel.text = episode.description
            guard let url = URL(string: episode.imageUrl ?? "") else { return }
            episodeImageView.sd_setImage(with: url, completed: nil)
        }
    }
    
}
