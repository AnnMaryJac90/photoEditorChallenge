//
//  SelectedPhotoViewController.swift
//
/*  Functionalities :
        > Apply filter to image
        > Reset the applied filter
        > Add text to image
        > Save the image to the given url
 */
//
//  Created by Ann Mary Jacob on 2/15/22.
//
import UIKit
import CoreImage
import JLStickerTextView
import Alamofire

class SelectedPhotoViewController: UIViewController {
    
    var imageToDisplay : UIImage?
    var imageFile : Data?
    var url : String?
    var originalUrl : String?
    
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
        let randomColorGenerator = [kCIInputAngleKey: (Double(arc4random_uniform(314)) / 100)]
        
        // Apply a filter to the image
        let filteredImage = inputImage!.applyingFilter(K.filterName, parameters: randomColorGenerator)
        
        // Render the filtered image
        let renderedImage = context.createCGImage(filteredImage, from: filteredImage.extent)
        
        // Reflect the change back in the interface
        selectedPhotoView.image = UIImage(cgImage: renderedImage!)
        print("event=applyFilter message=Filter has been successfully applied to the image")
    }
    
    // Reseting the filter applied
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        selectedPhotoView.image = imageToDisplay
        print("event=resetButtonTapped message=Applied filters have been reset")
    }
    
    // Saving the edited photo
    @IBAction func saveButonTapped(_ sender: UIButton) {
        getUrlToPost()
        print("event=saveButonTapped message=Applied filters have been saved")
    }
    
    // Adding text to photo using library : JLStickerTextView
    @IBAction func addTextButtonTapped(_ sender: UIButton) {
        selectedPhotoView.addLabel()
        print("event=addTextButtonTapped message=Text box have been added")
    }
    
    struct RequestBodyFormDataKeyValue {
        var sKey : String
        var sVal : String
    }
    
    func getUrlToPost(){
        let urlString = K.urlToPost
        if let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { [self] data, response, error in
                if error != nil{
                    print("event=getUrlToPost message=Unable to start a session \(String(describing: error))")
                }
                if let safeData = data {
                    print("event=getUrlToPost message=Url to upload image has been successfully fetched")
                    let urlRecieved =  self.parseUploadUrlJson(with: safeData)
                    postImage()
                }
            }
            task.resume()
        }
    }
    
    func parseUploadUrlJson(with data: Data)->String? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(UploadUrlModel.self, from: data)
            url = decodedData.url
            print("event=jsonParsing message=Upload URL json has been successfully parsed and url extracted")
        }catch {
            print("event=jsonParsing message=Error while decoding JSON data")
        }
        return url
    }
    
    func postImage(){
        var sURL : String
        var bodyKeyValue = [RequestBodyFormDataKeyValue]()
        DispatchQueue.main.async { [self] in
        let image = self.selectedPhotoView.image
        let imgData = image!.jpegData(compressionQuality: 0.2)!
            bodyKeyValue.append(RequestBodyFormDataKeyValue(sKey: K.uploadParameterKey1, sVal: K.uploadParameterValue1))
            bodyKeyValue.append(RequestBodyFormDataKeyValue(sKey: K.uploadParameterKey2, sVal: originalUrl!))
            if let urlString = self.url {
            let serializer = DataResponseSerializer(emptyResponseCodes: Set([200]))
            var sampleRequest = URLRequest(url: URL(string: urlString)!)
            sampleRequest.httpMethod = HTTPMethod.post.rawValue
            print("event=postImage message=Uploading the image")
            AF.upload(multipartFormData: { MultipartFormData in
                MultipartFormData.append(imgData, withName: K.uploadImageName, fileName:K.uploadImageFileName , mimeType: K.uploadImageType)
                for formData in bodyKeyValue {
                    MultipartFormData.append(Data(formData.sVal.utf8), withName: formData.sKey)
                }
            }, to: urlString,method: .post)
                .uploadProgress{Progress in
                    print(CGFloat(Progress.fractionCompleted))
                }
                .response{response in
                    if(response.response?.statusCode == 200){
                        print("event=postImage message=Successfully uploaded the image")
                        let alert = UIAlertController(title: "Success", message: "Successfully uploaded the image", preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)
                    }else {
                        print("event=postImage message=Error occurred while uploading the image errorStatusCode= \(response.response?.statusCode) errorStatusDescription= \(response.response?.description)")
                    }
                    
                }        }
        else {
            print("event=postImage message=Url to upload image is empty and hece image cannot be uploaded")
        }
    }
}
}
