//
//  ViewController.swift
//  fireTracker
//
//  Created by JOJO
//  Copyright © 2020 Jayu. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications



class ViewController: UIViewController, CLLocationManagerDelegate {
    let customView = UIView()
    var overlay: UIView = UIView(frame: CGRect.zero)
    var openOrNot = true
    let button = UIButton()
    let infoLabel = UILabel()
    let dataClass = FireData()

    
    @IBOutlet weak var viewCustomizer: UIView!
    @IBAction func infoView(_ sender: UIButton) {
        if openOrNot == true{
            overlay.frame = view.bounds
            overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.overlay.backgroundColor = .clear
            self.view.addSubview(overlay)
            UIView.animate(withDuration: 0.5, animations: {
                self.overlay.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            })



            customView.frame = CGRect.init(x: 0, y: 0, width: 200, height: 200)
            customView.backgroundColor = UIColor(red: CGFloat(178/255.0), green: CGFloat(255/255.0), blue: CGFloat(89/255), alpha: CGFloat(1.0))
            self.customView.layer.cornerRadius = 20.0
            self.customView.layer.masksToBounds = true
            button.cornerRadius = 12
            button.backgroundColor = .systemTeal

            button.setTitle("Dismiss", for: .normal)
            button.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
                button.translatesAutoresizingMaskIntoConstraints = false
                button.widthAnchor.constraint(equalToConstant: 75).isActive = true
                button.heightAnchor.constraint(equalToConstant: 50).isActive = true
                button.translatesAutoresizingMaskIntoConstraints = false
            button.frame.origin = CGPoint(x: 200, y: 200)
            button.frame = CGRect(x: 50, y: 200, width: button.frame.width, height: button.frame.height)
                customView.addSubview(button)
            infoLabel.numberOfLines = 10
            infoLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
            infoLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
            infoLabel.translatesAutoresizingMaskIntoConstraints = false

            infoLabel.frame = CGRect(x: 50, y: 0, width: infoLabel.frame.width, height: infoLabel.frame.height)
            infoLabel.text = "This screen will turn RED or YELLOW depending on how close you are to a fire"
            infoLabel.lineBreakMode = .byWordWrapping
            infoLabel.font = UIFont(name: "TrebuchetMS", size: 15)
            infoLabel.textAlignment = .center
            customView.addSubview(infoLabel)

            NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: customView, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: customView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: -75).isActive = true

            customView.center = self.view.center

            self.view.addSubview(customView)
            openOrNot = false
        }else{
            customView.removeFromSuperview()
            openOrNot = true
            overlay.removeFromSuperview()
        }
    }
    
    @IBAction func refreshButton(_ sender: Any) {
        
    }
    @IBOutlet weak var warningLabel: UILabel!
    let locationManager = CLLocationManager()
    let x = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.layer.cornerRadius=25
        self.navigationController?.navigationBar.clipsToBounds = true
        
        self.viewCustomizer.layer.cornerRadius = 20.0
        self.viewCustomizer.layer.masksToBounds = true
    
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            }
        }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let currentLocation = location!.coordinate
//        print(location!)
//        print(currentLocation)
// print(dataClass.getData(lat: currentLocation.latitude, lang: currentLocation.longitude))
        if self.dataClass.getData(lat: currentLocation.latitude, lang: currentLocation.longitude) == false{
            self.viewCustomizer.backgroundColor = UIColor(red: CGFloat(178/255.0), green: CGFloat(255/255.0), blue: CGFloat(89/255), alpha: CGFloat(1.0))
            self.warningLabel.text = "All clear!"
        }
        if self.dataClass.getData(lat: currentLocation.latitude, lang: currentLocation.longitude) == true{
            self.viewCustomizer.backgroundColor = .red
            self.warningLabel.text = "There is a fire very close by, you should consider evacuating"
        }
        
        
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == CLAuthorizationStatus.denied) {
            showLocationDisabledPopUp()
        }
    }
    
    func showLocationDisabledPopUp() {
        let alertController = UIAlertController(title: "Background Location Access Disabled",
                                                message: "In order to track fires we need your location",
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(openAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    @objc func dismissAction(){
        customView.removeFromSuperview()
        openOrNot = true
        overlay.removeFromSuperview()
       }
    
}

//Database.database().reference().child("cordLad").observe(DataEventType.value, with: { (snapshot) in
//        for i in 1...snapshot.childrenCount{
//
//            ref.observe(.value, with: { (snapshot) in
//            let getData = snapshot.value as? [String:Any]
//            let wins = getData?["long"+String(i)] as? String
//            ref2.observe(.value, with: { (snapshot1) in
//            let getData2 = snapshot1.value as? [String:Any]
//            let wins2 = getData2?["lad"+String(i)] as? String
//            let databaseCordsLong = Double(wins!)
//            let databaseCordsLad = Double(wins2!)
//            var fireLocation = CLLocationCoordinate2D()
//            fireLocation.longitude = databaseCordsLong!
//            fireLocation.latitude = databaseCordsLad!
//
//
//            if currentLocation.longitude == fireLocation.longitude && currentLocation.latitude == fireLocation.latitude{
//                self.trueOrfalse.append("True")
//            }else if currentLocation.longitude + 0.0001 == fireLocation.longitude || currentLocation.latitude + 0.0001 == fireLocation.latitude{
//                self.trueOrfalse.append("Close")
//            }
//            if currentLocation.latitude != fireLocation.latitude || currentLocation.longitude != fireLocation.longitude{
//                self.warningLabel.text! = "No fires near"
//                self.warningLabel.lineBreakMode = .byWordWrapping
//                self.viewCustomizer.backgroundColor = UIColor(red: CGFloat(178/255.0), green: CGFloat(255/255.0), blue: CGFloat(89/255), alpha: CGFloat(1.0))
//                self.trueOrfalse.append("False")
//                self.warningLabel.font = UIFont(name: "TrebuchetMS", size: 15)
//            }
//            if self.trueOrfalse.contains("True") == true{
//                self.warningLabel.text! = "There is a fire near by!!"
//                self.warningLabel.lineBreakMode = .byWordWrapping
//                 self.warningLabel.font = UIFont(name: "TrebuchetMS", size: 15)
//                self.viewCustomizer.backgroundColor = .red
//            }
//            if self.trueOrfalse.contains("Close") == true{
//                self.warningLabel.text! = "There is a fire very close by, you should consider evacuating"
//                self.warningLabel.lineBreakMode = .byWordWrapping
//                self.viewCustomizer.backgroundColor = .yellow
//                 self.warningLabel.font = UIFont(name: "TrebuchetMS", size: 15)
//            }
//        })
//        })
//        }
//        })
    //let infoClass = InformationPage()
    //var databaseRef = Database.database().reference()
//    public var trueOrfalse = [String]()
    //var number = Int()
    //let appDelegate = UIApplication.shared.delegate as! AppDelegate
