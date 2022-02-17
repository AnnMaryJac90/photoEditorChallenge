//
//  PhotoArrayCollectionViewCell.swift
//
//  Created by Ann Mary Jacob on 2/15/22.
//  Subclass of collectionViewCell to add image to a cell

import UIKit

class PhotoArrayCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static func nib() -> UINib{
        return UINib(nibName: "PhotoArrayCollectionViewCell", bundle: nil)
    }
}
