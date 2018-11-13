//
//  FavoritePodcastCell.swift
//  AudioPodcast
//
//  Created by Manh Ha Nguyen on 11/10/18.
//  Copyright © 2018 Manh Ha Nguyen. All rights reserved.
//

import UIKit

class FavoritePodcastCell: UICollectionViewCell {
    
    var podcast: Podcast! {
        didSet {
            artistName.text = podcast.artistName
            title.text = podcast.trackName
            
            let url = URL(string: podcast.artworkUrl600 ?? "")
            
            imageView.sd_setImage(with: url, completed: nil)
        }
    }
    
    let imageView = UIImageView(image: #imageLiteral(resourceName: "podIcon"))
    let artistName = UILabel()
    let title = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
 
        setupStyling()
        setupAnchor()
    }
    
    func setupStyling() {
        artistName.text = "artist Name"
        artistName.textColor = UIColor.darkGray
        
        title.text = "Track Name"
        title.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
    }
    
    func setupAnchor() {
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
        let stackView = UIStackView(arrangedSubviews: [imageView, title, artistName])
        
        stackView.axis = .vertical
        
        //auto layout
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
