//
//  MapViewController.swift
//  Table
//
//  Created by ADMIN on 05/01/2020.
//  Copyright © 2020 ADMIN. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    var restaurant: Restaurant!
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBAction func mapClose(segue: UIStoryboardSegue) {
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self

        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(restaurant.location!) { (placemarks, error) in
            guard error == nil else { return }
            guard let placemarks = placemarks else { return }
        
            let placemark = placemarks.first!
            
            let annotation = MKPointAnnotation()
            annotation.title = self.restaurant.name
            annotation.subtitle = self.restaurant.type
            
            guard let location = placemark.location else { return }
            annotation.coordinate = location.coordinate
            
            self.mapView.showAnnotations([annotation], animated: true)
            self.mapView.selectAnnotation(annotation, animated: true)
        }
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !(annotation is MKUserLocation) else { return nil }
        
        let annotationIdentifier = "restAnnotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.canShowCallout = true
        }
        
        let rightImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        rightImage.image = UIImage(data: restaurant.image! as Data) //UIImage(named: restaurant.image)
        annotationView?.rightCalloutAccessoryView = rightImage
        let btn = UIButton(type: .detailDisclosure)
        annotationView?.leftCalloutAccessoryView = btn
        annotationView?.pinTintColor = #colorLiteral(red: 0.1294117719, green: 0.2156862766, blue: 0.06666667014, alpha: 1)
        
        
        return annotationView
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
      if control == view.leftCalloutAccessoryView {
        let alertController = UIAlertController(title: "Время Роботы", message: restaurant.time, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        let actionTow = UIAlertAction(title: "Заказать столик", style: .default, handler: { (action) in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ReserveATable") as! reserveTableViewController
            self.present(vc, animated: true, completion: nil)
            })
        alertController.addAction(action)
        alertController.addAction(actionTow)
        self.present(alertController, animated: true, completion: nil)

      }
        
    }
    
}
