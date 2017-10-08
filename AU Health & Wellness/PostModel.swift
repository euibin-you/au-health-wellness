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
    // TODO: add id?
    let text: String?
    let tags: [String]?
    var image: UIImage?
    let imageUrl: String?
    
    init()
    {
        self.init(text: nil, tags: nil, image: nil, imageUrl: nil)
    }
    
    init(text: String?, imageUrl: String?)
    {
        self.init(text: text, tags: nil, image: nil, imageUrl: imageUrl)
    }
    
    init(text: String?, tags: [String]?, imageUrl: String?)
    {
        self.init(text: text, tags:tags, image: nil, imageUrl: imageUrl)
    }
    
    init(text: String?, tags: [String]?, image: UIImage?, imageUrl: String?)
    {
        self.text = text
        self.tags = tags
        self.image = image
        self.imageUrl = imageUrl
    }
    
    func toString() -> String
    {
        var str = "Text: "
        switch text {
            case nil:
                str += "no text"
            default:
                str += text!
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
