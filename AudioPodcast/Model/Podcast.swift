//
//  Podcast.swift
//  AudioPodcast
//
//  Created by Manh Ha Nguyen on 11/6/18.
//  Copyright © 2018 Manh Ha Nguyen. All rights reserved.
//

import Foundation

class Podcast:NSObject, Decodable, NSCoding {
    func encode(with aCoder: NSCoder) {
        print("Trying transfrom podcast into data")
        aCoder.encode(trackName, forKey: "namekey")
        aCoder.encode(artistName, forKey: "artistkey")
        aCoder.encode(artworkUrl600, forKey: "imagekey")
        aCoder.encode(feedUrl, forKey: "feedkey")
    }
    
    required init?(coder aDecoder: NSCoder) {
        print("trying turn data into podcast")
        
        self.trackName = aDecoder.decodeObject(forKey: "namekey") as? String
        self.artistName = aDecoder.decodeObject(forKey: "artistkey") as? String
        self.artworkUrl600 = aDecoder.decodeObject(forKey: "imagekey") as? String
        self.feedUrl = aDecoder.decodeObject(forKey: "feedkey") as? String

    }
    
    var trackName: String?
    var artistName: String?
    var artworkUrl600: String?
    var trackCount:Int?
    var feedUrl:String?
    
}
