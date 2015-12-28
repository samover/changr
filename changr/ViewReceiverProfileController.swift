
import UIKit

class ViewReceiverProfileController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var fullNameDisplay: UILabel!
    @IBOutlet weak var emailDisplay: UILabel!
    @IBOutlet weak var dateOfBirthDisplay: UILabel!
    @IBOutlet weak var genderDisplay: UILabel!
    
    var ref: Firebase!
    var beaconData: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Firebase(url: "https://changr.firebaseio.com/users")
        getReceiverFromDatabaseAndDisplayData()
    }
    
    func getReceiverFromDatabaseAndDisplayData() {
        
        // Get receiver from database:
        
        ref.observeEventType(.Value, withBlock: { snapshot in
            for item in snapshot.children {
                let child = item as! FDataSnapshot
                    if child.value["beaconMinor"] as! String == self.beaconData {
                        let currentReceiver = child.value
                        
                        // Display the receiver's details:
                        
                        self.displayReceiverProfileImage((currentReceiver["profileImage"] as? String)!)
                        self.fullNameDisplay.text = currentReceiver["fullName"] as! String
                        self.emailDisplay.text = "EMAIL: \(currentReceiver["email"] as! String)"
                        self.dateOfBirthDisplay.text = "DOB: \(currentReceiver["dateOfBirth"] as! String)"
                        self.genderDisplay.text = "GENDER: \(currentReceiver["gender"] as! String)"
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
