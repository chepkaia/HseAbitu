//
//  OrganizationInformationViewController.swift
//  HseAbitu
//
//  Created by Sergey on 12/9/16.
//  Copyright © 2016 Sergey. All rights reserved.
//

import UIKit

class OrganizationInformationViewController: UIViewController {

    @IBOutlet weak var contactButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var contactButton: UIButton!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventMainText: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainView: UIView!
    
    private var contactButtonWidth : CGFloat = 100

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.navigationBar.barStyle = .default
        addContactButton()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addBlackLines()
    }
    
    @objc private func connect(sender : UIButton){
        let url = URL(string: "https://students.hse.ru/handbook/card/studorg")
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    
    private func addContactButton(){
        let button = UIButton(type: .custom)
        button.setTitle("Связаться", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.layer.backgroundColor = UIColor.black.cgColor
        button.layer.cornerRadius = 12.0
        button.sizeToFit()
        button.bounds.size.width *= 3/2
        self.contactButtonWidth = button.bounds.size.width
        button.addTarget(self, action: #selector(OrganizationInformationViewController.connect(sender:)), for: .touchUpInside)
        let registerButton = UIBarButtonItem(customView: button)
        
        self.navigationItem.rightBarButtonItem = registerButton
    }
    
    
    private func addBlackLines(){
        let topLine = UIView()
        topLine.frame = CGRect(x: self.mainView.bounds.size.width - (self.contactButtonWidth + 50), y: self.navigationController!.navigationBar.bounds.size.height, width: self.contactButtonWidth + 50, height: 2)
        topLine.backgroundColor = UIColor.black
        
        let leftLine = UIView()
        leftLine.backgroundColor = UIColor.black
        leftLine.frame = CGRect(x: 15, y: self.eventTitle.bounds.size.height + self.navigationController!.navigationBar.bounds.size.height + 50, width: 2, height: self.mainView.bounds.size.height)
        
        self.mainView.addSubview(leftLine)
        self.mainView.addSubview(topLine)
    }
}
