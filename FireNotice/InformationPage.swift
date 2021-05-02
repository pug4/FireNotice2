//
//  InformationPage.swift
//  fireTracker
//
//  Created by JOJO
//  Copyright © 2021 Jayu. All rights reserved.
//

import UIKit

class InformationPage: UIViewController{
    lazy var view0: UIView = {
            let view = UIView()
            view.backgroundColor = .systemGreen
            let label = UILabel()
            let button = UIButton()
        label.font = UIFont(name: "TrebuchetMS", size: 15)
        label.lineBreakMode = .byWordWrapping
            label.text = "See if your current location is close to a fire"
            label.textAlignment = .center
            button.setTitle("Dismiss", for: .normal)
            button.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.widthAnchor.constraint(equalToConstant: 75).isActive = true
            button.heightAnchor.constraint(equalToConstant: 50).isActive = true
            button.translatesAutoresizingMaskIntoConstraints = false
        
            //button.frame.origin = CGPoint(x:200, y:300)
        button.frame = CGRect(x: 50, y: 50, width: button.frame.width, height: button.frame.height)
            view.addSubview(button)
        NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: -75).isActive = true
            view.addSubview(label)
            label.edgeTo(view: view)
            return view
        }()
        
        lazy var view1: UIView = {
            let view = UIView()
            view.backgroundColor = .systemGreen
            let label = UILabel()
            let button = UIButton()
            label.lineBreakMode = .byWordWrapping
            label.font = UIFont(name: "TrebuchetMS", size: 15)
            label.text = "Add locations, like homes and schools to stay updated on dangers away from you"
            label.textAlignment = .center
            button.setTitle("Dismiss", for: .normal)
                button.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
                button.translatesAutoresizingMaskIntoConstraints = false
                button.widthAnchor.constraint(equalToConstant: 75).isActive = true
                button.heightAnchor.constraint(equalToConstant: 50).isActive = true
                button.translatesAutoresizingMaskIntoConstraints = false
                //button.frame.origin = CGPoint(x:200, y:300)
            button.frame = CGRect(x: 50, y: 50, width: button.frame.width, height: button.frame.height)
                view.addSubview(button)
            NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: -75).isActive = true
                view.addSubview(label)
                label.edgeTo(view: view)
            return view
        }()
        
        lazy var view2: UIView = {
            let view = UIView()
            let button = UIButton()
            view.backgroundColor = .systemGreen
            let label = UILabel()
            label.text = "Learn effective ways to evacuate"
            label.lineBreakMode = .byWordWrapping
            label.font = UIFont(name: "TrebuchetMS", size: 15)
            label.textAlignment = .center
            button.setTitle("Dismiss", for: .normal)
                button.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
                button.translatesAutoresizingMaskIntoConstraints = false
                button.widthAnchor.constraint(equalToConstant: 75).isActive = true
                button.heightAnchor.constraint(equalToConstant: 50).isActive = true
                button.translatesAutoresizingMaskIntoConstraints = false
                //button.frame.origin = CGPoint(x:200, y:300)
            button.frame = CGRect(x: 50, y: 50, width: button.frame.width, height: button.frame.height)
                view.addSubview(button)
            NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: button, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1, constant: -75).isActive = true
                view.addSubview(label)
                label.edgeTo(view: view)
            return view
        }()
        
        lazy var views = [view0, view1, view2]
        
        lazy var scrollView: UIScrollView = {
            let scrollView = UIScrollView()
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.isPagingEnabled = true
            scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(views.count), height: view.frame.height)
            
            for i in 0..<views.count {
                scrollView.addSubview(views[i])
                views[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            }
            
            scrollView.delegate = self as UIScrollViewDelegate
            
            return scrollView
        }()
        
        lazy var pageControl: UIPageControl = {
            let pageControl = UIPageControl()
            pageControl.numberOfPages = views.count
            pageControl.currentPage = 0
            pageControl.addTarget(self, action: #selector(pageControlTapHandler(sender:)), for: .touchUpInside)
            return pageControl
        }()
        
        @objc
        func pageControlTapHandler(sender: UIPageControl) {
            scrollView.scrollTo(horizontalPage: sender.currentPage, animated: true)
        }
    @objc func dismissAction(){
        dismiss(animated: true)
    }

        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view.
            
            view.addSubview(scrollView)
            scrollView.edgeTo(view: view)
            
            view.addSubview(pageControl)
            pageControl.pinTo(view)
        }
    

    }

    extension InformationPage: UIScrollViewDelegate {
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let pageIndex = round(scrollView.contentOffset.x / view.frame.width)
            pageControl.currentPage = Int(pageIndex)
        }
    }
