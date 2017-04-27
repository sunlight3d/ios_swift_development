//
//  PetViewController.swift
//  FirebaseTutorial
//
//  Created by Nguyen Duc Hoang on 4/25/17.
//  Copyright © 2017 Nguyen Duc Hoang. All rights reserved.
//

import UIKit

class PetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView:UITableView?
    var pets: [Pet] = [Pet]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(item: tableView ?? UITableView(), attribute: .top,
                                              relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: tableView ?? UITableView(), attribute: .right,
                                              relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: tableView ?? UITableView(), attribute: .bottom,
                                              relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: tableView ?? UITableView(), attribute: .left,
                                              relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0))
        tableView?.register(UINib(nibName: "PetTableViewCell", bundle: nil), forCellReuseIdentifier: "PetTableViewCell")
        // Do any additional setup after loading the view.
        pets = [Pet]()
        (UIApplication.shared.delegate as! AppDelegate).fireBaseRef.observe(.value, with: { snapshot in
            let dictRoot = snapshot.value as? [String : AnyObject] ?? [:]
            let dictPets = dictRoot["pets"] as? [String: AnyObject] ?? [:]
            for key in Array(dictPets.keys) {
                self.pets.append(Pet(dictionary: dictPets[key] as! [String: AnyObject], key: key))
            }
            self.tableView?.reloadData()
            print(dictPets)
        })

        // Do any additional setup after loading the view.
        navigationController?.isNavigationBarHidden = false
        self.customizeNavigationBar()
    }
    func customizeNavigationBar() {
        navigationController?.navigationBar.barTintColor = UIColor(red: 68 / 255, green: 169 / 255, blue: 128 / 255, alpha: 1)
        //        navigationController?.navigationBar.tintColor = UIColor.white
        self.title = "Pets list"
        navigationController?.navigationBar.isTranslucent = false;
        let btnAdd = UIButton(type: .custom)
        btnAdd.setImage(#imageLiteral(resourceName: "icon_add"), for: .normal)
        btnAdd.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btnAdd.addTarget(self, action: #selector(btnAdd(sender:)), for: .touchUpInside)
        let rightButton = UIBarButtonItem(customView: btnAdd)
        navigationItem.setRightBarButton(rightButton, animated: true)
    }
    
    @IBAction func btnAdd(sender: AnyObject) {
        print("press btnAdd")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PetTableViewCell", for: indexPath) as! PetTableViewCell
        let eachPet = pets[indexPath.row]
        cell.lblPetName.text = eachPet.name
        cell.lblPetAge.text = "\(eachPet.age)"
        if(eachPet.imageName.characters.count > 0) {
            let imageRef = (UIApplication.shared.delegate as! AppDelegate).firebaseStorage?.reference().child("images").child(eachPet.imageName)
//            Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
            imageRef?.data(withMaxSize: 10 * 1024 * 1024) { data, error in
                if error != nil {
                    cell.imgageViewPet.image = #imageLiteral(resourceName: "icon_loading")
                } else {
                    // Data for "images/island.jpg" is returned
                    cell.imgageViewPet.image = UIImage(data: data!)
                }
            }
            
//            let downloadTask = imageRef?.write(toFile: URL(string: eachPet.imageName)!) { url, error in
//                if error != nil {
//                    cell.imgageViewPet.image = #imageLiteral(resourceName: "icon_loading")
//                } else {
//                    // Data for "images/island.jpg" is returned
//                    try! cell.imgageViewPet.image = UIImage(data: Data(contentsOf: url!))
//                }
//            }

            

        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }


}
