//
//  AlbumsViewController.swift
//  lab-tunley
//
//  Created by Andrea Labra Orozco on 3/05/23.
//

import UIKit
import Nuke //load album images

class AlbumsViewController: UIViewController, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
  
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as! AlbumCell

        let album = albums[indexPath.item]
   
        let imageUrl = album.artworkUrl100
  
        Nuke.loadImage(with: imageUrl, into: cell.albumImageView)
  
        return cell
    }
    


    @IBOutlet weak var collectionView: UICollectionView!
    
   
    var albums: [Album] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()


        collectionView.dataSource = self
        
        /// Create a searhc URL for fetching albums (`entity = album`)
        let url = URL(string: "https://itunes.apple.com/search?term=blackpink&attribute=artistTerm&entity=album&media=music")!
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            
            // Network errors
            if let error = error {
                print ("❌ Network error: \(error.localizedDescription)")
            }
            
            // did the data load?
            guard let data = data else {
                print("❌ Data is nil")
                return
            }
            
            // Create a JSON Decoder
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(AlbumSearchResponse.self, from: data)
                let albums = response.results
                
                print("\n\nAlbums:\n\n")
                print(albums)
                
                DispatchQueue.main.async {
                    self?.albums = albums
                    self?.collectionView.reloadData()
                }
            }
            catch {
                print(error.localizedDescription)
            }
            
        }
        
        // Initiate the network request
        task.resume()
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.minimumInteritemSpacing = 4
       
        layout.minimumLineSpacing = 4
        
        let numberOfColumns: CGFloat = 3
       
        let width = (collectionView.bounds.width - layout.minimumInteritemSpacing * (numberOfColumns - 1)) / numberOfColumns

        layout.itemSize = CGSize(width: width, height: width)
        
    }

}
