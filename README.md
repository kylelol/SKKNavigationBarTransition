# SKKNavigationBarTransition 
##Requirements
* iOS 8+, Swift. 

##Installation
1. Download or clone the project and copy the contents of the SKKNavigationBarTransition folder into your project. 
2. Create a property for the animation controller in the view controller you want the custom transition to happen from.
* '''
let navBarAnimationController = KKPanAnimationController()
'''
3. Adhere to the 'UIViewControllerTransitioningDelegate' protocol in the same 'UIViewController' that contains the animation controller property.
4. Before presenting the new 'UIViewController' you must do the following
* Set the '.modalPresentationStyle = .Custom'
* Set the '.transitioningDelegate' to the view controller that implemented the 'UIViewControllerTransitioningDelegate' protocol.