
import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
class LoginViewController: UIViewController {
    var client:OTMUdacityClient = OTMUdacityClient.sharedInstance()
    var backgroundGradient: CAGradientLayer? = nil

    @IBOutlet weak var emailTextField: OTMTextField!
    @IBOutlet weak var passwordTextField: OTMTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    @IBOutlet var resignkeyboard: UITapGestureRecognizer!
    @IBAction func resignKeyboard(sender: AnyObject) {
        self.emailTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
    }
    @IBAction func login(sender: AnyObject) {
        resignKeyboard(sender)

        if !validateLoginTextFields() {
            MOHUD.showWithError("Please fill all The Text Fields")
            return
        }
        MOHUD.show()
        client.loginWithCredntials(emailTextField.text, password: passwordTextField.text) { (success, sessionID, errorString) -> Void in
            if (sessionID != nil) {
                //go to tabController
                OTMUdacityClient.sharedInstance().sessionID = sessionID
                self.presentTheLocationsViewController()
                println("session id is \(sessionID)")
            }else {
                println(errorString?.localizedDescription)
                var errs = errorString?.localizedDescription
                MOHUD.showWithError(errs!)
            }
        }
    }

  
    @IBAction func signInWithFacebook(sender: AnyObject) {
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            //user has already a token
            var ctoken = FBSDKAccessToken.currentAccessToken()
             loginWithFacebook(ctoken.tokenString)
        } else {
        var facebookmanager = FBSDKLoginManager()
//            facebookmanager.loginBehavior = FBSDKLoginBehavior.Browser
        facebookmanager.logInWithReadPermissions(["email"], handler: { (loginResult: FBSDKLoginManagerLoginResult!, error) -> Void in
            if let err = error {
                println("login with facebook failed")
            }else {
                var accesstokenobject = loginResult.token
                var tokenString  = accesstokenobject.tokenString
                println("token string is \(tokenString)")
                self.loginWithFacebook(tokenString)
            }
        })
        }
    }
    func loginWithFacebook(accessToken: String!) {
        MOHUD.show()

        client.loginWithFacebook(accessToken, completionHandler: { (success, sessionID, errorString) -> Void in
            if let err = errorString {
                println("erroris \(err.localizedDescription)\n")
                MOHUD.showWithError(err.localizedDescription)
             } else {
            if (sessionID != nil) {
                // go to tabController
                OTMUdacityClient.sharedInstance().sessionID = sessionID
                self.presentTheLocationsViewController()
                println("session id is \(sessionID)")

            }else {
                println("errorloginface \(errorString?.localizedDescription)")

            }
            }

        })
    }
    func presentTheLocationsViewController() {
        self.presentViewController(ViewControllersFactory.make(ViewControllerType.locationsNavigation) as! UINavigationController, animated: true, completion:{() -> Void in
        MOHUD.dismiss()
        })

    }


    func configureUI() {
        /* Configure background gradient */
        self.view.backgroundColor = UIColor.clearColor()
        let colorTop = UIColor(red: 1, green: 148.0/255.0, blue: 56.0/255.0, alpha: 1.0).CGColor
        let colorBottom = UIColor(red: 1, green: 110.0/255.0, blue: 43.0/255.0, alpha: 1.0).CGColor
        self.backgroundGradient = CAGradientLayer()
        self.backgroundGradient!.colors = [colorTop, colorBottom]
        self.backgroundGradient!.locations = [0.0, 1.0]
        self.backgroundGradient!.frame = view.frame
        self.view.layer.insertSublayer(self.backgroundGradient, atIndex: 0)
    }

}

extension LoginViewController {

    func validateLoginTextFields() -> Bool {
        if let emailtf = emailTextField.text,
            let password = passwordTextField.text {
                if count(emailtf) > 0 && count(password) > 0 {
                    return true
                }
        }

        return false
    }
}