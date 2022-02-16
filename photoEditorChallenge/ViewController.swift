//
//  ViewController.swift
//  photoEditorChallenge
//
//  Created by Anil Thomas on 2/15/22.
//

import UIKit

class ViewController: UIViewController {
    
    var reciever = PhotoRecieverFromWeb()
    
    var array : [PhotoWebData]?
    var imageToDisplay : UIImage? = UIImage(named: "austin-smart-70350")
    
    @IBOutlet weak var imageSelectedView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reciever.delegate = self
        // Do any additional setup after loading the view.
    }

    @IBAction func startButtonPressed(_ sender: UIButton){
       
            
            self.reciever.getUrlData()
          // print("printing....")
            
            //print(array)
            
    
    
    }
    


}


// MARK: -


extension ViewController: PhotoArrayUpdateDelegate{
    func updatePhotoArray(with photoArray: [Data]) {
        DispatchQueue.main.async {
            print("Working array is:")
            print(photoArray)
        }
    }
    
    func updateUrlArray(_ urlArrayStorage: [PhotoWebData]) {
        DispatchQueue.main.async {
            self.array = urlArrayStorage
            print(self.array)
    }
    
    }
    
    func didErrorOccur(error: Error) {
        print(error)
    }
    
    
//    func updateUrlArray(_ photoArrayStorage: [PhotoAppModel]) {
//        DispatchQueue.main.async {
//            self.array = photoArrayStorage
//            print(self.array?[1])
//            if let image = self.array?[1].photoUrl{
//                self.loadImage(with: image)
//
//
//            }
//            else{
//                print("Error loading image")
//            }
//
//         //   print("Printing Final array here as: ")
//           // print(self.array)
//        }
//
//    }
    
    
    func loadImage(with imageString: String) -> UIImage?{
        let pictureUrl = URL(string: imageString)!

        // Creating a session object with the default configuration.
        let session = URLSession(configuration: .default)

        // Define a download task. The download task will download the contents of the URL as a Data object.
        
        let downloadImageTask = session.dataTask(with: pictureUrl) { (data, response, error) in
            // The download has finished.
            if error != nil {
                print("Error downloading cat picture: \(error)")
            } else {
                // No errors found.
               
           
                   
                    if let imageData = data {
                        // Converting data to UIImage format
                        
                        self.imageToDisplay = UIImage(data: imageData)
                        DispatchQueue.main.async {
                            self.imageSelectedView.image = self.imageToDisplay ?? UIImage(named: "austin-smart-70350")
                        }
                      
                    } else {
                        print("Couldn't get image: Image is nil")
                    }
                }
        }

        downloadImageTask.resume()
        return imageToDisplay ?? nil
    }

}
