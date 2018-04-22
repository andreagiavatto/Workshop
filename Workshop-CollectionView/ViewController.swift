//
//  ViewController.swift
//  Workshop-CollectionView
//
//  Created by Andrea on 14/04/2018.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var gifs = [Gif]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = CGSize(width: collectionView.bounds.width, height: collectionView.bounds.width)
        }
        
        fetchGIFs { [weak self] (gifs) in
            DispatchQueue.main.async {
                if let gifs = gifs {
                    self?.gifs.append(contentsOf: gifs)
                    self?.collectionView.reloadData()
                }
            }
        }
    }
    
    func fetchGIFs(completion: (([Gif]?) -> Void)?) {

        guard let trendingURL = URL(string: "\(Giphy.host)\(Giphy.path)?api_key=\(Giphy.apiKey)") else {
            completion?(nil)
            return
        }
        var request = URLRequest(url: trendingURL)
        request.httpMethod = "GET"
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            let gifs = self.parseResponse(data: data)
            completion?(gifs)
        }.resume()
    }

    func parseResponse(data: Data?) -> [Gif]? {

        guard let data = data else {
            return nil
        }

        var gifs: [Gif]?
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: AnyObject], let gifsList = json["data"] as? [[String: Any]] {
                gifs = gifsList.compactMap { return Gif(json: $0) }
            }
        } catch {}

        return gifs
    }
    
    func configure(_ cell: CustomCollectionViewCell, at indexPath: IndexPath) {
        
        let gif = gifs[indexPath.item]
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
        
        return gifs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCellIdentifier", for: indexPath) as? CustomCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        configure(cell, at: indexPath)
        return cell
    }
}
