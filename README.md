## Integrating Instagram In iOS App 

1. In order to use the API, we need to register an application on the Instagram API Platform and receive a CLIENT ID. So first of all register an application. While registering all the fields are mandatory.

       For the redirect_uri field please enter a valid domain,   and write it down, because you will need it later.

2. After you enter all the required details, click on the Security tab right next to the Details tab and uncheck Disable implicit OAuth. It should be checked by default. When you are done just click the Register button.

3. If your app was successfully registered you will be redirected to the Manage Clients screen where you can find your Client Info. Instagram defaults your API to Sandbox Mode. That means that you can only use 500 requests per hour per access token.    

       That limit will be sufficient for testing, but if you want to go live then you need to submit for Production Mode. To do that, Instagram wants you to finish your app, then record a video that shows how you use their API’s, and submit for review. You also need to select which permissions you will need. The submission process is similar to the Facebook API. You can find the submission form under Manage -> Permissions.

We are done with the Instagram API Platform. Now let’s do some coding! 🤓

# The Code

Instagram doesn’t provide us with an app login like Facebook does. Instead, we need to call a specific URL directly into UIWebView which will open the Instagram login form. Then, the user should enter his credentials and our job will be to intercept the response from the callback. This is the only way of implementing Instagram’s authentication.

 Create a separate controller with UIWebView component and an IBOutlet before proceeding further.

# Add the constants

First of all, we are gonna store the constants under a struct named API. I prefer to keep all the constants under a separate file named Constants.swift.

struct API {
static let INSTAGRAM_AUTHURL = "https://api.instagram.com/oauth/authorize/"
static let INSTAGRAM_CLIENT_ID = “YOUR_CLIENT_ID”
static let INSTAGRAM_CLIENTSERCRET = “YOUR_CLIENT_SECRET”
static let INSTAGRAM_REDIRECT_URI = “ENTER_REDIRECT_URI"
 static let INSTAGRAM_USER_INFO = "https://api.instagram.com/v1/users/self/?access_token="
static let INSTAGRAM_ACCESS_TOKEN = “access_token”
static let INSTAGRAM_SCOPE = “follower_list+public_content” /* add whatever scope you need https://www.instagram.com/developer/authorization/ */
}

# Load the URL

Enter the following code inside viewDidLoad() which will call the login form from Instagram.

let authURL = String(format: “%@?client_id=%@&redirect_uri=%@&response_type=token&scope=%@&DEBUG=True”, arguments: [API.INSTAGRAM_AUTHURL,API.INSTAGRAM_CLIENT_ID,API.INSTAGRAM_REDIRECT_URI, API.INSTAGRAM_SCOPE])
let urlRequest = URLRequest.init(url: URL.init(string: authURL)!)
webView.loadRequest(urlRequest)

Get the token

We need to implement the decidePolicyFor() WKNavigationDelegate method, where we are going to intercept the access_token.

extension ViewController: WKNavigationDelegate {
   
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if let url = navigationAction.request as? URLRequest {
            print(url.debugDescription)
            self.checkRequestForCallbackURL(request: url)
        }
        decisionHandler(.allow)
    }
}

**Created some helper functions for better code organization**:

func checkRequestForCallbackURL(request: URLRequest) -> Bool {
        let requestURLString = (request.url?.absoluteString)! as String
        if requestURLString.hasPrefix(API.INSTAGRAM_REDIRECT_URI) {
            let range: Range<String.Index> = requestURLString.range(of: "#access_token=")!
            
            handleAuth(authToken: requestURLString.substring(from: range.upperBound))
            return false;
        }
        return true
    }
    

    func handleAuth(authToken: String) {
        print("Instagram authentication token ==", authToken)
        getUserInfo1(accessToken: authToken) { (true) in
            print("success")
        }
    }

The checkRequestForCallbackURL() function will check if the URL contains a prefix with your REDIRECT_URI and then retrieve the access_token. I have also created another clean function where you can handle your own logic for the access token.

If you want to fetch user information then u can refer source code, where we need to pass the access token for retrieving data.
