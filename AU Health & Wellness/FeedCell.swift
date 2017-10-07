//
//  FeedCell.swift
//  AU Health & Wellness
//
//  Created by You, EuiBin on 10/6/17.
//  Copyright © 2017 You, EuiBin. All rights reserved.
//

import UIKit

final class FeedCell: UITableViewCell {

    
    @IBOutlet weak var textV: UITextView!
    @IBOutlet weak var imageV: UIImageView!
    
    
    static let ReuseIdentifier = "FeedCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
//        print("prepareForReuse()")
//        imageV.image = nil
    }

}
