
import UIKit

class ViewReceiverProfileController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var fullNameDisplay: UILabel!
    @IBOutlet weak var emailDisplay: UILabel!
    @IBOutlet weak var dateOfBirthDisplay: UILabel!
    @IBOutlet weak var genderDisplay: UILabel!
    @IBOutlet weak var donationAmount: UITextField!
    @IBOutlet weak var baseConstraint: NSLayoutConstraint!
    @IBOutlet weak var PopUpView: UIView!

    var ref: Firebase!
    var beaconData: String!
    var currentReceiver: NSDictionary!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        PopUpView.hidden = true
        PopUpView.layer.cornerRadius = 5;
        PopUpView.layer.masksToBounds = true
        
        ref = Firebase(url: "https://changr.firebaseio.com/users")
        getReceiverFromDatabaseAndDisplayData()
        
        // To move the donationAmount TextField up when keyboard appears:
        donationAmount.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: "didTapView")
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    func didTapView() { self.view.endEditing(true) }
    
    func getReceiverFromDatabaseAndDisplayData() {
        
        // Get receiver from database:
        
        ref.observeEventType(.Value, withBlock: { snapshot in
            for item in snapshot.children {
                let child = item as! FDataSnapshot
                let value = child.value as! NSDictionary
                    if value["beaconMinor"] as! String == self.beaconData {
                         self.currentReceiver = value 
                        
                        // Display the receiver's details:
                        
                        self.displayReceiverProfileImage((self.currentReceiver["profileImage"] as? String)!)
                        self.fullNameDisplay.text = (self.currentReceiver["fullName"] as! String)
                        self.emailDisplay.text = "EMAIL: \(self.currentReceiver["email"] as! String)"
                        self.dateOfBirthDisplay.text = "DOB: \(self.currentReceiver["dateOfBirth"] as! String)"
                        self.genderDisplay.text = "GENDER: \(self.currentReceiver["gender"] as! String)"
                    }
            }
        })
    }
    
    // This decodes the base64string into an UIImage:
    
    func displayReceiverProfileImage(imageString: String) {
        let decodedData = NSData(base64EncodedString: imageString, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
        let decodedImage = UIImage(data: decodedData!)
        self.profileImageView.image = decodedImage
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2;
        self.profileImageView.clipsToBounds = true
        self.profileImageView.layer.borderWidth = 1.0
        self.profileImageView.layer.masksToBounds = false
        self.profileImageView.layer.borderColor = UIColor.whiteColor().CGColor
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2
        self.profileImageView.clipsToBounds = true
        self.profileImageView.layer.borderWidth = 6.0
    }
    
    func showThankYouMessage() {
        donationAmount.text = ""
        PopUpView.hidden = false
        PopUpView.alpha = 1.0
        _ = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("removePopUp"), userInfo: nil, repeats: false)
    }
    
    func removePopUp() {
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.PopUpView.alpha = 0.0
            }, completion: nil)
    }

    // MARK: Actions
    
    // Process PayPal Payment:
    @IBAction func donateButton(sender: UIButton) {
        
    }
    
    // To move the donationAmount TextField up when keyboard appears:
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        PopUpView.hidden = true
    }
    
    func animateTextFieldWithKeyboard(notification: NSNotification) {
        
        let userInfo = notification.userInfo!
        
        let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
        let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as! UInt
        
        if notification.name == UIKeyboardWillShowNotification {
            baseConstraint.constant = -keyboardSize.height  // move up
        }
        else {
            baseConstraint.constant = 14 // move down to its original constraint
        }
        
        view.setNeedsUpdateConstraints()
        
        let options = UIViewAnimationOptions(rawValue: curve << 16)
        UIView.animateWithDuration(duration, delay: 0, options: options,
            animations: {
                self.view.layoutIfNeeded()
            },
            completion: nil
        )
    }
    
    func keyboardWillShow(notification: NSNotification) {
        animateTextFieldWithKeyboard(notification)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        animateTextFieldWithKeyboard(notification)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
