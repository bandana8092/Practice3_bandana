//
//  APICalling.swift
//  Pratice3_Bandana
//
//  Created by Rakesh Nangunoori on 29/01/20.
//  Copyright © 2020 Rakesh Nangunoori. All rights reserved.
//

import UIKit

class APICalling: NSObject {
    
    static let shared : APICalling = {
        
        let instance = APICalling()
        return instance
        
    }()
    
    func getDetailFromServer(url:String,complitionHandler:@escaping(_ response:NSDictionary?,_ error:NSError?)->Void)
    {
       
        let finalUrl = URL(string: url)
        let request = URLRequest(url: finalUrl!)
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) { (Data, urlResponse, error) in
            if Data == nil{
                
            }else{
                do{
                    
                    let jsonResult = try JSONSerialization.jsonObject(with: Data!, options: .mutableContainers)
                    print(jsonResult)
                    complitionHandler(jsonResult as? NSDictionary,nil)
                    
                }catch{
                    complitionHandler(nil,error as NSError)
                }
            }
        }
        task.resume()
    }

}
