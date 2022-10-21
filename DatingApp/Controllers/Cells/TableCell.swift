//
//  TableCell.swift
//  DatingApp
//
//  Created by Scott Brown on 9/27/22.
//

import UIKit

class TableCell: UITableViewCell {

    /*
    let nameLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Set any attributes of your UI components here.
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.systemFont(ofSize: 20)
        
        // Add the UI components
        contentView.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            nameLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
     */
    
   
     
     
     let nameLabel : UILabel = {
     let lbl = UILabel()
     lbl.textColor = .black
     lbl.font = UIFont.boldSystemFont(ofSize: 16)
     lbl.textAlignment = .left
     return lbl
     }()
    
    let locationLabel : UILabel = {
    let lbl = UILabel()
    lbl.textColor = .red
    lbl.font = UIFont.boldSystemFont(ofSize: 12)
    lbl.textAlignment = .left
    return lbl
    }()
     
    
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
       
        
           return theImageView
        }()
    
     
     
     
     
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
     super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    addSubview(profilePhotoImageView)
    addSubview(nameLabel)
    addSubview(locationLabel)
     
    profilePhotoImageView.anchor(left: leftAnchor, paddingLeft: 20, width: 50, height: 50)
        
    profilePhotoImageView.centerY(inView: contentView)
    
    nameLabel.anchor(top: topAnchor, left: profilePhotoImageView.rightAnchor, right: rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20, height: 50)
        
    locationLabel.anchor(top: nameLabel.bottomAnchor, left: profilePhotoImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 20)
    
     
     
    
     
     }
     
    required init?(coder aDecoder: NSCoder) {
        fatalError("We aren't using storyboards")
    }
}
