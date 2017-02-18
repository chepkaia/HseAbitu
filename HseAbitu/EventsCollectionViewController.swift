//
//  EventsCollectionViewController.swift
//  HseAbitu
//
//  Created by Sergey on 11/22/16.
//  Copyright © 2016 Sergey. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class EventsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    @IBOutlet var eventsCollectionView: UICollectionView!
    
    @IBAction func filterButtonPressed(_ sender: AnyObject) {
        let transition:CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromBottom
        self.navigationController!.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.pushViewController((self.navigationController?.visibleViewController)!, animated: true)
    }
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    private var eventsData = [String : (title : String, text : String, image : UIImage, place : String, date : String)]()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewFlowLayout.minimumLineSpacing = 30
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        fetchEvents()
        
        print("Data is reloading")
    }
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.eventsData.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Event Cell", for: indexPath) as! EventCollectionViewCell
        let eventId = String(indexPath.row + 1)
        cell.eventMainText.text = eventsData[eventId]?.title ?? ""
        cell.dateLabel.text = eventsData[eventId]?.date ?? ""
        cell.placeLabel.text = eventsData[eventId]?.place ?? ""
        cell.backgroundImage.image = eventsData[eventId]?.image ?? #imageLiteral(resourceName: "Mathematics")
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 20, height: 1)
        cell.layer.shadowRadius = 10
        cell.layer.shadowOpacity = 0.7
        if (cell.didAddedFilterToImageView == false){
            let imageFilter = UIView()
            imageFilter.frame = CGRect(x: 0, y: 0, width: cell.bounds.size.width, height: cell.bounds.size.height)
            imageFilter.isOpaque = true
            imageFilter.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            cell.backgroundImage.addSubview(imageFilter)
            cell.didAddedFilterToImageView = true
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: eventsCollectionView.bounds.size.width, height: eventsCollectionView.bounds.size.width * (4 / 6))
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Show Event Information", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Filter View"{
            //perform segue
        }
        if segue.identifier == "Show Event Information"{
            let destinationVC = segue.destination as! NewsInformationViewController
            
        }
        
    }
    
    func fetchEvents(){
        let url = URL(string: "http://abitir.styleru.net/api/getAllArticles")
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil{
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! Array<Any>
                
                    for dictionary in json as! [[String : String]]{
                        let id = dictionary["article_id"]!
                        
                        if newsFilter.isFilterON() == false{
                            self.eventsData[id] = (title: dictionary["article_title"]!,
                                                   text : dictionary["article_text"]!,
                                                   image : #imageLiteral(resourceName: "iMG3202"),
                                                   place : dictionary["article_place"]!,
                                                   date : dictionary["article_date"]!)
                        } else{
                            if newsFilter.filterMask[dictionary["articles_filter"]!]! {
                                self.eventsData[id] = (title: dictionary["article_title"]!,
                                                       text : dictionary["article_text"]!,
                                                       image : #imageLiteral(resourceName: "iMG3202"),
                                                       place : dictionary["article_place"]!,
                                                       date : dictionary["article_date"]!)
                            }
                        }
                    }
                }
                catch{
                    print("Unable to read data from url")
                    return
                }
                
                self.eventsCollectionView.reloadData()
                
            }
            
            
            
            
        }
        task.resume()
    }


}
