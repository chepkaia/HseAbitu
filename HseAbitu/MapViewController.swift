//
//  MapViewController.swift
//  HseAbitu
//
//  Created by Sergey on 10/27/16.
//  Copyright © 2016 Sergey. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    let geoCoder = CLGeocoder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGestureRecognizerForView()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    @IBAction func searchForAddress(_ sender: UITextField) {
        addMarkPlacement(textFieldInfo: sender.text ?? "")
    }
    
    @IBAction func textFieldfPressed(_ sender: UITextField) {
        sender.text = ""
    }
    
    @IBAction func enteredInfo(_ sender: UITextField) {
        addMarkPlacement(textFieldInfo: self.searchField.text ?? "")
    }
    
    func addGestureRecognizerForView(){
        let tapGesture = UITapGestureRecognizer(target: self.view, action: #selector(view.endEditing(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    func addMarkPlacement(textFieldInfo : String){
        geoCoder.geocodeAddressString(textFieldInfo) {
            (placemarks, error) in
            if let address = placemarks?[0]{
                let annotation = MKPointAnnotation()
                annotation.coordinate = address.location!.coordinate
                annotation.title = textFieldInfo
                self.mapView.showAnnotations([annotation], animated: true)
                self.mapView.selectAnnotation(annotation, animated: true)
            }
        }
    }

}
