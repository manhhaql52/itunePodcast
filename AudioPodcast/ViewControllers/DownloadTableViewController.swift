//
//  DownloadTableViewController.swift
//  AudioPodcast
//
//  Created by Manh Ha Nguyen on 11/13/18.
//  Copyright © 2018 Manh Ha Nguyen. All rights reserved.
//

import UIKit

class DownloadTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        episodes = UserDefaults.standard.fetchDownloadedEpisodes()
        tableView.reloadData()
    }
    
    let cellId = "cellId"
    
    var episodes = UserDefaults.standard.fetchDownloadedEpisodes()
    
    func setupTableView() {
        tableView.register(UINib(nibName: "EpisodeCell", bundle: nil), forCellReuseIdentifier: cellId)
    }

    // MARK: - UITableView

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return episodes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EpisodeCell
        let episode = episodes[indexPath.row]
        cell.episode = episode
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 136
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Playing Downloaded Episode")
        let episode = episodes[indexPath.row]
        
        if episode.fileUrl != nil {
            let window = UIApplication.shared.keyWindow
            
            let episodePlayerView = Bundle.main.loadNibNamed("EpisodePlayer", owner: self, options: nil)?.first as! EpisodePlayer
            
            episodePlayerView.episode = episode
            episodePlayerView.frame = self.view.frame
            
            window?.addSubview(episodePlayerView)
        }
        
        
    }
}
