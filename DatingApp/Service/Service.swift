//
//  Service.swift
//  DatingApp
//
//  Created by Scott Brown on 9/18/22.
//

import Firebase
import CoreLocation
import GeoFire
import FirebaseAuth
import FirebaseFirestore

// MARK: - DatabaseRefs

let DB_REF : DatabaseReference = Database.database().reference()
let auth = Auth.auth()
let db = Firestore.firestore()
var userListener : ListenerRegistration? = nil
var favsListener : ListenerRegistration? = nil

//let DB_REF  = Database.database().reference()
let REF_CONST = DB_REF.child("Constant")
let REF_PROC = DB_REF.child("Processing")
let REF_RATE = DB_REF.child("Rate")
let REF_USERS = DB_REF.child("users")
let REF_USER_LOCATIONS = DB_REF.child("user-locations")
//private var refHandle: DatabaseHandle!
let REF_TRIPS = DB_REF.child("trips")
let REF_DRIVER_TRANSIT = DB_REF.child("driver-transit")

var userArray: [UserFirebase] = []


struct UserService {
    static let shared = UserService()
    
    func fetchUserData(uid: String, completion: @escaping(UserFirebase) -> Void) {
        
        //REF_USERS.child(uid).observe(of: .value) { (snapshot) in
            
       // }
       
        
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            
            let full = snapshot.children.allObjects
            
            print("full \(full)")
            
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let uid = snapshot.key
            print("uid stuff \(uid) snap \(snapshot) dictionary \(dictionary)")
            let user = UserFirebase(uid: uid, dictionary: dictionary)
            completion(user)
        }
    }
    
    
    
    
    func fetchDrivers(location: CLLocation, completion: @escaping(UserFirebase) -> Void) {
        
        
        let geofire = GeoFire(firebaseRef: REF_USER_LOCATIONS)
        
        print("first section")
        
        REF_USER_LOCATIONS.observe(.value) { (snapshot) in
            
            print("what's in the array \(DiscoveryViewController.shared.discoveryArray)")
            
            DiscoveryViewController.shared.discoveryArray.removeAll()
            
            print("what's in the array 2\(DiscoveryViewController.shared.discoveryArray)")
            
            print("second section \(location) \(snapshot)")
            //geofire.query(with: <#T##MKCoordinateRegion#>)
            
            geofire.query(at: location, withRadius: 5).observe(.keyEntered, with: { (uid, location) in
                
                
           
                print("third section \((uid, location))")
       
                if distanceCalculator(location: location) <= 100.0 {
                
                fetchUserData(uid: uid, completion: { (user) in
                    
                    print("fourth section \(user)")
                    let driver = user
                   
                    
                    completion(driver)
                })
                    
                }
                
                 
                
                print("fifth section")
            })
            
            print("sixth section")
        }
        
        print("seventh section")
    }
     
    
    func fetchUsers(location: CLLocation, completion: @escaping(String, CLLocation) -> Void) {
        let geofire = GeoFire(firebaseRef: REF_USER_LOCATIONS)
        
        print("first section 2")
        
        REF_USER_LOCATIONS.observe(.value) { (snapshot) in
            
            print("second section 3 \(location) \(snapshot)")
            
            geofire.query(at: location, withRadius: 5).observe(.keyEntered, with: { (uid, location) in
            
           
          
           
                print("third section 2 \((uid, location))")
                
                completion(uid, location)
               
                
                print("fifth section 2")
            })
            
            print("sixth section 2")
        }
        
        print("seventh section 2")
    }
    
    
    func distanceCalculator(location: CLLocation) -> Double {
        
            //My location
        let myLocation = User.location//CLLocation(latitude: 59.244696, longitude: 17.813868)

            //My buddy's location
            let myBuddysLocation = location//CLLocation(latitude: 59.326354, longitude: 18.072310)

            //Measuring my distance to my buddy's (in km)
        let distance = myLocation.distance(from: myBuddysLocation)//myLocation.distance(from: myBuddysLocation) / 1000

            //Display the result in km
            //print(String(format: "The distance to my buddy is %.01fkm", distance))
        
            //Display the result in m
            print("The distance to my buddy is \(distance)m")
        
        return distance
    }
    
    
}






/*
func fetchDrivers(location: CLLocation, completion: @escaping(UserFirebase) -> Void) {
    let geofire = GeoFire(firebaseRef: REF_USER_LOCATIONS)
    
    print("first section")
    
    //let center = CLLocation(latitude: 37.7832889, longitude: -122.4056973)
    // Query locations at [37.7832889, -122.4056973] with a radius of 600 meters
    var circleQuery = geofire.query(at: location, withRadius: 5)//geoFire.queryAtLocation(center, withRadius: 0.6)

    // Query location by region
    //let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
    //let region = MKCoordinateRegion(location.coordinate, span)
   // var regionQuery = geoFire.queryWithRegion(region)
    
    REF_USER_LOCATIONS.observe(.value) { (snapshot) in
        
        print("second section \(location) \(snapshot)")
        
        
        
        circleQuery.observe(.keyEntered, with: { (uid, location) in
        
       
            print("third section \((uid, location))")
            
           
            
            fetchUserData(uid: uid, completion: { (user) in
                
                print("fourth section \(user)")
                let driver = user
               
                
                completion(driver)
            })
            
             
            
            print("fifth section")
        })
        
        print("sixth section")
    }
    
    print("seventh section")
}
 */
