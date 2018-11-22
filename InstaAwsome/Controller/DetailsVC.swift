//
//  DetailsVC.swift
//  InstaAwsome
//
//  Created by Eli Armstrong on 11/19/18.
//  Copyright © 2018 Eli Armstrong. All rights reserved.
//

import UIKit
import Parse

class DetailsVC: UIViewController {

    var post : Post!
    
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var detailImg: PFImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailImg.file = post.media
        detailImg.loadInBackground()
        caption.text = post.caption
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy HH:mm a"
        dateFormatter.locale = Locale(identifier: "en_US")
        dateLbl.text = dateFormatter.string(from: post.createdAt!)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
