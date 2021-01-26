//
//  ViewController.swift
//  A1_iOS_ Naina_C0789965
//
//  Created by user185555 on 1/25/21.
//

import UIKit

import MapKit


class ViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {
    @IBOutlet weak var naiview: MKMapView!
  
    var lManger = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        naiview.delegate = self
        lManger.requestWhenInUseAuthorization()
        lManger.delegate = self
        lManger.startUpdatingLocation()
        let tap = UITapGestureRecognizer(target: self, action: #selector(pressOnMap(_:)))
        naiview.addGestureRecognizer(tap)
    }
    @objc func pressOnMap(_ gesture: UITapGestureRecognizer){
        let click = gesture.location(in: naiview)
        let tabloc = naiview.convert(click, toCoordinateFrom: naiview)
        var pintitle = String()
        if naiview.annotations.count == 0{
            pintitle = "A"
        }
        else if naiview.annotations.count == 1{
            pintitle = "B"
        }
        else{
            pintitle = "C"
        }
        if let closest = naiview.annotations.closest(to: CLLocation(latitude: tabloc.latitude, longitude: tabloc.longitude)){
            naiview.removeAnnotation(closest)
            for overlay in naiview.overlays{
                naiview.removeOverlay(overlay)
            }
        }
        else{
            if naiview.annotations.count < 3{
                let annotation  = MKPointAnnotation()
                annotation.title = pintitle
                annotation.coordinate = tabloc
                naiview.addAnnotation(annotation)
                if naiview.annotations.count == 3{
                    let ploygen = MKPolygon(coordinates: naiview.annotations.map({$0.coordinate}), count: 3)
                    naiview.addOverlay(ploygen)
                }
            }
            else{
                for overlay in naiview.overlays{
                    naiview.removeOverlay(overlay)
                }
                for pin in naiview.annotations{
                    naiview.removeAnnotation(pin)
                }
            }
        }
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let _ = overlay as? MKPolygon{
            let rendrer = MKPolygonRenderer(overlay: overlay)
            rendrer.fillColor = UIColor.red
            rendrer.strokeColor = UIColor.green
            rendrer.alpha = 0.5
            return rendrer
        }
        else if let _ = overlay as? MKPolyline{
            let rendrer = MKPolylineRenderer(overlay: overlay)
            rendrer.lineWidth = 4
            rendrer.strokeColor = UIColor.purple
            return rendrer
        }
        return MKOverlayRenderer(overlay: overlay)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.first else {return}
        
        naiview.region = MKCoordinateRegion(center: loc.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    }
    
}
//took reference from stackoverflow
        extension Array where Iterator.Element == MKAnnotation {
            
            func closest(to fixedLocation: CLLocation) -> Iterator.Element? {
                guard !self.isEmpty else { return nil}
                var closestAnnotation: Iterator.Element? = nil
                var smaldest: CLLocationDistance = 5000
                for annotation in self {
                    let locationForAnnotation = CLLocation(latitude: annotation.coordinate.latitude, longitude:annotation.coordinate.longitude)
                    let distanceFromUser = fixedLocation.distance(from:locationForAnnotation)
                    if distanceFromUser < smaldest {
                        smaldest = distanceFromUser
                        closestAnnotation = annotation
                    }
                }
                return closestAnnotation
            }
        }
    






