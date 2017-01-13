//
//  MoviesViewController.swift
//  MovieView
//
//  Created by Tao Wang on 1/1/17.
//  Copyright © 2017 Tao Wang. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var movies: [NSDictionary]?
    var endpoint: String="now_playing"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        tableView.dataSource=self
        tableView.delegate=self
        self.navigationItem.title="Movie Viewer"
        let refreshControl=UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(MoviesViewController.refreshControlAction(refreshControl:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        MBProgressHUD.showAdded(to: self.view, animated:true)
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest,completionHandler: { (dataOrNil, response, error) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            if let data = dataOrNil {
                
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                    print("response: \(responseDictionary)")
                    self.movies=responseDictionary["results"] as! [NSDictionary]
                    self.tableView.reloadData()
                }
            }
        })
        
        task.resume()
        // Do any additional setup after loading the view.
    }
    
    
    func refreshControlAction(refreshControl: UIRefreshControl){
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
        let request = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        MBProgressHUD.showAdded(to: self.view, animated:true)
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest,completionHandler: { (dataOrNil, response, error) in
            
            MBProgressHUD.hide(for: self.view, animated: true)
            if let data = dataOrNil {
                
                if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                    self.movies=responseDictionary["results"] as! [NSDictionary]
                    self.tableView.reloadData()
                    refreshControl.endRefreshing();
                }
            }
        })
        task.resume()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies=movies{
            return movies.count
        }else{
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let backgroundView=UIView()
        backgroundView.backgroundColor=UIColor.red
        cell.selectedBackgroundView=backgroundView
        cell.selectionStyle=UITableViewCellSelectionStyle.none
        let movie=movies![indexPath.row]
        let title=movie["title"] as! String
        
        let overview=movie["overview"] as! String
        cell.overviewLabel.text=overview
        cell.titleLabel.text=title
        
        if let posterPath=movie["poster_path"] as? String{
            
        let smallImageUrl=URL(string:"https://image.tmdb.org/t/p/w45"+posterPath)
        let largeImageUrl=URL(string:"https://image.tmdb.org/t/p/original"+posterPath)
        let smallImageRequest=URLRequest(url: smallImageUrl!)
        let largeImageRequest=URLRequest(url: largeImageUrl!)
        cell.posterView.setImageWith(
            smallImageRequest,
            placeholderImage: nil,
            success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                
                // imageResponse will be nil if the image is cached
                if smallImageResponse != nil {
                    print("Image was NOT cached, fade in image")
                    cell.posterView.alpha = 0.0
                    cell.posterView.image = smallImage
                    UIView.animate(withDuration: 0.3, animations: { () -> Void in
                        cell.posterView.alpha = 1.0
                    },completion: {(sucess)-> Void in
                        cell.posterView.setImageWith(
                            largeImageRequest,
                            placeholderImage: smallImage, success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                                cell.posterView.image = largeImage;
                                
                        }, failure: { (request, response, error) -> Void in
                            // do something for the failure condition of the large image request
                            // possibly setting the ImageView's image to a default image
                        })
                    })
                } else {
                    print("Image was cached so just update the image")
                    cell.posterView.image = smallImage
                }
        },
            failure: { (imageRequest, imageResponse, error) -> Void in
                // do something for the failure condition
        })
        //cell.posterView.setImageWith(imageUrl!)
        }
        return cell
        
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let cell=sender as! UITableViewCell
        let indexPath=tableView.indexPath(for: cell)
        let movie=movies?[(indexPath?.row)!]
        let detailViewcontroller=segue.destination as! DetailViewController
        detailViewcontroller.movie=movie
        
    }
 
    

}
