//
//  ViewController.swift
//  ZoomingPDFViewer
//
//  Created by Fabio A. Camichel on 01.01.16.
//  Copyright © 2016 Fabio A. Camichel. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPageViewControllerDelegate {
    
    var pageViewController: UIPageViewController!
    var modelController: ModelController!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        modelController = ModelController()
        pageViewController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.PageCurl, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)
        pageViewController.delegate = self
        
        let startingViewController = self.modelController.viewControllerAtIndex(0, storyboard: self.storyboard!) as DataViewController
        
        let viewControllers:[DataViewController] = [startingViewController]
        
        self.pageViewController.setViewControllers(viewControllers, direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        
        self.pageViewController.dataSource = self.modelController
        
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        
        // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
        let pageViewRect = self.view.bounds
        self.pageViewController.view.frame = pageViewRect
        self.pageViewController.didMoveToParentViewController(self)
        
        // Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
        self.view.gestureRecognizers = self.pageViewController.gestureRecognizers

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(pageViewController: UIPageViewController, spineLocationForInterfaceOrientation orientation: UIInterfaceOrientation) -> UIPageViewControllerSpineLocation {
        
        //pretty_function()
        if (UIInterfaceOrientationIsPortrait(orientation)) || (UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone) {
            // In portrait orientation or on iPhone: Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to YES, so set it to NO here.
            
            let currentViewController = self.pageViewController.viewControllers![0] as UIViewController
            let viewControllers = [currentViewController]
            self.pageViewController.setViewControllers(viewControllers, direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
            self.pageViewController.doubleSided = false
            return UIPageViewControllerSpineLocation.Min
        }
        // In landscape orientation: Set set the spine location to "mid" and the page view controller's view controllers array to contain two view controllers. If the current page is even, set it to contain the current and next view controllers; if it is odd, set the array to contain the previous and current view controllers.
        let currentViewController = self.pageViewController.viewControllers?[0] as! DataViewController
        
        var viewControllers:[UIViewController] = []
        let indexOfCurrentViewController = self.modelController.indexOfViewController(currentViewController)
        
        if (indexOfCurrentViewController == 0 || indexOfCurrentViewController % 2 == 0) {
            let nextViewController: UIViewController = self.modelController.pageViewController(self.pageViewController, viewControllerAfterViewController: currentViewController)!
            viewControllers = [currentViewController, nextViewController]
        }
        else {
            let previousViewController: UIViewController = self.modelController.pageViewController(self.pageViewController, viewControllerBeforeViewController: currentViewController)!
            viewControllers = [previousViewController, currentViewController]
        }
        
        self.pageViewController.setViewControllers(viewControllers, direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        
        return UIPageViewControllerSpineLocation.Mid
    }

}

