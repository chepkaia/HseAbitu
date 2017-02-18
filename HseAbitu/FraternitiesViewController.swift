//
//  FraternitiesViewController.swift
//  HseAbitu
//
//  Created by Sergey on 10/27/16.
//  Copyright © 2016 Sergey. All rights reserved.
//

import UIKit
import Foundation

class FraternitiesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var fraternityCollectionView: UICollectionView!
    var fraternityDictionary : [(String, UIImage)] = [
        ("Международные организации", #imageLiteral(resourceName: "International_projects")),
        ("Добрые проекты", #imageLiteral(resourceName: "Kind_projects")),
        ("Студенческие СМИ", #imageLiteral(resourceName: "Mass_media")),
        ("Бизнес, карьера, интелектуальное развитие", #imageLiteral(resourceName: "Biznes_karyera-2")),
        ("Раскрытие талантов", #imageLiteral(resourceName: "Detecting_talents")),
        ("Спорт, аквтивный отдых, путешествия", #imageLiteral(resourceName: "Tennis"))
    ]
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        fetchFraternities()
        super.viewDidLoad()
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.view.backgroundColor = UIColor.black
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setCustomNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setCommonNavigationBar()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Fraternity Cell", for: indexPath) as! FraternityCollectionViewCell
        cell.fraternityName.text = fraternityDictionary[indexPath.row].0
        cell.fraternityName.textColor = UIColor.white
        cell.fraternityImage.image = fraternityDictionary[indexPath.row].1
        
        if cell.didAddedImageFilter == false{
            let imageFilter = UIView()
            imageFilter.frame = CGRect(x: 0, y: 0, width: cell.bounds.size.width, height: cell.bounds.size.height)
            imageFilter.isOpaque = true
            imageFilter.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            cell.fraternityImage.addSubview(imageFilter)
            cell.didAddedImageFilter = true
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fraternityDictionary.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if fraternityDictionary.count - 1 == indexPath.row && indexPath.row % 2 == 0{
            return CGSize(width: view.frame.width, height: view.frame.width / 2)
        } else{
            return CGSize(width: view.frame.width / 2, height: view.frame.width / 2)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Show Organizations", sender: self)
    }
    
    func fetchFraternities(){
        let url = NSURL(string: "http://abitir.styleru.net/api/getAllOrganizationGroup")
        var request = URLRequest(url: url! as URL)
        request.httpMethod = "POST"
        let postString = "campus_id=2"
        request.httpBody = postString.data(using: .utf8)

        
//        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//            guard data != nil, error == nil else{
//                print("error : \(error)")
//                return
//            }
//            
//            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
//                print("Wrong status code : \(httpStatus.statusCode)")
//                print("response = \(response)")
//            }
//            
//            let responseString = String(data: data!, encoding: String.Encoding.utf8)
//            print("responseString = \(responseString)")
//            
//        }
//    
//    task.resume()
        
        
        
    }
    
    private func setCustomNavigationBar(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    private func setCommonNavigationBar(){
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.view.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.barTintColor = UIColor.white
    }
       
    
}
