//
//  ViewController.swift
//  AlamoFireDemo
//
//  Created by 宋小伟 on 2022/9/30.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        AF.request("https://httpbin.org/get", method: .get).response { response in
            debugPrint(response)
        }
        .responseString(completionHandler: { response in
            print("String ---------------")
            switch response.result {
            case .success(let str):
                print(str)
            case .failure(let error):
                print(error)
            }
            
        })
        .responseJSON(completionHandler: { response in
            print("JSON -------------------")
            switch response.result {
            case .success(let json):
                let dict = json as! Dictionary<String, AnyObject>
                let origin = dict["origin"] as! String
                let headers = dict["headers"] as! Dictionary<String, String>
                print("origin: \(origin)")
                let ua = headers["User-Agent"]
                print("UA: \(ua!)")
                
            case .failure(let error):
                print(error)
            }
            
        })
        
        AF.download("https://httpbin.org/image/png")
//            .response { response in
//           // debugPrint(response)
//
//            if response.error == nil, let imagePath = response.fileURL?.path {
//                let image = UIImage(contentsOfFile: imagePath)
//                let uiImageView = UIImageView(image: image)
//                uiImageView.center = CGPointMake(self.view.center.x, self.view.center.y)
//                self.view.addSubview(uiImageView)
//            }
//        }
        .downloadProgress { progress in
            print("Download Progress: \(progress.fractionCompleted)")
        }
        .responseData { response in
            if let data = response.value {
                let image = UIImage(data: data)
                let uiImageView = UIImageView(image: image)
                uiImageView.center = CGPointMake(self.view.center.x, self.view.center.y)
                self.view.addSubview(uiImageView)
            }
        }
        
        
        var resumeData: Data!
        let downed = AF.download("https://httpbin.org/image/png")
            .responseData { response in
                if let data = response.value {
                    let image = UIImage(data: data)
                    let uiImageView = UIImageView(image: image)
                    uiImageView.center = CGPointMake(self.view.center.x, self.view.center.y - 100)
                    self.view.addSubview(uiImageView)
            }
        }
        
        downed.cancel { data in
            print("Cancel ===============================")
            resumeData = data
        }
        
        if resumeData != nil {
            AF.download(resumingWith: resumeData)
                .responseData { response in
                    if let data = response.value {
                        let image = UIImage(data: data)
                        let uiImageView = UIImageView(image: image)
                        uiImageView.center = CGPointMake(self.view.center.x, self.view.center.y - 100)
                        self.view.addSubview(uiImageView)
                    }
                    
                }
        }
        
        let data = Data("data".utf8)

        AF.upload(data, to: "https://httpbin.org/post") { response in
            print("UPLOAD -----------------")
            debugPrint(response)
        }
    }
    

    
}

