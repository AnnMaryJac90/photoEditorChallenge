//
//  PhotoArrayCollectionViewCell.swift
//  photoEditorChallenge
//
//  Created by Anil Thomas on 2/15/22.
//

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
