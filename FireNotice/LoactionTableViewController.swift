//
//  LoactionTableViewController.swift
//  fireTracker
//
//  Created by JOJO
//  Copyright © 2020 Jayu. All rights reserved.
//

import UIKit
//import Firebase
import CoreLocation

class LoactionTableViewController: UITableViewController {
    
    var arrayOfNames = UserDefaults.standard.stringArray(forKey: "nameKey101")
    var arrayOfLocationsLong = UserDefaults.standard.stringArray(forKey: "locationKey121")
    var arrayOfLocationsLad =
        UserDefaults.standard.stringArray(forKey: "locationKey136")
    let dataClass = FireData()
    var trueOrfalse2 = [String]()
    let customView = UIView()
    var overlay: UIView = UIView(frame: CGRect.zero)
    var openOrNot = true
    let button = UIButton()
    var empatyView = UIView()
    let empatyViewLabel = UILabel()
    @IBAction func infoView(_ sender: Any) {
        if openOrNot == true{
            overlay.frame = view.bounds
            overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.overlay.backgroundColor = .clear
            self.view.addSubview(overlay)
            UIView.animate(withDuration: 0.5, animations: {
                self.overlay.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            })

            
            
            customView.frame = CGRect.init(x: 0, y: 0, width: 100, height: 200)
            customView.backgroundColor = .green     //give color to the view
            
            
            button.setTitle("Dismiss", for: .normal)
            button.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
                button.translatesAutoresizingMaskIntoConstraints = false
                button.widthAnchor.constraint(equalToConstant: 75).isActive = true
                button.heightAnchor.constraint(equalToConstant: 50).isActive = true
                button.translatesAutoresizingMaskIntoConstraints = false
                //button.frame.origin = CGPoint(x:200, y:300)
            button.frame = CGRect(x: 50, y: 50, width: button.frame.width, height: button.frame.height)
                customView.addSubview(button)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if arrayOfNames?.count ?? 0 > 0 {
            return 1
        } else {
            TableViewHelper.EmptyMessage(message: "Add Locations to see if your loved ones are safe!", viewController: self)
            return 0
        }    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayOfNames?.count ?? 0
    }
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        cell.layer.borderColor = UIColor.clear.cgColor
        cell.layer.borderWidth = CGFloat(10)
        let indexPathNames = arrayOfNames?[indexPath.row] ?? ""
        let indexPathLocationLong = arrayOfLocationsLong?[indexPath.row] ?? ""
        let indexPathLocationLad = arrayOfLocationsLad?[indexPath.row] ?? ""
        cell.textLabel?.text = indexPathNames
        cell.textLabel?.font = UIFont(name: "TrebuchetMS", size: 15)
        let currentLocationLong = Double(indexPathLocationLong) ?? 0
        let currentLocationLad = Double(indexPathLocationLad) ?? 0
        dataClass.getData(lat: currentLocationLad, lang: currentLocationLong)
        if self.dataClass.getData(lat: currentLocationLad, lang: currentLocationLong) == false{
              cell.backgroundColor = indexPath.row == indexPath.row ? .green : .red
        }
        if self.dataClass.getData(lat: currentLocationLad, lang: currentLocationLong) == true{
             
        }
        return cell
    }
    @objc func dismissAction(){
        customView.removeFromSuperview()
        openOrNot = true
        overlay.removeFromSuperview()
        
    }
}
class TableViewHelper {

    class func EmptyMessage(message:String, viewController: UITableViewController) {
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 200, height: 200))
        let messageLabel = UILabel(frame: rect)
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()

        viewController.tableView.backgroundView = messageLabel
        viewController.tableView.separatorStyle = .none
    }
}
//        let ref = Database.database().reference().child("cordLong")
//        let ref2 = Database.database().reference().child("cordLad")
//        Database.database().reference().child("cordLad").observe(DataEventType.value, with: { (snapshot) in
//
//        for i in 1...snapshot.childrenCount{
//            ref.observe(.value, with: { (snapshot) in
//            let getData = snapshot.value as? [String:Any]
//            let wins = getData?["long"+String(i)] as? String
//            ref2.observe(.value, with: { (snapshot1) in
//            let getData2 = snapshot1.value as? [String:Any]
//            let wins2 = getData2?["lad"+String(i)] as? String
//            let databaseCordsLong = Double(wins!)
//            let databaseCordsLad = Double(wins2!)
//            let currentLocationLong = Double(indexPathLocationLong)
//            let currentLocationLad = Double(indexPathLocationLad)
//            var fireLocation = CLLocationCoordinate2D()
//            fireLocation.longitude = databaseCordsLong!
//            fireLocation.latitude = databaseCordsLad!
//
//                if currentLocationLong == fireLocation.longitude && currentLocationLad == fireLocation.latitude{
//                    self.trueOrfalse2.append("True")
//                    print(self.trueOrfalse2)
//                    cell.backgroundColor = indexPath.row == indexPath.row ? .red : .green
//                }else if currentLocationLong ?? 0 + 0.0001 == fireLocation.longitude || (currentLocationLad ?? 0) + 0.0001 == fireLocation.latitude{
//                    self.trueOrfalse2.append("Close")
//                    print(self.trueOrfalse2)
//                    cell.backgroundColor = indexPath.row == indexPath.row ? .yellow : .green
//                }
//                if currentLocationLad != fireLocation.latitude || currentLocationLong != fireLocation.longitude{
//                    self.view.backgroundColor = .green
//                    self.trueOrfalse2.append("False")
//                    print(self.trueOrfalse2)
//
//                }
//                if self.trueOrfalse2.contains("True") == true{
//                    self.view.backgroundColor = .red
//                    print(self.trueOrfalse2)
//
//                }
//                if self.trueOrfalse2.contains("Close") == true{
//                    self.view.backgroundColor = .yellow
//                    print(self.trueOrfalse2)
//
//                }
//                })
//                })
//                }
//        })
