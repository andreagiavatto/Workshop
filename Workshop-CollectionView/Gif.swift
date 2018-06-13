//
//  Gif.swift
//  Workshop-CollectionView
//
//  Created by Andrea on 15/04/2018.
//

import Foundation

struct Result: Decodable {
    
    let gifs: [Gif]
    
    enum CodingKeys: String, CodingKey {
        case gifs = "data"
    }
    
    struct Gif: Decodable {
        
        let title: String
        let width: Int
        let height: Int
        let url: URL
        
        enum CodingKeys: String, CodingKey {
            case title
            case images
        }
        
        enum Images: String, CodingKey {
            case original
        }
        
        enum Original: String, CodingKey {
            case url
            case width
            case height
        }
        
        init(from decoder: Decoder) throws {
            
            let values = try decoder.container(keyedBy: CodingKeys.self)
            title = try values.decode(String.self, forKey: .title)
            
            let images = try values.nestedContainer(keyedBy: Images.self, forKey: .images)
            let original = try images.nestedContainer(keyedBy: Original.self, forKey: .original)
            let w = try original.decode(String.self, forKey: .width)
            let h = try original.decode(String.self, forKey: .height)
            width = Int(w)!
            height = Int(h)!
            url = try original.decode(URL.self, forKey: .url)
        }
    }
}
