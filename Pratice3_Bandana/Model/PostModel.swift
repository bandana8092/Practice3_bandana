//
//  PostModel.swift
//  Pratice3_Bandana
//
//  Created by Rakesh Nangunoori on 29/01/20.
//  Copyright © 2020 Rakesh Nangunoori. All rights reserved.
//

import Foundation
import UIKit


class PostModel {
    var title = String()
    var createdDate = String()
    var switchStatus = false
    
    init(postModel:NSDictionary) {
        if let title = postModel.object(forKey: serverkeys.title){
            self.title = title as! String
        }
        if let createdDate = postModel.object(forKey: serverkeys.creaedDate){
            self.createdDate = createdDate as! String
        }
        
    }
}
