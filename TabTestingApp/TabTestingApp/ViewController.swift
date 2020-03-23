import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var eventsFilterSegmentedControl: UISegmentedControl!
    private weak var pageViewController: UIPageViewController!
    
    private(set) lazy var viewControllers: [UIViewController] = {
        return [
            self.storyboard!.instantiateViewController(identifier: "UpcomingViewController"),
            self.storyboard!.instantiateViewController(identifier: "PastViewController")
        ]
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let firstSegTitle = eventsFilterSegmentedControl.titleForSegment(at: 0)
        let secondSegTitle = eventsFilterSegmentedControl.titleForSegment(at: 1)
        
        debugPrint("firstSegTitle: \(String(describing: firstSegTitle))")
        debugPrint("secondSegTitle: \(String(describing: secondSegTitle))")
    }

    @IBAction func eventsFilterValueChanged(_ sender: UISegmentedControl) {
        debugPrint("current index: \(sender.selectedSegmentIndex)")

        let requestedViewController = viewControllers[sender.selectedSegmentIndex]
        
        // Change what is displayed here!
        pageViewController.setViewControllers(
            [requestedViewController],
            direction: .forward,
            animated: false) { someValue in
                debugPrint("completion: some value = \(someValue)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        debugPrint("prepare for segue: \(String(describing: segue.identifier))")
        
        if segue.identifier == "showPages" {
            if let pageVC = segue.destination as? UIPageViewController {
                pageViewController = pageVC
                
                pageVC.dataSource = self
                pageVC.delegate = self
                
                let upcomingViewController = viewControllers[0]
                
                pageVC.setViewControllers(
                    [upcomingViewController],
                    direction: .forward,
                    animated: true) { someValue in
                        debugPrint("completion: some value = \(someValue)")
                }
            }
        }
    }
}

extension ViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        debugPrint("viewControllerBefore")
        
        guard let viewControllerIndex = viewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        guard viewControllerIndex == 1 else {
            return nil
        }
        
        return viewControllers[0]
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        debugPrint("viewControllerAfter")

        guard let viewControllerIndex = viewControllers.firstIndex(of: viewController) else {
            return nil
        }
        
        guard viewControllerIndex == 0 else {
            return nil
        }
        
        return viewControllers[1]
    }
}

extension ViewController: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        willTransitionTo pendingViewControllers: [UIViewController]
    ) {
        debugPrint("willTransitionTo: \(pendingViewControllers[0])")
        
        guard let viewControllerIndex = viewControllers.firstIndex(of: pendingViewControllers[0]) else {
            return
        }

        eventsFilterSegmentedControl.selectedSegmentIndex = viewControllerIndex
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        debugPrint("didFinishAnimating: \(previousViewControllers[0])")
    }
}
