//
//  SearchTableViewController.swift
//  AudioPodcast
//
//  Created by Manh Ha Nguyen on 11/6/18.
//  Copyright © 2018 Manh Ha Nguyen. All rights reserved.
//

import UIKit
import Alamofire

class SearchTableViewController: UITableViewController, UISearchBarDelegate {
    
    var podcasts = [Podcast]()
    
    let cellId = "cellId"
    
    let searchController = UISearchController(searchResultsController: nil)
    
    struct SearchResult: Decodable {
        let resultCount: Int
        let results: [Podcast]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        
        setupTableView()
        
        searchBar(searchController.searchBar, textDidChange: "Voong")
 
    }
    
    //MARK: SearchController
    func setupSearchBar() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        
        //SearchTableViewController is covered when the PodcastCell presents episodeVC.
        self.definesPresentationContext = true
    }
    
    func setupTableView() {
        
        //remove line section
        tableView.tableFooterView = UIView()
        
        //1. register cell
        tableView.register(UINib(nibName: "PodcastCell", bundle: nil), forCellReuseIdentifier: cellId)
    }
    
    
    var timer: Timer?
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        //let url = "https://itunes.apple.com/search?term=\(searchText)"
        
        
        let url = "https://itunes.apple.com/search"
        let parameters = ["term": searchText, "media": "podcast"]
        
        //set delay when begin searching
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (timer) in
            //MARK: - ALAMOFIRE SERVICE
            
            //Encode defaut will replace space character with %20
            Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil).responseData { (dataResponse) in
                if let error = dataResponse.error {
                    print(error)
                    return
                }
                
                guard let data = dataResponse.data else { return }
                
                do {
                    let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
                    
                    self.podcasts = searchResult.results
                    self.tableView.reloadData()
                } catch let error {
                    print(error)
                }
            }
        })
    }
    
    //MARK: UITableView
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.text = "Search Podcast"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return podcasts.count > 0 ? 0 : 300
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! PodcastCell
        
        let podcast = podcasts[indexPath.row]
        
        cell.podcast = podcast
        cell.selectionStyle = .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 132
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let episodeVC = EpisodeTableViewController()
        let podcast = self.podcasts[indexPath.row]
        episodeVC.podcast = podcast
        navigationController?.pushViewController(episodeVC, animated: true)
    }
    

}
