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

class FeedController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
//    let cellIndex = Variable(0)
//    let disposeBag = DisposeBag()
    
    var postsCount = 0
    var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.delegate = self
//        tableView.dataSource = self
        
        //tableView.delegate = self
        
//        tableView.rx.setDelegate(self)
//            .disposed(by: disposeBag)
        
//        cellIndex.asObservable()
//            .debug("cellIndex")
//            .subscribe(onNext: { index -> Void in
//                index
//            })
//            .disposed(by: disposeBag)
        
        // Do any additional setup after loading the view, typically from a nib.
        let token = AccessToken(authenticationToken: "1878283485746837|QwNiq8_esarrttcDDB5M6sSlrVg")
        let path = "aulivewholly/feed?fields=status_type,link,full_picture,message"
        GraphRequest(graphPath: path, accessToken: token).start { (_, graphRequestResult) in
            switch graphRequestResult {
            case .success(let response):
                self.onGraphResult(response.dictionaryValue!)
            case .failed(let err):
                print("Failed with error: \(err).")
            }
        }
        
        //tableView.rowHeight = UITableViewAutomaticDimension
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
    
    func loadPicture(_ cell: FeedCell, _ ind: IndexPath, _ url: String, _ width: CGFloat)
    {
        let task = URLSession.shared.dataTask(with: URL(string: url)!) {(data, response, error) in
//            print("Response=\(response.debugDescription)")
            print("----------------------------------")
            print("Response=\(response!.description)")
            guard let payload = data else {
                print("no data!")
                print("----------------------------------")
                return
            }
            
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
            print("----------------------------------")
            
            DispatchQueue.main.async {
                print("~~~~~~~~~~~~~~~~~~")
                self.tableView.reloadData()
                print("~~~~~~~~~~~~~~~~~~")
//                self.tableView.beginUpdates()
//                self.tableView.reloadRows(at: [ind], with: UITableViewRowAnimation(rawValue: 6)!)
//                self.tableView.endUpdates()
            }
        }
        task.resume()
    }
    
    func onGraphResult(_ resultDict: [String: Any])
    {
        let unparsedArr = resultDict["data"] as! [[String:Any]]
        print("Full data payload: \(unparsedArr)")
        
        for post in unparsedArr
        {
            posts.append(Post(text: post["message"] as! String, image: nil, imageUrl: post["full_picture"] as? String))
            print("\t\(posts.last!.toString())\n")
        }
        
        postsCount = posts.count
        tableView.reloadData()
        print("\n\tcalled reload!\n")
        
        //let x = unparsedArr.map(<#T##transform: ([String : Any]) throws -> _##([String : Any]) throws -> _#>)
        
//        let dataSource = Observable.just(resultDict)
//        dataSource.bind(to: tableView.rx.items(cellIdentifier: FeedCell.ReuseIdentifier,
//                                               cellType: FeedCell.self))
//                    { (_, model: PostModel, cell: FeedCell) in
//                        //cell.postText.text = model["id"] as! String
//                    }
//                    .addDisposableTo(disposeBag)
    }

}

