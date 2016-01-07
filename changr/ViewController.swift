
// NOTE TO SELF: Do not use appdelegate for firebase operation
// rather have a model that can be mocked

import UIKit

class ViewController: UIViewController {

    // MARK: Properties

    var appDelegate: AppDelegate!
    var firebase: FirebaseWrapper!
    var welcomeLabel: UILabel!
    var descriptionLabel: UILabel!

    // MARK: UIViewController Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        firebase = appDelegate.firebase
        displayWelcomeLabel()
        displayDescriptionLabel()
    }

    func displayWelcomeLabel() {

        welcomeLabel = UILabel(frame: CGRectMake(0, 0, 350, 350))
        welcomeLabel.text = "Welcome to Changr!"
        welcomeLabel.font = UIFont(name: "HelveticaNeue", size: 30)
        welcomeLabel.font = UIFont.boldSystemFontOfSize(30)
        welcomeLabel.textColor = UIColor.whiteColor()
        welcomeLabel.center = CGPointMake(200, 90)
        welcomeLabel.textAlignment = NSTextAlignment.Center
        view.addSubview(welcomeLabel)

        // Welcome Label Animation:
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.welcomeLabel.center = CGPointMake(160, 270)
            }, completion: nil)
    }

    func displayDescriptionLabel() {

        descriptionLabel = UILabel(frame: CGRectMake(0, 0, 255, 230))
        descriptionLabel.text = "...This app was built by a team of Makers Academy students. It is to help people who are homeless in receiving donations from the general public. The app works with Estimote beacons so that donors can receive a custom notification on their phone when walking past a registered homeless person..."
        descriptionLabel.font = UIFont.italicSystemFontOfSize(17)
        descriptionLabel.backgroundColor = UIColor(red: 0/255.0, green: 157/255.0, blue: 139/255.0, alpha: 1)
        descriptionLabel.center = CGPointMake(200, 90)
        descriptionLabel.textAlignment = NSTextAlignment.Center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.layer.masksToBounds = true
        descriptionLabel.layer.cornerRadius = 8.0
        view.addSubview(descriptionLabel)

        descriptionLabel.alpha = 0

        // Description Label Animation:
        UIView.animateWithDuration(2.0, delay: 0.5, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.0, options: UIViewAnimationOptions.TransitionNone, animations: {
            self.descriptionLabel.center = CGPointMake(160, 425)
            self.descriptionLabel.alpha = 1
            }, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Actions
    @IBAction func menuButton(sender: AnyObject) {
        appDelegate.centerContainer!.toggleDrawerSide(.Left, animated: true, completion: nil)
    }

    @IBAction func logoutButton(sender: AnyObject) {
        firebase.ref.unauth()
        appDelegate.window?.rootViewController = appDelegate.rootController
        appDelegate.window!.makeKeyAndVisible()
    }
}
