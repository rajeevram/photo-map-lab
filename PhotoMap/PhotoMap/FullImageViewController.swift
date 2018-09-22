//
//  FullImageViewController.swift
//  Photo Map
//
//  Created by Nicholas Aiwazian on 10/15/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

class FullImageViewController: UIViewController {

    @IBOutlet weak var fullImageView: UIImageView!
    @IBOutlet weak var theScrollView: UIScrollView!
    var photo : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTheImage()
    }

    func setTheImage() {
       theScrollView.contentSize = fullImageView.bounds.size
        theScrollView.addSubview(fullImageView)
//        view.addSubview(theScrollView!)
        if let photo = photo {
            fullImageView.image = photo
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
