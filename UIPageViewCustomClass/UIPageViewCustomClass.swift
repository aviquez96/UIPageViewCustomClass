//
//  PageVc.swift
//  PageViewControllerTutorial
//
//  Created by Adrian Viquez on 2017-08-01.
//  Copyright © 2017 Adrian Viquez. All rights reserved.
//

//Xcode Source Control Commit Test

import UIKit

//Instance of UIPageViewController
class UIPageViewCustomClass: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    //lazy since the main storyboard is not instantiated at the beginning; an array of UIViewControllers (VCArray = VCArr)
    //VCArr is an array of all the ViewControllers
    lazy var VCArr: [UIViewController] = {
        return [self.VCInstance(name: "FirstVC"),
                self.VCInstance(name: "SecondVC"),
                self.VCInstance(name: "ThirdVC")]
    } ()
    
    //PURPOSE: function that returns the view controller from the storyboard
    private func VCInstance (name: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: name)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        //first view controller.
        if let firstVC = VCArr.first{
            setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
        
        setupButton()
    }
    
    
    //Button Implementations START
    
    var button1: UIButton!
    
    //PURPOSE: Function in charge of setting a new button (initialized in viewDidLoad)
    func setupButton () {
        
        //Button initializer
        button1 = UIButton.init(type: UIButtonType.system)
        
        button1.setTitle("Le button", for: UIControlState.normal)
        
        button1.bounds = CGRect(x: 0, y: 0, width: 300, height: 80)
        button1.center = CGPoint(x: view.bounds.width/2, y: 100)
        
        //If background image is desired
        /*button1.setBackgroundImage(named: "nameOfFile, for: UIControlState.normal)*/
        
        button1.titleLabel!.font =  UIFont.systemFont(ofSize: 17)
        button1.setTitleColor(UIColor.blue, for: UIControlState.normal)
        
        //where it goes when pressed
        button1.addTarget(self, action:#selector(animateButtonPressed(sender:)), for: .touchUpInside)
        
        view.addSubview(button1)
    }
    
    //PURPOSE: function responsible for the actions of button1
    func animateButtonPressed(sender: AnyObject) {
        print("animate")
    }
    
    //Button Implementations END
    
    
    
    //PURPOSE: Changes the page controller's bottom background
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        for view in self.view.subviews {
            if view is UIScrollView {
                view.frame = UIScreen.main.bounds
            }
            else if view is UIPageControl {
                //selector of the color UIColor."color"
                view.backgroundColor = UIColor.clear
            }
        }
    }
    
    //Next two functions allow View Controller to scroll left and right (including from last to first screen if needed)
    
    //PURPOSE: Tells the current View Controller what comes before it in the VCArray
    //RESULT: assings an index to the view controller if true, false otherwise
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        //Assigns an index if view controller is retrieved, otherwise, returns nothing
        guard let viewControllerIndex = VCArr.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            //allows to loop from last to first screen
            return VCArr.last
        }
        
        guard VCArr.count > previousIndex else {
            return nil
        }
        
        return VCArr[previousIndex]
    }
    
    //PURPOSE: Tells the current View Controller what comes after it in the VCArray
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = VCArr.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < VCArr.count else {
            return VCArr.first
        }
        
        guard VCArr.count > nextIndex else {
            //allows to loop from first to last screen
            return nil
        }
        
        return VCArr[nextIndex]
    }
    
    //Next Two functions are responsible for the 3 dots in the bottom screen
    
    //PURPOSE: Returns the total number of UI controllers
    public func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return VCArr.count
    }
    
    //PURPOSE: Checks the current index of the UI controller
    public func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        //if the first viewController exists, then firstViewControllerIndex is the index of VCArr; otherwise, set it to 0
        guard let firstViewController = viewControllers?.first, let firstViewControllerIndex = VCArr.index(of: firstViewController) else {
            return 0
        }
        return firstViewControllerIndex
    }
}



