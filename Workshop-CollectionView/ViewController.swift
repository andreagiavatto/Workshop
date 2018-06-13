//
//  ViewController.swift
//  Workshop-CollectionView
//
//  Created by Andrea on 14/04/2018.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var gifs: [Result.Gif]?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let pinterestLayout = PinterestLayout()
        pinterestLayout.delegate = self
        collectionView.collectionViewLayout = pinterestLayout
        
        fetchGIFs { [weak self] (result) in
            DispatchQueue.main.async {
                self?.gifs = result?.gifs
                self?.collectionView.reloadData()
            }
        }
    }
    
    func fetchGIFs(completion: ((Result?) -> Void)?) {

        guard let trendingURL = URL(string: "\(Giphy.host)\(Giphy.path)?api_key=\(Giphy.apiKey)") else {
            completion?(nil)
            return
        }
        var request = URLRequest(url: trendingURL)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            let result = self.parseResponse(data: data)
            completion?(result)
        }.resume()
    }

    func parseResponse(data: Data?) -> Result? {

        guard let data = data else {
            return nil
        }

        let decoder = JSONDecoder()
        
        return try? decoder.decode(Result.self, from: data)
    }
    
    func configure(_ cell: CustomCollectionViewCell, at indexPath: IndexPath) {
        
        guard let gif = gifs?[indexPath.item] else {
            return
        }
        cell.gifTitleLabel.text = gif.title
        URLSession.shared.dataTask(with: gif.url) { (data, response, error) in
            DispatchQueue.main.async {
                if let data = data, let image = UIImage.gifImageWithData(data: data as NSData) {
                    cell.gifImageView.image = image
                }
            }
        }.resume()
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return gifs?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCellIdentifier", for: indexPath) as? CustomCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        configure(cell, at: indexPath)
        return cell
    }
}

extension ViewController: PinterestLayoutDelegate {
    
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        guard
            let gifs = gifs
        else {
            return 0.0
        }
        let gif = gifs[indexPath.item]
        return CGFloat(gif.height)
    }
}
