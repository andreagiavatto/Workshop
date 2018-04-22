//
//  Gif.swift
//  Workshop-CollectionView
//
//  Created by Andrea on 15/04/2018.
//

import Foundation

class Gif {
    let title: String
    let url: URL
    
    init(title: String, url: URL) {
        self.title = title
        self.url = url
    }
    
    convenience init?(json: [String: Any]) {
        guard
            let title = json["title"] as? String,
            let images = json["images"] as? [String: Any],
            let fixedHeight = images["fixed_height"] as? [String: Any],
            let urlString = fixedHeight["url"] as? String,
            let url = URL(string: urlString)
            else {
                return nil
        }
        
        self.init(title: title, url: url)
    }
}
