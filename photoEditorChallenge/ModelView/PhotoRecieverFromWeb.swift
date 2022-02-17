//
//  PhotoRecieverFromWeb.swift
/*  Functionalities :
        > Fetch the json file that contains the image urls.
        > Extract the image urls from the the json file.
        > Fetch the image using the url extracted.
 */
//
//  Created by Ann Mary Jacob on 2/15/22.
//

import Foundation
import UIKit
class PhotoRecieverFromWeb {
    
    let urlString = K.imageCollectionUrl
    var universalURLArray : [String] = []
    var photoArrayFinal : [PhotoAppModel]?
    var photoList: [Data] = []
    var delegate : PhotoArrayUpdateDelegate?
    
    func getUrlData()  {
        //Create a URL
        if let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!){
            //Create a Session
            let session = URLSession(configuration: .default)
            //Assign a task
            let task = session.dataTask(with: url) { [self] data, response, error in
                if error != nil{
                    print("event=getUrlData message=Unable to start a session \(String(describing: error))")
                }
                if let safeData = data {
                    print("event=getUrlData message=Data fetched")
                    self.jsonParsing(with: safeData)
                }
            }
            //Start the task
            task.resume()
        }
    }
    
    func jsonParsing(with data: Data) {
        var photoArray : [PhotoAppModel] = []
        do {
            let json = try! JSONSerialization.jsonObject(with: data, options: []) as? [[String:String]]
            for element in json! {
                if let photo = element["url"]{
                    let photoObj = PhotoAppModel(photoUrl: photo)
                    photoArray.append(photoObj)
                    self.loadImage(with: photo)
                }
            }
            print("event=jsonParsing message=Image URLs successfully fetched and added to array")
        }
        catch {
            print("event=jsonParsing message=Error while parsing JSON : \(error)")
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
                print("event=loadImage message=Error while downloading image : \(String(describing: error))")
            } else {
                if let imageData = data {
                    //Appending the photo fetched from web to an array
                    photoList.append(imageData)
                    universalURLArray.append(imageString)
                    delegate?.updatePhotoArray(withPhotoData: photoList, withPhotoUrl: universalURLArray)
                    print("event=loadImage message=Images successfully loaded and added to array")
                }
            }
        }
        downloadImageTask.resume()
    }
}

protocol PhotoArrayUpdateDelegate{
    func updatePhotoArray(withPhotoData photoArray : [Data],withPhotoUrl photoUrlArray : [String])
}
