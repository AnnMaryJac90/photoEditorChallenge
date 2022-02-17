//
//  CollectionViewController.swift
//  photoEditorChallenge
//
//  Created by Ann Mary Jacob on 2/15/22.
//

import UIKit

//private let reuseIdentifier = "photoCell"
private let reuseIdentifier = "PhotoArrayCollectionViewCell"

private let itemsPerRow: CGFloat = 3

private let sectionInsets = UIEdgeInsets(
  top: 50.0,
  left: 20.0,
  bottom: 50.0,
  right: 20.0)
var imageWidth = 0.0
var imageHeight = 0.0

class PhotoCollectionViewController: UICollectionViewController {
    
    var reciever = PhotoRecieverFromWeb()
    var imagesArray : [Data] = []
    var imageSelected : UIImage?
    var imageFile : Data?
    
    var array : [PhotoAppModel]?
    var imageToDisplay : UIImage?
    
    var imageArray : [UIImage] = []

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.reciever.getUrlData()
        
    // Setting the delegate for protocol defined within photoRecieverFromWeb
        
        reciever.delegate = self
        
    //Registering the nib to PhotoCell
        self.collectionView.register(PhotoArrayCollectionViewCell.nib(), forCellWithReuseIdentifier: "PhotoArrayCollectionViewCell")
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: imageWidth, height: imageWidth)
        collectionView.collectionViewLayout = layout
        collectionView.reloadData()
      
    }
    
    

  
    //MARK: -    UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
       
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return imagesArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoArrayCollectionViewCell
        let image = UIImage(data: imagesArray[indexPath.row])
        imageFile = imagesArray[indexPath.row]
        cell.photoView.image = image
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        
       imageSelected = UIImage(data: imagesArray[indexPath.row])
        
    // Selected Photo to a new View
        
        self.performSegue(withIdentifier: "toSelectedPhotoView", sender: self)
        
    }


    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSelectedPhotoView" {
            var selectedPhotoObj = segue.destination as! SelectedPhotoViewController
            selectedPhotoObj.imageToDisplay = imageSelected
            selectedPhotoObj.imageFile = imageFile
        }
    }

}



// MARK: - Collection View Flow Layout Delegate


extension PhotoCollectionViewController: UICollectionViewDelegateFlowLayout {
  // 1
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    // 2
    let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
    let availableWidth = view.frame.width - paddingSpace
    let widthPerItem = availableWidth / itemsPerRow
    imageWidth = widthPerItem
    imageHeight = widthPerItem
    return CGSize(width: widthPerItem, height: widthPerItem)
  }
  
  // 3
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    insetForSectionAt section: Int
  ) -> UIEdgeInsets {
    return sectionInsets
  }
  
  // 4
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    return sectionInsets.left
  }
}


//MARK: -  Delegate Protocol definition

extension PhotoCollectionViewController: PhotoArrayUpdateDelegate{
    func updatePhotoArray(with photoArray: [Data]) {
     
        DispatchQueue.main.async {
           // Accessing the photos from web
            self.imagesArray = photoArray
            self.collectionView.reloadData()
           
        }
      
       
    }
    
    
   
    


}
