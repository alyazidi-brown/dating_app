//
//  FacebookViewController.swift
//  DatingApp
//
//  Created by Scott Brown on 8/3/22.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FirebaseAuth

class FacebookViewController: UIViewController, LoginButtonDelegate {
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let loginButton = FBLoginButton(frame: .init(x: 50, y: 300, width: 200, height: 100), permissions: [.publicProfile])
        loginButton.center = view.center
        loginButton.delegate = self
        self.view.addSubview(loginButton)
        
            // Handle clicks on the button
   // loginButton.addTarget(self, action: #selector(loginButtonClicked), for: .touchUpInside)
        
        if let accessToken = AccessToken.current,
           !accessToken.isExpired {
                // User is logged in, do work such as go to next view controller.
            print("User is already logged in")
            print(accessToken)
            firebaseFaceBookLogin(accessToken: accessToken.tokenString)
          
       }
            
    }
    
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        print("User Logged In")
        
        if let error = error {
            print("Encountered Erorr: \(error)")
        } else if let result = result, result.isCancelled {
            print("Cancelled")
        }else {
            
            print("Logged In")
            
            if ((result?.grantedPermissions) != nil) == true {
                
            } else if ((result?.declinedPermissions) != nil) == true {
                
            }
            
        }
    
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("User Logged Out")
    }
    
    /*
        // Once the button is clicked, show the login dialog
    @objc func loginButtonClicked() {
                let loginManager = LoginManager()
                loginManager.logIn(permissions: ["public_profile", "email"], from: self) { result, error in
                    if let error = error {
                        print("Encountered Erorr: \(error)")
                    } else if let result = result, result.isCancelled {
                        print("Cancelled")
                    } else {
                        print("Logged In")
                    }
                }
            }
    */
    
    
    func firebaseFaceBookLogin(accessToken: String) {
        
        let credential = FacebookAuthProvider.credential(withAccessToken: accessToken)
        Auth.auth().signIn(with: credential, completion: {(authResult, error) in
            
            if let error = error {
                print("firebase login error")
                print(error)
                return
            }
            
            print("firebase login done")
            print(authResult as Any)
            if let user = Auth.auth().currentUser {
                
                print("Current firebase user is")
                print(user)
            }
            
            
        })
    }
    


}

