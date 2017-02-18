//
//  FraternitiesListViewController.swift
//  HseAbitu
//
//  Created by Sergey on 12/9/16.
//  Copyright © 2016 Sergey. All rights reserved.
//

import UIKit

class FraternitiesListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    private let organizationDictionary : [(UIImage, String, String)] = [
        (#imageLiteral(resourceName: "Mathematics"), "Бизнес в стиле Ru", "styleru.net"),
        (#imageLiteral(resourceName: "Mathematics"), "Бизнес в стиле Ru", "styleru.net"),
        (#imageLiteral(resourceName: "Mathematics"), "Бизнес в стиле Ru", "styleru.net"),
        (#imageLiteral(resourceName: "Mathematics"), "Бизнес в стиле Ru", "styleru.net")
    ]
    
    private var fraternityFetchedLabel : String = "Бизнес, карьера, индивидуальное развитие"
    private var fraternityFetchedImage : UIImage = #imageLiteral(resourceName: "Tennis")
    @IBOutlet weak var organizationTableView: UITableView!
    @IBOutlet weak var fraternityImage: UIImageView!
    @IBOutlet weak var fraternityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fraternityLabel.text = fraternityFetchedLabel
        self.fraternityImage.image = fraternityFetchedImage
        self.organizationTableView.separatorStyle = .none
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setCustomNavigationBar()
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let imageFilter = UIView()
        imageFilter.frame = CGRect(x: 0, y: 0, width: self.fraternityImage.bounds.size.width, height: self.fraternityImage.bounds.size.height)
        imageFilter.isOpaque = true
        imageFilter.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        fraternityImage.addSubview(imageFilter)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return organizationDictionary.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = organizationTableView.dequeueReusableCell(withIdentifier: "Organization Cell") as! OrganizationTableViewCell
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: organizationDictionary[indexPath.row].2)
        attributeString.addAttribute(NSUnderlineStyleAttributeName, value: 1, range: NSMakeRange(0, attributeString.length))
        cell.organizationImage.image = organizationDictionary[indexPath.row].0
        cell.organizationLabel.text = organizationDictionary[indexPath.row].1
        cell.organizationReference.attributedText = attributeString
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Show Organization Info", sender: self)
    }
    
    private func setCustomNavigationBar(){
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
   
}
