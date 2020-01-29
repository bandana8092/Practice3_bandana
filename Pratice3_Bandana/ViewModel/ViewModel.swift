//
//  ViewModel.swift
//  Pratice3_Bandana
//
//  Created by Rakesh Nangunoori on 29/01/20.
//  Copyright © 2020 Rakesh Nangunoori. All rights reserved.
//

import UIKit
import Foundation

class ViewModel: NSObject {
    static let shared : ViewModel = {
        
        let instance = ViewModel()
        return instance
        
    }()
    var postModel = [PostModel]()
    var totalPages = Int()
    var currentPage = Int()
    var pageCount  = Int()
    
    func getPosts(complitionHandler:@escaping(_ error:NSError?) -> Void){
        APICalling.shared.getDetailFromServer(url: "\(BASE_URL)\(pageCount)") { (responseData, error) in
            if error == nil{
                print(responseData!)
                
                if responseData?.object(forKey: "nbPages") != nil{
                    let totalPages = String(describing: responseData!.object(forKey: "nbPages")!)
                    self.totalPages = Int(totalPages) ?? 0
                }
                
                if responseData?.object(forKey: "page") != nil{
                    let currentPag = String(describing: responseData!.object(forKey: "page")!)
                    self.currentPage = Int(currentPag) ?? 0
                }
                
               if let arrObj = responseData?.object(forKey: "hits") as? NSArray{
                
                
                for eachObj in arrObj {
                    let modelObj = PostModel.init(postModel: eachObj as! NSDictionary)
                    self.postModel.append(modelObj)
                   
                }
                 complitionHandler(nil)
                }else{
                    print("Data not in currect format")
                }
            }
            
            else{
                complitionHandler(error)
            }
        }
    }
    
    func getUpdateSwitchStatus(postModel:[PostModel],indexPath:IndexPath,compitionHandler:@escaping(_ error:NSError?)->Void) {
        postModel[indexPath.row].switchStatus = postModel[indexPath.row].switchStatus ? false : true
        compitionHandler(nil)
    }
    
    func formatDate(date: String) -> String {
       let dateFormatterGet = DateFormatter()//2020-01-29T04:11:44.000Z
       dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"

       let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm a"

       let dateObj: Date? = dateFormatterGet.date(from: date)

       return dateFormatter.string(from: dateObj!)
    }
}
