//
//  CollectionViewController.swift
//  photoEditorChallenge
//
//  Created by Anil Thomas on 2/15/22.
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
    
    var array : [PhotoAppModel]?
    var imageToDisplay : UIImage? = UIImage(named: "austin-smart-70350")
    
    var imageArray : [UIImage] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.reciever.getUrlData()
        
        reciever.delegate = self
        
      //  print("*********^^^^^^^^^^^^^***************")
     self.collectionView.register(PhotoArrayCollectionViewCell.nib(), forCellWithReuseIdentifier: "PhotoArrayCollectionViewCell")
        
      //  self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: imageWidth, height: imageWidth)
        
        collectionView.collectionViewLayout = layout
        collectionView.reloadData()
      
    }
    
    

  
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
       
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return imagesArray.count ?? 3
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoArrayCollectionViewCell
        //cell.backgroundColor = .blue
        var image = UIImage(data: imagesArray[indexPath.row])
        cell.photoView.image = image
        // Configure the cell
    
        return cell
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


extension PhotoCollectionViewController: PhotoArrayUpdateDelegate{
    func updatePhotoArray(with photoArray: [Data]) {
        DispatchQueue.main.async {
            print("Working array is:")
            self.imagesArray = photoArray
            print(photoArray)
            self.collectionView.reloadData()
        }
       
    }
    
    func updateUrlArray(_ urlArrayStorage: [PhotoWebData]) {
        DispatchQueue.main.async {
            print(urlArrayStorage)
    }
    
    }
    

    
    func didErrorOccur(error: Error) {
        print(error)
    }
    
    
    func updatePhotoArray(_ photoArrayStorage: [PhotoAppModel]) {
        DispatchQueue.main.async {
            self.array = photoArrayStorage
            
            print("printing...")
            print(self.array?[1])
        
            if let image = self.array?[1].photoUrl{
                print("******1")
                print(image)
                self.loadImage(with: image)
                
               
            }
            else{
                print("Error loading image")
            }
           
         //   print("Printing Final array here as: ")
           // print(self.array)
        }
       
    }
    
    
    func loadImage(with imageString: String) {
        let pictureUrl = URL(string: imageString)!
        print("******2")
          print(pictureUrl)
        // Creating a session object with the default configuration.
        let session = URLSession(configuration: .default)

        // Define a download task. The download task will download the contents of the URL as a Data object.
        
        let downloadImageTask = session.dataTask(with: pictureUrl) { (data, response, error) in
            // The download has finished.
            if error != nil {
                print("Error downloading cat picture: \(error)")
            } else {
                // No errors found.
               
                 print("********3")
                print(data)
                   
                    if let imageData = data {
                        // Converting data to UIImage format
                        
                        self.imageToDisplay = UIImage(data: imageData)
                        self.imageArray.append((self.imageToDisplay ?? UIImage(named: "austin-smart-70350"))!)
                        print("Image array is:")
                        print(self.imageArray)
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                         }else {
                        print("Couldn't get image: Image is nil")
                    }
                }
        

        
        
    }
        downloadImageTask.resume()
}
}
