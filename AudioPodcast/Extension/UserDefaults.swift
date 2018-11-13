//
//  UserDefaults.swift
//  AudioPodcast
//
//  Created by Manh Ha Nguyen on 11/13/18.
//  Copyright © 2018 Manh Ha Nguyen. All rights reserved.
//

import Foundation
extension UserDefaults {
    static let key = "key"
    
    static let downloadKey = "downloadKey"
    
    func downloadEpisode (episode: Episode) {
        do {
            var downloadedEpisodes = fetchDownloadedEpisodes()
            downloadedEpisodes.insert(episode, at: 0)
            let data = try JSONEncoder().encode(downloadedEpisodes)
            UserDefaults.standard.set(data, forKey: UserDefaults.downloadKey)
        } catch let encodeErr {
            print(encodeErr)
        }
    }
    
    func fetchDownloadedEpisodes () -> [Episode] {
        guard let downloadedEpisodeData = UserDefaults.standard.data(forKey: UserDefaults.downloadKey) else { return [] }
        
        do {
            let episodes = try JSONDecoder().decode([Episode].self, from: downloadedEpisodeData)
            return episodes
        } catch let decodeErr {
            print(decodeErr)
        }
        
        
        return []
    }
    
    func savedPodcasts() -> [Podcast] {
        print("Fetching data from UserDefaults")
        
        guard let savedPodcastsData = UserDefaults.standard.data(forKey: UserDefaults.key) else { return []}
        guard let savedPodcasts = NSKeyedUnarchiver.unarchiveObject(with: savedPodcastsData) as? [Podcast] else { return [] }
        return savedPodcasts
    }
    
    func removePodcast(podcast: Podcast) {
        let podcasts = savedPodcasts()
        let filter = podcasts.filter { (pod) -> Bool in
            return pod.trackName != podcast.trackName && pod.artistName != podcast.artistName
        }
        
        let data = NSKeyedArchiver.archivedData(withRootObject: filter)
        UserDefaults.standard.set(data, forKey: UserDefaults.key)
    }
    
}
