//
//  HomeViewController.swift
//  Practical
//
//  Created by a on 06/02/22.
//

import UIKit
import MapKit

class HomeViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet var mapView : MKMapView!
    @IBOutlet var btnAdd : UIButton!
    
    // MARK: - IBOutlets
    var height = "0"
    var weight = 0
    var isCurrentLocationSet = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialMapSetup()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.navigationItem.title = "Home"
    }
}

// MARK: - Initial Setup
extension HomeViewController {
    func initialMapSetup() {
        LocationService.shared.currentUserLocation = { (loc) in
            if !self.isCurrentLocationSet {
                self.isCurrentLocationSet = true
                let center = CLLocationCoordinate2D(latitude: loc.coordinate.latitude, longitude: loc.coordinate.longitude)
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                self.mapView.setRegion(region, animated: true)
                
                self.mapView.mapType = MKMapType.standard
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = center
                self.mapView.addAnnotation(annotation)
            }
        }
        
        LocationService.shared.locationTrack = { (locations) in
            print(locations)
            var arrCoord = [CLLocationCoordinate2D]()
            
            if let allStoredLocations = DBHelper.getAllLoctaions(), allStoredLocations.count > 0 {
                allStoredLocations.forEach { aDbLocation in
                    arrCoord.append(CLLocationCoordinate2D(latitude: aDbLocation.latitude, longitude: aDbLocation.longitude))
                }
            }
            
            locations.forEach { aLocation in
                arrCoord.append(CLLocationCoordinate2D(latitude: aLocation.coordinate.latitude, longitude: aLocation.coordinate.longitude))
            }
            
            if arrCoord.count > 0 {
                let polyline = MKPolyline(coordinates: arrCoord, count: arrCoord.count)
                self.mapView.addOverlay(polyline)
            }
        }
    }
    
    func showAlertToGetData(placeholder : String, tag : Int, title : String) {
        self.displayAlertWithATextField(title: title, placeholder: placeholder, tag: tag) { tf in
            tf.addTarget(self, action: #selector(self.textChanged), for: .editingChanged)
        } buttonCompletion: {
            if tag == 1 {
                //Weight
                DBHelper.storeWeight(weight: self.weight)
            } else if tag == 2 {
                //Height
                DBHelper.storeHeight(height: self.height)
            }
        }
    }
    
    @objc func textChanged(_ sender: Any) {
        let tf = sender as! UITextField
        var resp : UIResponder! = tf
        while !(resp is UIAlertController) { resp = resp.next }
        let alert = resp as! UIAlertController
        
        if let text = tf.text, text.trim().count > 0 {
            if tf.tag == 1 && text.isValidWeight() {
                //Weight
                alert.actions[1].isEnabled = true
                weight = Int(text.trim()) ?? 60
            } else if tf.tag == 2 && text.isValidHeight() {
                //Height
                alert.actions[1].isEnabled = true
                height = text.trim()
            } else {
                alert.actions[1].isEnabled = false
            }
        } else {
            alert.actions[1].isEnabled = false
        }
    }
}

// MARK: - MKMapViewDelegate
extension HomeViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {

        if let routePolyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: routePolyline)
            renderer.strokeColor = UIColor.blue
            renderer.lineWidth = 5
            return renderer
        }

        return MKOverlayRenderer()
    }
}

// MARK: - IBAction
extension HomeViewController {
    @IBAction func addClick(_ sender : UIButton){
        let weight = UIAction(title: "Weight") { _ in
            self.showAlertToGetData(placeholder: "Weight", tag: 1, title: "Add Weight")
        }
        let height = UIAction(title: "Height") { _ in
            self.showAlertToGetData(placeholder: "Height (cm)", tag: 2, title: "Add Height")
        }
        
        btnAdd.menu = UIMenu(title: "Add", children: [weight, height])
        btnAdd.showsMenuAsPrimaryAction = true
    }
}
