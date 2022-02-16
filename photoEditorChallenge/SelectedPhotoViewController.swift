//
//  SelectedPhotoViewController.swift
//  photoEditorChallenge
//
//  Created by Anil Thomas on 2/15/22.
//

import UIKit
import CoreImage
import JLStickerTextView
import TextDrawer


class SelectedPhotoViewController: UIViewController {
   
   // @IBOutlet var stickerView: JLStickerImageView!
   // stickerView.addLabel()
    
     var imageToDisplay : UIImage?
    var imageFile : Data?
    @IBOutlet weak var selectedPhotoView: JLStickerImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedPhotoView.image = imageToDisplay
       
    }
    
    let context = CIContext(options: nil)

        @IBAction func applyFilter(sender: AnyObject) {

            // Create an image to filter
            let inputImage = CIImage(image: selectedPhotoView.image!)

            // Create a random color to pass to a filter
            let randomColor = [kCIInputAngleKey: (Double(arc4random_uniform(314)) / 100)]

            // Apply a filter to the image
            let filteredImage = inputImage!.applyingFilter("CIHueAdjust", parameters: randomColor)

            // Render the filtered image
            let renderedImage = context.createCGImage(filteredImage, from: filteredImage.extent)

            // Reflect the change back in the interface
            selectedPhotoView.image = UIImage(cgImage: renderedImage!)

        }
    

    @IBAction func resetButtonTapped(_ sender: UIButton) {
      selectedPhotoView.image = imageToDisplay
      //  stickerView.addLabel()
    }
    

    
    @IBAction func saveButonTapped(_ sender: UIButton) {
        print("Will save the photo soon")
      
        
    }
    
    @IBAction func addTextButtonTapped(_ sender: UIButton) {
        selectedPhotoView.addLabel()
        
    }
    

}

