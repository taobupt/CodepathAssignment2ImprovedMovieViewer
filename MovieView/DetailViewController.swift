//
//  DetailViewController.swift
//  MovieView
//
//  Created by Tao Wang on 1/13/17.
//  Copyright © 2017 Tao Wang. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    
    @IBOutlet weak var posterImageView: UIImageView!
    
    
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var TitleLabel: UILabel!
    
    @IBOutlet weak var overviewLabel: UILabel!
    
    var movie: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action:nil)
        
        let titleLabel = UILabel()
        
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.red.withAlphaComponent(0.5)
        shadow.shadowOffset = CGSize(width:2, height:2);
        shadow.shadowBlurRadius = 4;
        
        let titleText = NSAttributedString(string: "detail", attributes: [
            NSFontAttributeName : UIFont.boldSystemFont(ofSize: 28),
            NSForegroundColorAttributeName : UIColor(red: 0.5, green: 0.25, blue: 0.15, alpha: 0.8),
            NSShadowAttributeName : shadow
            ])
        
        titleLabel.attributedText = titleText
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel
        
        let segmentedControl = UISegmentedControl(items: ["Foo", "Bar"])
        segmentedControl.sizeToFit()
        let segmentedButton = UIBarButtonItem(customView: segmentedControl)
        navigationItem.rightBarButtonItems = [saveButton, segmentedButton]
        
        
        
        
        
        scrollView.contentSize=CGSize(width: scrollView.frame.width, height: infoView.frame.origin.y+infoView.frame.size.height)
        
        
        
        
        
        let title=movie["title"] as? String
        TitleLabel.text=title
        
        let overview=movie["overview"]
        overviewLabel.text=overview as? String
        overviewLabel.sizeToFit()
        
        if let posterPath=movie["poster_path"] as? String{
            let Url="https://image.tmdb.org/t/p/w500"+posterPath
            let imageUrl=URL(string: Url)
            posterImageView.setImageWith(imageUrl!)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
