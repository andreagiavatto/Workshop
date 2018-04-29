//
//  Gif.swift
//  Workshop-CollectionView
//
//  Created by Andrea on 15/04/2018.
//

import Foundation

struct Gifs: Decodable {
    
    let gifs: [Gif]
    
    enum CodingKeys: String, CodingKey {
        case gifs = "data"
    }
    
    struct Gif: Decodable {
        
        let title: String
        let url: URL
        
        enum CodingKeys: String, CodingKey {
            case title
            case images
        }
        
        enum Images: String, CodingKey {
            case fixedHeight = "fixed_height"
        }
        
        enum FixedHeight: String, CodingKey {
            case url
        }
        
        init(from decoder: Decoder) throws {
            
            let values = try decoder.container(keyedBy: CodingKeys.self)
            title = try values.decode(String.self, forKey: .title)
            
            let images = try values.nestedContainer(keyedBy: Images.self, forKey: .images)
            let fixedHeight = try images.nestedContainer(keyedBy: FixedHeight.self, forKey: .fixedHeight)
            url = try fixedHeight.decode(URL.self, forKey: .url)
        }
    }
}
