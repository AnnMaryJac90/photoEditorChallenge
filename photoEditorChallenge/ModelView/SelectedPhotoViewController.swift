//
//  SelectedPhotoViewController.swift
//  photoEditorChallenge
//
//  Created by Ann Mary Jacob on 2/15/22.
//

import UIKit
import CoreImage
import JLStickerTextView
//import TextDrawer
import Alamofire
//import ZImageCropper


class SelectedPhotoViewController: UIViewController {
 
     var imageToDisplay : UIImage?
    var imageFile : Data?
    var url : String?
    
   
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
            let filteredImage = inputImage!.applyingFilter("CIHueAdjust", parameters: randomColorGenerator)

            // Render the filtered image
            let renderedImage = context.createCGImage(filteredImage, from: filteredImage.extent)

            // Reflect the change back in the interface
            selectedPhotoView.image = UIImage(cgImage: renderedImage!)

        }
    
// Reseting the filter applied
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
      selectedPhotoView.image = imageToDisplay
     
    }
    

// Saving the edited photo
    @IBAction func saveButonTapped(_ sender: UIButton) {
        print("Will save the photo soon")
       // postImage()
        getUrlToPost()
       // imageToCrop.cropImage()
        
    }
    
   
// Adding text to photo using library : JLStickerTextView
    @IBAction func addTextButtonTapped(_ sender: UIButton) {
        selectedPhotoView.addLabel()
        
    }
    

    struct RequestBodyFormDataKeyValue {
        var sKey : String
        var sVal : String
    }
    
    func useAlamofire() {
        
        let image = imageToDisplay
        let imgData = image!.jpegData(compressionQuality: 0.2)!

         let parameters = ["appid": "annmaryjac90@gmail.com"] //Optional for extra parameter

        AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(imgData, withName: "fileset",fileName: "file.jpg", mimeType: "image/jpg")
                for (key, value) in parameters {
                        multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                    } //Optional for extra parameters
            },
        to:"http://eulerity-hackathon.appspot.com/_ah/upload/AMmfu6ZClHzoZuali_ijdO1_W0lno4tvNFngC5EUGUn4hdH5tMItleS3pLDbG1PqZJkjUewQrXN7hAEROn05Zdfh2qPAFjWtaQCSe_GgoTlehCGt-OPOXBryvSs-JfT41Uj_4u1W2J4T0DX6rjUepdolHwZ8W-G2gO_D1NIrVIMmGNbCQiQlXLR09cGLWz_FKSqkv9GFt_o-w7_wehog-ezsrUF_xDE51Q/ALBNUaYAAAAAYg11J8bJh-cC0KtnlpSQDeGvavMnKAHR/")
        { (result) in
           print(result)
        }
        
    }

    func getUrlToPost(){
    
        // 1
        let urlString = "http://eulerity-hackathon.appspot.com/upload"
        if let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!){
            
            
          //  let request = URLRequest(url: url)
            
        //Create a Session
            
            let session = URLSession(configuration: .default)
            
            
        //Assign a task
            
            let task = session.dataTask(with: url) { [self] data, response, error in
                if error != nil{
                    print("Unable to start a session \(String(describing: error))")
                }
                if let safeData = data {
                    
                  let urlRecieved =  self.jsonParsing(with: safeData)
                    postImage()
                    
                }
            }
            //Start the task
            
            task.resume()
            
        }
       
        
    }
    
    func jsonParsing(with data: Data)->String? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(UploadUrlModel.self, from: data)
            url = decodedData.url
           // print("*****************")
          //  print(url)
            
        }catch {
            print("Error while decoding JSON data")
        }
        
        return url
    }
    
    
        
    
    
    func postImage(){
        var sURL : String
        var bodyKeyValue = [RequestBodyFormDataKeyValue]()
        let image = imageToDisplay
        let imgData = image!.jpegData(compressionQuality: 0.2)!
        bodyKeyValue.append(RequestBodyFormDataKeyValue(sKey: "appid", sVal: "annmaryjac90@gmail.com"))
        bodyKeyValue.append(RequestBodyFormDataKeyValue(sKey: "original", sVal: "https://images.pexels.com/photos/321552/pexels-photo-321552.jpeg"))
        bodyKeyValue.append(RequestBodyFormDataKeyValue(sKey: "file", sVal: "\(imgData)"))
        
      //  sURL = "https://httpbin.org/post"
        print("url is ")
        print(url)
        if let urlString = url {
            print("urlstring is:")
            print(urlString)
            let serializer = DataResponseSerializer(emptyResponseCodes: Set([200]))
            var sampleRequest = URLRequest(url: URL(string: urlString)!)
            sampleRequest.httpMethod = HTTPMethod.post.rawValue
            AF.upload(multipartFormData: { MultipartFormData in
                for formData in bodyKeyValue{
                    MultipartFormData.append(Data(formData.sVal.utf8), withName: formData.sKey)
                }
            }, to: urlString,method: .post)
                .uploadProgress{Progress in
                print(CGFloat(Progress.fractionCompleted))
                }
                .response{response in
                    print("-----------------------------")
                    if(response.response?.statusCode == 200){
                        var responseString : String!
                        responseString = ""
                        if(response.data != nil)
                          {
                            responseString = String(bytes: response.data!, encoding : .utf8)
                          }
                         else {
                            responseString = response.response?.description
                              }
                                //  print("&&&&&&&&&&&&&&&&&&&&")
                                       print(responseString ?? "")
                                      print(response.response?.statusCode)
                                        var responseData : NSData!
                                     //   responseData = response.data! as NSData
                                    //    var iDataLength = responseData.length
                    }else {
                        print("Error Status Code = \(response.response?.statusCode)")
                        print("Error Description = \(response.response?.description)")
                    }
                    
                }        }
        else {
       sURL = "http://eulerity-hackathon.appspot.com/_ah/upload/AMmfu6ZClHzoZuali_ijdO1_W0lno4tvNFngC5EUGUn4hdH5tMItleS3pLDbG1PqZJkjUewQrXN7hAEROn05Zdfh2qPAFjWtaQCSe_GgoTlehCGt-OPOXBryvSs-JfT41Uj_4u1W2J4T0DX6rjUepdolHwZ8W-G2gO_D1NIrVIMmGNbCQiQlXLR09cGLWz_FKSqkv9GFt_o-w7_wehog-ezsrUF_xDE51Q/ALBNUaYAAAAAYg11J8bJh-cC0KtnlpSQDeGvavMnKAHR/"
        }
       // print("URL IS:  ")
    //    print(url)
//        let serializer = DataResponseSerializer(emptyResponseCodes: Set([200,204,205]))
//        var sampleRequest = URLRequest(url: URL(string: sURL)!)
//        sampleRequest.httpMethod = HTTPMethod.post.rawValue
//        AF.upload(multipartFormData: { MultipartFormData in
//            for formData in bodyKeyValue{
//                MultipartFormData.append(Data(formData.sVal.utf8), withName: formData.sKey)
//            }
//        }, to: sURL,method: .post)
//            .uploadProgress{Progress in
//            print(CGFloat(Progress.fractionCompleted))
//            }
//            .response{response in
//                if(response.error == nil){
//                    var responseString : String!
//                    responseString = ""
//                    if(response.data != nil)
//                      {
//                        responseString = String(bytes: response.data!, encoding : .utf8)
//                      }
//                     else {
//                        responseString = response.response?.description
//                          }
//                            //  print("&&&&&&&&&&&&&&&&&&&&")
//                                   print(responseString ?? "")
//                                  print(response.response?.statusCode)
//                                    var responseData : NSData!
//                                 //   responseData = response.data! as NSData
//                                //    var iDataLength = responseData.length
//                }
//
//            }
//        AF.request(sampleRequest).uploadProgress{progress in}.response(responseSerializer:serializer){response in
//
//
//            if(response.error == nil){
//                var responseString : String!
//                responseString = ""
//                if(response.data != nil)
//                {
//                    responseString = String(bytes: response.data!, encoding : .utf8)
//                }
//                else {
//                    responseString = response.response?.description
//                }
//                print("&&&&&&&&&&&&&&&&&&&&")
//                print(responseString ?? "")
//                print(response.response?.statusCode)
//                var responseData : NSData!
//                responseData = response.data! as NSData
//                var iDataLength = responseData.length
//            }
//        }
    }
}

