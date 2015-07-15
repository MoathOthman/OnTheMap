import UIKit

class OTMSignupViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        var urlRequest: NSURLRequest = NSURLRequest(URL: OTMUdacityClient.Constants.signUpWebURL!)
        self.webView.loadRequest(urlRequest)
    }
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
