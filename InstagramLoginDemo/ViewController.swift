//
//  ViewController.swift
//  InstagramLoginDemo
//
//  Created by webwerks on 27/06/19.
//  Copyright © 2019 webwerks. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    // MARK: IBOutlet Properties
    
    @IBOutlet weak var webView: WKWebView!
    
    // MARK: ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        loadWebView()
    }

    // MARK: Custom Functions
    
    func loadWebView() {
        let authURL = String(format: "%@?client_id=%@&redirect_uri=%@&response_type=token&scope=%@&DEBUG=True", arguments: [API.INSTAGRAM_AUTHURL,API.INSTAGRAM_CLIENT_ID,API.INSTAGRAM_REDIRECT_URI, API.INSTAGRAM_SCOPE])
        print(authURL)
        
        let urlRequest = URLRequest.init(url: URL.init(string: authURL)!)
        webView.load(urlRequest)
        
        webView.navigationDelegate = self
    }
    
    func checkRequestForCallbackURL(request: URLRequest) -> Bool {
        let requestURLString = (request.url?.absoluteString)! as String
        if requestURLString.hasPrefix(API.INSTAGRAM_REDIRECT_URI) {
            let range: Range<String.Index> = requestURLString.range(of: "#access_token=")!
            handleAuth(authToken: requestURLString.substring(from: range.upperBound))
            return false
        }
        return true
    }
    
    func handleAuth(authToken: String) {
        print("Instagram authentication token ==", authToken)
        getUserInfo1(accessToken: authToken) { (true) in
            print("success")
        }
    }
    
    func getUserInfo1( accessToken: String, completion: @escaping ((_ data: Bool) -> Void)){
        let url = String(format: "%@%@", arguments: [API.INSTAGRAM_USER_INFO, accessToken])
        var request = URLRequest(url: URL(string: url)!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            guard error == nil else {
                completion(false)
                //failure
                return
            }
            // make sure we got data
            guard let responseData = data else {
                completion(false)
                //Error: did not receive data
                return
            }
            do {
                guard let dataResponse = try JSONSerialization.jsonObject(with: responseData, options: [])
                    as? [String: AnyObject] else {
                        completion(false)
                        //Error: did not receive data
                        return
                }
                print(dataResponse)
                completion(true)
                // success (dataResponse) dataResponse: contains the Instagram data
            } catch let err {
                print(err)
                completion(false)
                //failure
            }
        })
        task.resume()
    }
}

extension ViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if let url = navigationAction.request as? URLRequest {
            print(url.debugDescription)
            self.checkRequestForCallbackURL(request: url)
        }
        decisionHandler(.allow)
    }
}


