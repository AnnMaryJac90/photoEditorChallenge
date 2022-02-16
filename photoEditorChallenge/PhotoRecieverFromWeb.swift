//
//  PhotoRecieverFromWeb.swift
//  photoEditorChallenge
//
//  Created by Anil Thomas on 2/15/22.
//

import Foundation
import UIKit
class PhotoRecieverFromWeb {
    
   let urlString = "https://eulerity-hackathon.appspot.com/image"
    
    var photoArrayFinal : [PhotoAppModel]?
    var photoArrayObj : PhotoWebData?
    var photoList: [Data] = []
    var delegate : PhotoArrayUpdateDelegate?
  

    func getUrlData()  {
        
        //Create a URL
        
        if let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!){
            
            
            let request = URLRequest(url: url)
            
            //Create a Session
            
            let session = URLSession(configuration: .default)
            
            
            //Assign a task
            
            let task = session.dataTask(with: url) { [self] data, response, error in
                if error != nil{
                    print("error")
                }
                if let safeData = data {
                    
                    if let photoArrayFinal = self.jsonParsing(with: safeData){
                       
                    }
                    
                    
                }
            }
            //Start the task
            
            task.resume()
            
        }
       
        
    }
    
    
    
    func jsonParsing(with data: Data)-> [PhotoAppModel]? {
        let decoder = JSONDecoder()
        var photoArray : [PhotoAppModel] = []
        do {
              let json = try! JSONSerialization.jsonObject(with: data, options: []) as? [[String:String]]
            for element in json! {
                
                if let photo = element["url"]{
                    let photoObj = PhotoAppModel(photoUrl: photo)
                    print("Photo object is \(photoObj)")
                    photoArray.append(photoObj)
                    
                    
                        self.loadImage(with: photo)
                        
                       
                   
                }
                
            }
            
            return photoArray
        }
        
        catch {
            print(error)
            return nil
        }
    }
    
    
    
    
    func loadImage(with imageString: String){
        let pictureUrl = URL(string: imageString)!

        // Creating a session object with the default configuration.
        let session = URLSession(configuration: .default)

        // Define a download task. The download task will download the contents of the URL as a Data object.
        
        let downloadImageTask = session.dataTask(with: pictureUrl) { [self] (data, response, error) in
            // The download has finished.
            if error != nil {
                print("Error downloading picture: \(error)")
            } else {
                // No errors found.
               
           
                print("*********")
                    if let imageData = data {
                        //
                        let photoListObj = PhotoWebData(webImage: imageData)
                        print("&&&&&&&&")
                        print(photoListObj)
                        photoList.append(imageData)
                        print(photoList)
                        delegate?.updatePhotoArray(with: photoList)
                        
                        }
                        
                     
                        //
                }
           
               // print("**********************")
               
            }

        downloadImageTask.resume()
       
        
    }

    
    

}

protocol PhotoArrayUpdateDelegate{
    func updateUrlArray(_ urlArrayStorage: [PhotoWebData])
    func updatePhotoArray(with photoArray : [Data])
    func didErrorOccur(error : Error)
}
