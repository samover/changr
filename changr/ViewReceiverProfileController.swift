
import UIKit
import Firebase


class ViewReceiverProfileController: UIViewController, UITextFieldDelegate, PayPalPaymentDelegate {
    
    // MARK: Outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var fullNameDisplay: UILabel!
    @IBOutlet weak var emailDisplay: UILabel!
    @IBOutlet weak var dateOfBirthDisplay: UILabel!
    @IBOutlet weak var genderDisplay: UILabel!
    @IBOutlet weak var donationAmount: UITextField!
    @IBOutlet weak var baseConstraint: NSLayoutConstraint!
    @IBOutlet weak var PopUpView: UIView!

    // MARK: Properties
    var firebase: FirebaseWrapper!
    var appDelegate: AppDelegate!
    var beaconData: String!
    var currentReceiver: NSDictionary!
    var payPalConfig = PayPalConfiguration()
    var environment:String = PayPalEnvironmentNoNetwork {
        willSet(newEnvironment) {
            if (newEnvironment != environment) {
                PayPalMobile.preconnectWithEnvironment(newEnvironment)
            }
        }
    }
    var acceptCreditCards: Bool = true {
        didSet {
            payPalConfig.acceptCreditCards = acceptCreditCards
        }
    }

    // MARK: Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PopUpView.hidden = true
        PopUpView.layer.cornerRadius = 5;
        PopUpView.layer.masksToBounds = true
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate!
        firebase = appDelegate.firebase
        
        getReceiverFromDatabaseAndDisplayData()
        
        // PayPal Configuration:
        payPalConfig.acceptCreditCards = acceptCreditCards;
        payPalConfig.merchantName = "Changr"
        payPalConfig.merchantPrivacyPolicyURL = NSURL(string: "https://www.changr.com/privacy.html")
        payPalConfig.merchantUserAgreementURL = NSURL(string: "https://www.changr.com/useragreement.html")
        payPalConfig.languageOrLocale = NSLocale.preferredLanguages()[0]
        payPalConfig.payPalShippingAddressOption = .PayPal;
        PayPalMobile.preconnectWithEnvironment(environment)
        
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
        
        firebase.childRef("users").observeEventType(.Value, withBlock: { snapshot in
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
    
    // MARK: PayPalPaymentDelegate
    
    func payPalPaymentDidCancel(paymentViewController: PayPalPaymentViewController!) {
        paymentViewController?.dismissViewControllerAnimated(true, completion: nil)
        donationAmount.text = ""
    }
    
    func payPalPaymentViewController(paymentViewController: PayPalPaymentViewController!, didCompletePayment completedPayment: PayPalPayment!) {
        paymentViewController?.dismissViewControllerAnimated(true, completion: { () -> Void in
            // send completed confirmaion to your server
            print("Here is your proof of payment:\n\n\(completedPayment.confirmation)\n\nSend this to your server for confirmation and fulfillment.")
        })
        showThankYouMessage()
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
        
        let donation = donationAmount.text
        let receiverName = self.currentReceiver["fullName"] as! String
        
        let item1 = PayPalItem(name: "Receiver", withQuantity: 1, withPrice: NSDecimalNumber(string: donation), withCurrency: "GBP", withSku: "Receiver-0001")
        
        let items = [item1]
        let subtotal = PayPalItem.totalPriceForItems(items)
        
        // Optional: include payment details
        let shipping = NSDecimalNumber(string: "0.00")
        let tax = NSDecimalNumber(string: "0.00")
        let paymentDetails = PayPalPaymentDetails(subtotal: subtotal, withShipping: shipping, withTax: tax)
        
        let total = subtotal.decimalNumberByAdding(shipping).decimalNumberByAdding(tax)
        
        let payment = PayPalPayment(amount: total, currencyCode: "GBP", shortDescription: receiverName, intent: .Sale)
        
        payment.items = items
        payment.paymentDetails = paymentDetails
        
        if (payment.processable) {
            let paymentViewController = PayPalPaymentViewController(payment: payment, configuration: payPalConfig, delegate: self)
            presentViewController(paymentViewController, animated: true, completion: nil)
        }
        else { print("Payment not processalbe: \(payment)") }
    }
    
    @IBAction func homeButton(sender: AnyObject) {
        self.appDelegate.window?.rootViewController = self.appDelegate.centerContainer
        self.appDelegate.window!.makeKeyAndVisible()
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
