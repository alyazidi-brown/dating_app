//
//  DiscoveryViewController.swift
//  DatingApp
//
//  Created by Scott Brown on 9/12/22.
//

import UIKit
import Kingfisher
import FirebaseAuth
import GeoFire
import MapKit
import CoreLocation

class DiscoveryViewController: UITableViewController, CLLocationManagerDelegate {
    
    var locationName : String = ""
    var locationAddress : String = ""
    
    //var discoveryArray : [DiscoveryStruct] = []
    static let shared = DiscoveryViewController()
    
    var discoveryArray = [DiscoveryStruct]()
    
    var newPostsQuery = GFCircleQuery()
    
    //var locationManager: CLLocationManager? = nil
    var locationManager : CLLocationManager = CLLocationManager()
    //internal let refreshControl = UIRefreshControl()
    
    let geofire = GeoFire(firebaseRef: REF_USER_LOCATIONS)

override func viewDidLoad() {
    super.viewDidLoad()

    tableView.register(TableCell.self, forCellReuseIdentifier: "cell")
    
    
    
    self.locationManager.requestAlwaysAuthorization()
      self.locationManager.delegate = self
    
    discoveryData()
    
    if #available(iOS 10.0, *) {
        tableView.refreshControl = refreshControl
    } else {
        tableView.addSubview(refreshControl!)
    }
   
    
}
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        locationSaver()
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
}
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    if discoveryArray.count == 0 {
    self.tableView.setEmptyMessage("No cool people around here.... Don't worry check Feature tab to match you with someone cool.")
    } else {
    self.tableView.restore()
    }

    return discoveryArray.count

}

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableCell
        
    let discoverySetUp = discoveryArray[indexPath.row]
        
        
        let imageUrl = URL(string: discoverySetUp.ava)
        
        
        
        
        cell.profilePhotoImageView.kf.setImage(with: imageUrl)
        
        
        
        cell.profilePhotoImageView.tag = indexPath.row
        
        cell.profilePhotoImageView.layer.cornerRadius = cell.profilePhotoImageView.frame.size.width/2
        
        cell.profilePhotoImageView.layer.masksToBounds = true
        
        cell.profilePhotoImageView.clipsToBounds = true
        
        
        
        
    cell.nameLabel.text = discoverySetUp.firstName//"TableViewCell programtically"
    cell.nameLabel.textAlignment = .center
    cell.nameLabel.textColor  = .black
        
    cell.locationLabel.text = discoverySetUp.place
    cell.nameLabel.textAlignment = .center
    cell.nameLabel.textColor  = .red
        
    return cell
}

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
}
    
    
    func locationSaver() {
     
        DispatchQueue.main.asyncAfter(deadline: .now() + 15) {
            
            var refreshAlert = UIAlertController(title: "We want to know where is popping!", message: "Can we save this location?", preferredStyle: UIAlertController.Style.alert)

            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
              print("Handle Ok logic here")
                
                self.saveLocation()
                
              }))

            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
              print("Handle Cancel Logic here")
                
                
              }))

            self.present(refreshAlert, animated: true, completion: nil)
            
            
            print("Timer fired!")
            
            
        }
    
        
        
    }
    
    func saveLocation() {
        
        let url:URL = URL(string: "http://localhost/Dating_App2/locationEntry.php")!
        let session = URLSession.shared
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        
        
        
        let paramString: String = "locationName=\(locationName)&locationAddress=\(locationAddress)"
            
          print("paramString \(paramString)")
        
        
        request.httpBody = paramString.data(using: String.Encoding.utf8)
        
        print("paramString2 \(paramString)")
        
        
        //STEP 2.  Execute created above request.
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (data, response, error) in
            
            print("paramString3 \(paramString)")
            
            guard let _:Data = data, let _:URLResponse = response  , error == nil
                
                else {
                    //print("error")
                    if error != nil {
                        
                        
                    }
                    return
            }
            
            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("YOU THERE ESSAY3? \(dataString)")
            
            DispatchQueue.main.async
                {
                print("YOU THERE ESSAY4? ")
                    
                    
                    do {
                        
                     
                     
                        print("YOU THERE ESSAY13? ")
                        
                        let datadata = dataString!.data(using: String.Encoding.utf8.rawValue)
                        
                        if let json = try JSONSerialization.jsonObject(with: datadata!, options: []) as? [String : Any] {

                       
                        print("YOU THERE ESSAY14? ")

                        
                        // uploaded successfully
                        if json["status"] as! String == "200" {
                            
                            print("YOU THERE ESSAY6? \(dataString)")
                            
                            self.presentAlertController(withTitle: "Thanks!", message: "Survey contribution successful.")
                            
                            
                        // error while uploading
                        } else {
                            
                            print("YOU THERE ESSAY7?")
                            
                            // show the error message in AlertView
                            if json["message"] != nil {
                                let message = json["message"] as! String
                                
                                self.presentAlertController(withTitle: "JSON Error", message: message)
                                
                              
                            }
                        }
                            
                        }
                        
                    }
                    catch
                    {
                    
                    self.presentAlertController(withTitle: "JSON Error", message: error.localizedDescription)
                    
                   
                        
                    }
            }
          
            
        })
            
            .resume()
        
        
        
    }
    

    
    func discoveryData() {
        
        print("you here")
        
          
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
         
        
        fetchDrivers(location: User.location) { (driver) in
        
                   
                 let firstName = driver.firstName
                     
                 let email = driver.email
                     
                 let uid = driver.uid
                     
                 let ava = driver.ava
                 
                 let place = driver.place
                 
                 print("here is driver stuff \(driver) \(place) \(uid) \(currentUid)")
                 
                 
                 if currentUid != uid {//&& place == User.place {
                     
                     let discovery = DiscoveryStruct(firstName: firstName, email: email, ava: ava, uid: uid, place: place)
                     
                     print("you should be empty at some point\(self.discoveryArray)")
                     
                
                     
                     if  self.discoveryArray.contains{ $0.uid == uid } {
                         
                         
                     } else {
                     
                 self.discoveryArray.append(discovery)
                         
                     }
                     
                     print("discovery array \(discovery) \(self.discoveryArray)")
                     
                 DispatchQueue.main.async {

                 self.tableView.reloadData()
                                     
                                     
                                         
                 }
                 
                 } else {
                     
                     
                     
                 }
                 
                 
             }
        
                     print("now I go here")
        
     }
    
    
    
    
   
    
    func setCustomRegion(coordinates: CLLocationCoordinate2D) {
        let region = CLCircularRegion(center: coordinates, radius: 25, identifier: "")
        locationManager.startMonitoring(for: region)
    }
    
    
    
    func fetchUserData(uid: String, completion: @escaping(UserFirebase) -> Void) {
        
      
       
        
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
            
            print("what's in the array \(self.discoveryArray)")
            
            self.discoveryArray.removeAll()
            
            print("what's in the array 2\(self.discoveryArray)")
            
            print("second section \(location) \(snapshot)")
           
            
          geofire.query(at: location, withRadius: 5).observe(.keyEntered, with: { (uid, location) in
                
           
                print("third section \((uid, location))")
       
                if self.distanceCalculator(location: location) <= 10.0 {
                
                    self.fetchUserData(uid: uid, completion: { (user) in
                    
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



extension UITableView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message//"No cool people around here.... Don't worry check Feature tab to match you with someone cool."
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}





