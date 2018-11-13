
//  EpisodeTableViewController.swift
//  AudioPodcast
//
//  Created by Manh Ha Nguyen on 11/8/18.
//  Copyright © 2018 Manh Ha Nguyen. All rights reserved.
//

import UIKit
import FeedKit
import Alamofire
import SDWebImage

class EpisodeTableViewController: UITableViewController {
    
    var podcast: Podcast? {
        didSet {
            navigationItem.title = podcast?.trackName
        }
            
    }
    
    let cellId = "cellId"
    
    
    
    var episodes = [Episode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupBarButtons()
        parseEpisode()
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: "EpisodeCell", bundle: nil), forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
    }
    
    func setupBarButtons(){
        
        let savedPodcasts = UserDefaults.standard.savedPodcasts()
        
        let isFavorited = savedPodcasts.index(where: {$0.trackName == podcast?.trackName && $0.artistName == podcast?.artistName}) != nil
        
        if isFavorited {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "favorite"), style: .plain, target: nil, action: nil)
            navigationItem.rightBarButtonItem?.tintColor = .orange
            
        } else {
            let favoriteButton = UIBarButtonItem(image: #imageLiteral(resourceName: "favorite"), style: .plain, target: self, action: #selector(handleFavorite))
            navigationItem.rightBarButtonItems = [favoriteButton]
        }
        
        
    }
    
    @objc func handleFavorite() {
        print("saving data into UserDefaults")
        guard let podcast = self.podcast else { return }

        //transfrom podcast into data
        var favoritesList = UserDefaults.standard.savedPodcasts()
        favoritesList.insert(podcast, at: 0)
        
        let data = NSKeyedArchiver.archivedData(withRootObject: favoritesList)
        
        UserDefaults.standard.set(data, forKey: UserDefaults.key)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "favorite"), style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem?.tintColor = .orange
        
        
    }

    
    //MARK: - FeedKit
    func parseEpisode () {
        print(podcast?.feedUrl ?? "")
        
        guard let feedUrl = podcast?.feedUrl else { return }
        guard let url = URL(string: feedUrl) else { return }
        
        DispatchQueue.global(qos: .background).async {
            let parser = FeedParser(URL: url)
            parser.parseAsync { (result) in
                print(result.isSuccess)
                
                switch result {
                case let .rss(feed):
                    var episodes = [Episode]()
                    let imageUrl = feed.iTunes?.iTunesImage?.attributes?.href
                    feed.items?.forEach({ (item) in
                        var episode = Episode(feedItem: item)
                        
                        if episode.imageUrl == nil {
                            episode.imageUrl = imageUrl
                        }
                        
                        episodes.append(episode)
                    })
                    self.episodes = episodes
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    
                    break
                case .atom(_):
                    break
                case .json(_):
                    break
                case .failure(_):
                    break
                }
            }
        }
    }
    
    //MARK: - UITableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! EpisodeCell
        
        let episode = episodes[indexPath.row]
        
        let dateForm = DateFormatter()
        dateForm.dateFormat = "MMM dd, yyyy"
        
        let url = URL(string: episode.imageUrl!)
        
        cell.episodeImageView.sd_setImage(with: url, completed: nil)
        cell.pubdateLabel.text = dateForm.string(from: episode.pudDate!)
        cell.titleLabel.text = episode.title
        cell.descriptionLabel.text = episode.description
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 136
    }
    
    //present indnicator when loading episodes
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        indicatorView.color = UIColor.darkGray
        indicatorView.startAnimating()
        return indicatorView
    }
    
    //hide indicator when loading finished
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return episodes.isEmpty ? 200 : 0
    }
    
    //MARK: Present playerView window
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episode = self.episodes[indexPath.row]
        
        let window = UIApplication.shared.keyWindow
        
        let episodePlayerView = Bundle.main.loadNibNamed("EpisodePlayer", owner: self, options: nil)?.first as! EpisodePlayer
        
        episodePlayerView.episode = episode
        episodePlayerView.frame = self.view.frame
        
        window?.addSubview(episodePlayerView)
    }
    
    //MARK: Download Episode
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let downloadAction = UITableViewRowAction(style: .normal, title: "Download") { (_, _) in
            print("Download Eps to UserDefaults")
            let episode = self.episodes[indexPath.row]
            
            //Download Episode to UserDefaults
            UserDefaults.standard.downloadEpisode(episode: episode)
            
            //Download episode to Local memory with AlamoFire
            
            //store the file in FileManager
            let request = DownloadRequest.suggestedDownloadDestination()
            
            Alamofire.download(episode.streamUrl!, to: request).downloadProgress(closure: { (progress) in
                print(progress.fractionCompleted)
            }).response(completionHandler: { (res) in
                print(res.destinationURL?.absoluteString ?? "")
                
                //update UserDefaults with local downloaded episodes
                var downloadedEpisode = UserDefaults.standard.fetchDownloadedEpisodes()
                guard let index = downloadedEpisode.index(where: { $0.title == episode.title && $0.author == episode.author }) else { return }
                downloadedEpisode[index].fileUrl = res.destinationURL?.absoluteString ?? ""
                
                do {
                    let data = try JSONEncoder().encode(downloadedEpisode)
                    UserDefaults.standard.set(data, forKey: UserDefaults.downloadKey)
                } catch let error {
                    print("Download Failed: ",error)
                }
                
                
            })
        }
        return [downloadAction]
    }
    
}
