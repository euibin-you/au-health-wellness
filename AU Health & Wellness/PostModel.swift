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
    let id: String?
    let message: String?
    let tags: [[String: Any?]]?
    var image: UIImage?
    let imageUrl: String?
    
    init()
    {
        self.init(id: nil, text: nil, tags: nil, image: nil, imageUrl: nil)
    }
    
    init(id: String?, text: String?, imageUrl: String?)
    {
        self.init(id: id, text: text, tags: nil, image: nil, imageUrl: imageUrl)
    }
    
    init(id: String?, text: String?, tags: [[String: Any?]]?, imageUrl: String?)
    {
        self.init(id: id, text: text, tags:tags, image: nil, imageUrl: imageUrl)
    }
    
    init(id:String?, text: String?, tags: [[String: Any?]]?, image: UIImage?, imageUrl: String?)
    {
        self.id = id
        self.message = text
        self.tags = tags
        self.image = image
        self.imageUrl = imageUrl
    }
    
    func toString() -> String
    {
        var str = "Message: "
        switch message {
            case nil:
                str += "no text"
            default:
                str += message!
        }
        
        str += "\n\tImage URL: "
        switch imageUrl {
            case nil:
                str += "no image url"
            default:
                str += imageUrl!
        }
        
        str += "\n\tImage downloaded? "
        switch image {
            case nil:
                str += "false"
            default:
                str += "true"
        }
        
        str += "\n\tTags: "
        switch tags {
            case nil:
                str += "no tags"
            default:
                for tag in tags! {
                    let title = tag["name"] as! String
                    str += "\(title), "
                }
        }
        //str = String(Substring(str).prefix(upTo: String.Index(encodedOffset: str.count-1)))
        
        return str
    }
}
