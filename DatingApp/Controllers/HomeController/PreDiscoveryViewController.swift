//
//  PreDiscoveryViewController.swift
//  DatingApp
//
//  Created by Scott Brown on 10/4/22.
//

import UIKit
import Kingfisher
import FirebaseAuth
import GeoFire
import MapKit

class PreDiscoveryViewController: UITableViewController {
    
    
    var placeArray = [PlaceList]()
    
   

override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.register(TableCell2.self, forCellReuseIdentifier: "cell2")
    
    
    requestNearbyLocations()
    
    if #available(iOS 10.0, *) {
        tableView.refreshControl = refreshControl
    } else {
        tableView.addSubview(refreshControl!)
    }

   
}
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
}
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return placeArray.count
}

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! TableCell2
        
    let discoverySetUp = placeArray[indexPath.row]
        
        
       
    cell.nameLabel.text = discoverySetUp.name//"TableViewCell programtically"
    cell.nameLabel.textAlignment = .center
    cell.nameLabel.textColor  = .black
    return cell
}

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
}
    
        // MARK: - Navigation & Pass Data
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let discoverySetUp = placeArray[indexPath.row]
        
        User.place = discoverySetUp.name
        
        print("discovery name \(discoverySetUp.name) \(User.uid)")
        
        let values = ["email": User.email, "firstName": User.firstName, "ava": User.ava, "place": discoverySetUp.name]
        
        Database.database(url: "https://datingapp-80400-default-rtdb.asia-southeast1.firebasedatabase.app").reference().child("users").child(User.uid).updateChildValues(values) { error, ref in
        
            
            print("and here")
            
            if let error = error {
                
                print("firebase error here \(error.localizedDescription)")
                    return
                  }
            
            print("Selected Row \(indexPath.row)")
            let nextVC = DiscoveryViewController()
            
            nextVC.locationAddress = discoverySetUp.address
            nextVC.locationName = discoverySetUp.name
            
            nextVC.modalPresentationStyle = .overFullScreen
            self.present(nextVC, animated: true, completion: nil)

                                       
            
        }

            // Push to next view
            //navigationController?.pushViewController(nextVC, animated: true)
        }
    
    
    func requestNearbyLocations() {
            var region = MKCoordinateRegion()
        region.center = CLLocationCoordinate2D(latitude: User.location.coordinate.latitude, longitude: User.location.coordinate.longitude)
        
        print("region here \(region.center)")
        
        var address : String = ""
        
        let request = MKLocalPointsOfInterestRequest(center: region.center, radius: 20)
            //attempt 1
            //self.mapView.pointOfInterestFilter = .some(MKPointOfInterestFilter(including: []))
            //self.mapView.pointOfInterestFilter = .some(MKPointOfInterestFilter(excluding: [.restaurant, .cafe]))
            //attempt 2
           // let categories : [MKPointOfInterestCategory] = [.cafe, .restaurant]
           // let filters = MKPointOfInterestFilter(excluding: categories)
            //self.mapView.pointOfInterestFilter = .some(filters)
            
            let search = MKLocalSearch(request: request)
            search.start { (response , error ) in
                
                guard let response = response else {
                    return
                }
                
                for item in response.mapItems {
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.name
                    annotation.subtitle = item.phoneNumber
                    
                    print("places coordinate \(item.placemark.coordinate) new1 \(item.placemark) new2 \(item.description) new3 \(item.placemark.locality) new4 \(item.placemark.administrativeArea) new5 \(item.placemark.subAdministrativeArea) new6 \(item.placemark.subLocality) new7 \(item.placemark.subThoroughfare) new8 \(item.placemark.thoroughfare) new9 \(item.placemark.address)")
                    
                    
                    if item.placemark.address != nil {
                        address = item.placemark.address!
                    } else {
                        
                        if item.placemark.thoroughfare != nil {
                            
                            if item.placemark.subThoroughfare != nil{
                                
                            address = "\(item.placemark.subThoroughfare) \(item.placemark.thoroughfare)"
                                
                            } else {
                               
                                address = "\(item.placemark.thoroughfare)"
                                
                            }
                            
                        } else {
                            
                            address = "Address Not Found"
                        }
                        
                    }
                  
                    
                    let place = PlaceList(name: item.name ?? "Name Unavailable", address: address)
                    
                    print("places \(place)")
                    
                    self.placeArray.append(place)
                        
                    DispatchQueue.main.async {

                    self.tableView.reloadData()
                                        
                        
                                            
                    }
                    
                   // DispatchQueue.main.async {
                        //self.mapView.addAnnotation(annotation)
                  //  }
                    
                }
                
            }
        }
    
    
}
