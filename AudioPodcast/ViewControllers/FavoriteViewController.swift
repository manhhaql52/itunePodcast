//
//  FavoriteViewController.swift
//  AudioPodcast
//
//  Created by Manh Ha Nguyen on 11/10/18.
//  Copyright © 2018 Manh Ha Nguyen. All rights reserved.
//

import UIKit

class FavoriteViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    var podcasts = UserDefaults.standard.savedPodcasts()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        podcasts = UserDefaults.standard.savedPodcasts()
        collectionView?.reloadData()
    }
    
    func setupCollectionView() {
        collectionView?.backgroundColor = .white
        
        collectionView?.register(FavoritePodcastCell.self, forCellWithReuseIdentifier: cellId)
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        collectionView?.addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        
        let location = gesture.location(in: collectionView)
        
        guard let selectedItem = collectionView?.indexPathForItem(at: location) else { return }
        print(selectedItem.item)
        
        let postcast = podcasts[selectedItem.item]
        
        let alertController = UIAlertController(title: "Remove '\(podcasts[selectedItem.item].trackName ?? "")' from favorites?", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
            
            //remove item from array first
            self.podcasts.remove(at: selectedItem.item)
            
            //then remove item from collectionView
            self.collectionView?.deleteItems(at: [selectedItem])
            
            //remove item from UserDefaults
            UserDefaults.standard.removePodcast(podcast: postcast)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alertController, animated: true)
        
    }
    
    //MARK: - UICollectionView
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return podcasts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FavoritePodcastCell
        cell.podcast = self.podcasts[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width - 3 * 16) / 2
        
        return CGSize(width: width, height: width + 42)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let episodeController = EpisodeTableViewController()
        episodeController.podcast = self.podcasts[indexPath.item]
        navigationController?.pushViewController(episodeController, animated: true)
    }
}

