//
//  PostModel.swift
//  AU Health & Wellness
//
//  Created by You, EuiBin on 10/6/17.
//  Copyright © 2017 You, EuiBin. All rights reserved.
//

import Foundation
import UIKit

struct Post {
    let text: String
    var image: UIImage?
    let imageUrl: String?
    
    func toString() -> String
    {
        var str = "Text: "
        switch text {
            case nil:
                str += "no text"
            default:
                str += text
        }
        str += "\n\tImage: "
        
        switch image {
            case nil:
                str += "no image"
            default:
                str += "image exists"
        }
        
        return str
    }
}
