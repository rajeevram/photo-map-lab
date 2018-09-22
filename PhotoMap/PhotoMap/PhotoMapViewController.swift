//
//  PhotoMapViewController.swift
//  Photo Map
//
//  Created by Nicholas Aiwazian on 10/15/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class PhotoMapViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, LocationsViewControllerDelegate, MKMapViewDelegate {

    // UI, UX Variables
    @IBOutlet weak var theMapView: MKMapView!
    @IBOutlet weak var cameraButton: UIButton!
    
    // Backend Variables
    var originalImage : UIImage?
    var editedImage : UIImage?
    let annotationReuseIdentifier = "AnnotationView"
    
    // View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        theMapView.delegate = self as MKMapViewDelegate
        stylizeCameraButton()
        setMapLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.backgroundColor = UIColor.white
    }
    
    // Instance, Helper Methods
    func stylizeCameraButton() {
        cameraButton.backgroundColor = UIColor.white
        cameraButton.layer.cornerRadius = cameraButton.layer.frame.height / 2
        cameraButton.clipsToBounds = true
        cameraButton.layer.borderWidth = 1
        cameraButton.layer.borderColor = UIColor.black.cgColor
    }
    
    
    func setMapLocation() {
        let TucsonRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(32.2226, -110.9747), MKCoordinateSpanMake(0.1, 0.1))
        //let SFRegion = MKCoordinateRegionMake(CLLocationCoordinate2DMake(37.783333, -122.416667), MKCoordinateSpanMake(0.05, 0.05))
        theMapView.setRegion(TucsonRegion, animated: false)
    }
    
    // Event Handlers
    @IBAction func onTapCameraButton(_ sender: Any) {
        cameraButton.backgroundColor = UIColor.lightGray
        self.selectPhoto()
    }
    
    // Image Selection
    func selectPhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            //print("Camera is available 📸")
            imagePicker.sourceType = .camera
        } else {
            //print("Camera 🚫 available so we will use photo library instead")
            imagePicker.sourceType = .photoLibrary
        }
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        let original = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.originalImage = original
        let edited = info[UIImagePickerControllerEditedImage] as! UIImage
        self.editedImage = edited
        dismiss(animated: false) {
            self.performSegue(withIdentifier: "TagSegue", sender: nil)
        }
    }
    
    // Override
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "TagSegue") {
            let newListView = segue.destination as! LocationsViewController
            newListView.delegate = self as LocationsViewControllerDelegate
        }
        else if (segue.identifier == "FullSegue") {
            let newImageView = segue.destination as! FullImageViewController
            if let annotationView = sender as? MKAnnotationView {
                let photoAnnotation = annotationView.annotation as! PhotoAnnotation
                newImageView.photo = photoAnnotation.photo
            }
        }
    }
    
    // Delegate
    
    // Locations List
    func locationsPickedLocation(controller: LocationsViewController, latitude: NSNumber, longitude: NSNumber, name: String) {
        self.navigationController?.popToViewController(self, animated: true)
        let locationCoordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        let annotation = PhotoAnnotation(coordinate: locationCoordinate, name: name, image: self.originalImage!)
        theMapView.addAnnotation(annotation)
    }
    
    // Map Annotation
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationReuseIdentifier)
        if (annotationView == nil) {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationReuseIdentifier)
            annotationView!.canShowCallout = true
            annotationView!.leftCalloutAccessoryView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            annotationView!.rightCalloutAccessoryView = UIButton(type: UIButtonType.detailDisclosure)
        }
        let imageView = annotationView?.leftCalloutAccessoryView as! UIImageView
        imageView.image = createThumbnail(annotation: annotation)
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        self.performSegue(withIdentifier: "FullSegue", sender: view)
    }
    
    // Resize Image
    func createThumbnail(annotation : MKAnnotation) -> UIImage? {
        // Create a resized image view
        let resizeRenderImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
        resizeRenderImageView.layer.borderColor = UIColor.white.cgColor
        resizeRenderImageView.layer.borderWidth = 3.0
        resizeRenderImageView.contentMode = UIViewContentMode.scaleAspectFill
        resizeRenderImageView.image = (annotation as? PhotoAnnotation)?.photo
        // Render the image itself in miniature
        UIGraphicsBeginImageContext(resizeRenderImageView.frame.size)
        resizeRenderImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let thumbnail = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return thumbnail
    }

}
