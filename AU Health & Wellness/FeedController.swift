//
//  FirstViewController.swift
//  AU Health & Wellness
//
//  Created by You, EuiBin on 10/5/17.
//  Copyright © 2017 You, EuiBin. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import FacebookCore

// TODO: remove page tags from message (what about tags in middle of content?)
// TODO: change message to UILabel and use attributed text to style #hashtag(blue) and in-content tags (bold)
// TODO: open webview for linked posts
// TODO: open details for regular posts
// TODO: implement notifications viewer
// TODO: pull to refresh
// TODO: load more when user scrolls to bottom
// TODO: custom seprator

class FeedController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var postsCount = 0
    var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        let token = AccessToken(authenticationToken: "1878283485746837|QwNiq8_esarrttcDDB5M6sSlrVg")
        let path = "aulivewholly/feed?fields=status_type,link,full_picture,message,created_time,message_tags"
        GraphRequest(graphPath: path, accessToken: token).start { (_, graphRequestResult) in
            switch graphRequestResult {
            case .success(let response):
                self.onGraphResult(response.dictionaryValue!)
            case .failed(let err):
                print("Failed with error: \(err).")
            }
        }
        
        print("Delegate: \(tableView.delegate.debugDescription)")
        print("Data source: \(tableView.dataSource.debugDescription)")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postsCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FeedCell.ReuseIdentifier, for: indexPath) as? FeedCell else {
            fatalError("The dequeued cell is not of the expected type.")
        }
        let rowInd = indexPath.row
        if (rowInd < posts.count) {
            print("Loading post, ind=#\(rowInd)..")
            let post = posts[rowInd]
            cell.textV.text = post.text
            guard let url = post.imageUrl else {
                print("No image url associated with this post (ind=\(rowInd))")
                cell.imageV.image = nil
                return cell
            }
            if (posts[rowInd].image == nil){
                loadPicture(cell, indexPath, url, cell.imageV!.bounds.width)
            }
            cell.imageV!.image = posts[rowInd].image
            print("\t..done. (ind=#\(rowInd))")
            return cell
        }
        print("Loading placeholder, ind=#\(rowInd)")
        cell.textV.text = "Loading.."
        print("\t..done. (ind=#\(rowInd))")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Cell ind=\(indexPath.row) selected.")
    }
    
    private func loadPicture(_ cell: FeedCell, _ ind: IndexPath, _ url: String, _ width: CGFloat)
    {
        let task = URLSession.shared.dataTask(with: URL(string: url)!) {(data, response, error) in
//            print("Response=\(response.debugDescription)")
            guard let response = response else {
                print("response is nil!\nError: \(error.debugDescription)")
                return
            }
            print("Response=\(response.description)")
            guard let payload = data else {
                print("no data!")
                return
            }
            print("start loading picture (ind=\(ind.row)..")
            let img = UIImage(data: payload)!
            let cgImage = img.cgImage!
            let oldWidth = img.size.width
            
            let bitsPerComponent = cgImage.bitsPerComponent
            let bytesPerRow = cgImage.bytesPerRow
            let colorSpace = cgImage.colorSpace!
            let bitmapInfo = cgImage.bitmapInfo
            
            let scaleFactor = width / oldWidth
            let width = Double(cgImage.width) * Double(scaleFactor)
            let height = Double(cgImage.height) * Double(scaleFactor)
            
            let rect = CGRect.init(x: CGPoint().x, y: CGPoint().y, width: CGFloat(width), height: CGFloat(height))
            let context = CGContext.init(data: nil, width: Int(width), height: Int(height), bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
            context.interpolationQuality = .high
            context.draw(cgImage, in: rect)
            self.posts[ind.row].image = UIImage.init(cgImage: context.makeImage()!)
            print("..done (loading picture, ind=\(ind.row).")
            
            DispatchQueue.main.async {
                print("main.async: calling reloadData..")
                self.tableView.reloadData()
//                if (ind.row == 8){ self.tableView.selectRow(at: ind, animated: true, scrollPosition: UITableViewScrollPosition.middle) }
                print("\t..done (main.async).")
//                self.tableView.beginUpdates()
//                self.tableView.reloadRows(at: [ind], with: UITableViewRowAnimation(rawValue: 6)!)
//                self.tableView.endUpdates()
            }
        }
        task.resume()
    }
    
    private func onGraphResult(_ resultDict: [String: Any])
    {
        let unparsedArr = resultDict["data"] as! [[String:Any]]
        print("Full data payload: \(unparsedArr)")
        
        for post in unparsedArr
        {
            posts.append(Post(text: post["message"] as? String, imageUrl: post["full_picture"] as? String))
            print("\t\(posts.last!.toString())\n")
        }
        
        postsCount = posts.count
        tableView.reloadData()
        print("\n\tcalled reload!\n")
    }

}

