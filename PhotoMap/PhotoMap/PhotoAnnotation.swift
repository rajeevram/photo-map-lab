//
//  PhotoAnnotation.swift
//  PhotoMap
//
//  Created by Rajeev Ram on 9/19/18.
//  Copyright © 2018 Timothy Lee. All rights reserved.
//

import Foundation
import MapKit

class PhotoAnnotation : NSObject, MKAnnotation {
    
    var coordinate : CLLocationCoordinate2D
    var photo : UIImage
    var title : String?
    
    init(coordinate : CLLocationCoordinate2D, name: String, image: UIImage) {
        self.coordinate = coordinate
        self.title = name
        self.photo = image
    }
    
    
}
