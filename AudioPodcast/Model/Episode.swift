//
//  Episode.swift
//  AudioPodcast
//
//  Created by Manh Ha Nguyen on 11/8/18.
//  Copyright © 2018 Manh Ha Nguyen. All rights reserved.
//

import FeedKit

struct Episode: Encodable, Decodable {
    let title: String?
    let author: String?
    let pudDate: Date?
    let description: String?
    
    let streamUrl: String?
    var imageUrl: String?
    var fileUrl: String?
    
    init(feedItem: RSSFeedItem) {
        
        self.title = feedItem.title ?? ""
        self.author = feedItem.iTunes?.iTunesAuthor ?? ""
        self.pudDate = feedItem.pubDate ?? Date()
        self.description = feedItem.iTunes?.iTunesSubtitle ?? feedItem.iTunes?.iTunesSummary ?? feedItem.description ?? ""
        self.imageUrl = feedItem.iTunes?.iTunesImage?.attributes?.href
        self.streamUrl = feedItem.enclosure?.attributes?.url ?? ""
    }
}
