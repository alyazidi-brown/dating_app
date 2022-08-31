//
//  HomeViewController.swift
//  DatingApp
//
//  Created by Scott Brown on 8/29/22.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {
    
    
    let profilePhotoImageView: UIImageView = {
        let theImageView = UIImageView()
        
        if #available(iOS 13.0, *) {
        theImageView.image = UIImage(named: "user.png")
        }else{
        let image = UIImage(named: "user.png")?.withRenderingMode(.alwaysTemplate)
        theImageView.image = image
        theImageView.tintColor = UIColor.white
        }
           
           
           theImageView.translatesAutoresizingMaskIntoConstraints = false //You need to call this property so the image is added to your view
        
        let idiomHeight = UIScreen.main.bounds.height
        if idiomHeight  < 736.0 {
            
            theImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
            theImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
            
        } else {
            
            theImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
            theImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true

        }
        
        
           return theImageView
        }()
    
    
    private let firstnameLabel: UILabel = {
        let label = UILabel()
        label.text = "firstname"
        label.font = UIFont(name: "Avenir-Light", size: 14)
        label.textColor = .red
        return label
    }()
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        
        configureUI()
        
        let url = URL(string: User.ava)!
        downloadImage(from: url)
        
        firstnameLabel.text = User.firstName
        
        
        //view.backgroundColor = .systemGreen
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            // always update the UI from the main thread
            DispatchQueue.main.async() { [weak self] in
                self?.profilePhotoImageView.image = UIImage(data: data)
            }
        }
    }

    
        ////UI configuration
        func configureUI() {
            
            for view in self.view.subviews {
                view.removeFromSuperview()
            }
            
           
            
        profilePhotoImageView.layer.cornerRadius = profilePhotoImageView.frame.size.width/2
           
        profilePhotoImageView.layer.masksToBounds = true
            
            
            view.addSubview(profilePhotoImageView)
            profilePhotoImageView.centerX(inView: view)
            profilePhotoImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor)
           
            
            view.addSubview(firstnameLabel)
            firstnameLabel.anchor(top: profilePhotoImageView.bottomAnchor, left: view.leftAnchor,  paddingTop: 50, paddingLeft: 20, width: 250, height: 50)
            
        }

}

