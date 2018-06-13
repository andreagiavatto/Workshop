//
//  CustomCollectionViewCell.swift
//  Workshop-CollectionView
//
//  Created by Andrea on 15/04/2018.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var gifImageView: UIImageView!
    @IBOutlet weak var gifTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderColor = UIColor.blue.cgColor
        layer.borderWidth = 2.0
        layer.cornerRadius = 4.0
    }
}
