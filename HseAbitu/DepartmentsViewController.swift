//
//  DepartmentsViewController.swift
//  HseAbitu
//
//  Created by Sergey on 12/6/16.
//  Copyright © 2016 Sergey. All rights reserved.
//

import UIKit

class DepartmentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var departmentsTableView: UITableView!
    @IBOutlet weak var directionLabel: UILabel!
    @IBOutlet weak var directionImageView: UIImageView!
    @IBOutlet var mainView: UIView!
    
    public var directionID : String?
    public var directionImage : UIImage?
    public var directionName : String?
    
    private var departmentsArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.directionLabel.text = directionName ?? ""
        self.directionImageView.image = directionImage ?? #imageLiteral(resourceName: "Mathematics")
        self.departmentsTableView.separatorStyle = .none
        fetchDepartments()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addBarFilter()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = true
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setCustomNavigationBar()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return departmentsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Department Cell") as! DepartmentsTableViewCell
        cell.departmentLabel.text = departmentsArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Show Department Info", sender: self)
        self.navigationItem.title = ""
        //set up data transfer
    }
    
    private func fetchDepartments(){
        let url = URL(string: "http://abitir.styleru.net/api/getFacultiesByDirId")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let postString = "id=2" //+ (self.directionID ?? "0")
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard data != nil, error == nil else{
                print("error : \(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                print("Wrong status code : \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            DispatchQueue.main.async {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                    for dictionary in json as! [[String : String]]{
                        self.departmentsArray.append(dictionary["fac_name"] ?? "")
                    }
                    
                } catch{
                    print("Failed parsing")
                }
                
                self.departmentsTableView.reloadData()
                self.setCellBottomBorder()
                self.departmentsTableView.layoutIfNeeded()
            }
            
        }
        
        task.resume()
        
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    

    
    private func setCellBottomBorder(){
        if self.departmentsArray.count != 0{
            for index in 0...self.departmentsArray.count - 1{
                let cell = self.departmentsTableView.cellForRow(at: NSIndexPath(row: index, section: 0) as IndexPath)
                let bottomBorder = CALayer()
                bottomBorder.frame = CGRect(x: 0, y: cell!.bounds.size.height - 1, width: cell!.bounds.size.width, height: 1.0)
                bottomBorder.backgroundColor = UIColor.gray.cgColor
                bottomBorder.zPosition = 10
                cell!.layer.addSublayer(bottomBorder)
            }
        }
    }
    
    private func addBarFilter(){
        let barFilter = UIView()
        barFilter.frame = CGRect(x: 0, y: 0, width: self.directionImageView.bounds.size.width, height: self.directionImageView.bounds.size.height + 2)
        barFilter.isOpaque = true
        barFilter.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.directionImageView.addSubview(barFilter)
    }
    
    private func setCustomNavigationBar(){
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barTintColor = UIColor.clear
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.isNavigationBarHidden = false
    }
    
}
