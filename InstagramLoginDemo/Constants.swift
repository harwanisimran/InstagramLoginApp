//
//  Constants.swift
//  InstagramLoginDemo
//
//  Created by webwerks on 27/06/19.
//  Copyright © 2019 webwerks. All rights reserved.
//

import Foundation

struct API {
    
    static let INSTAGRAM_AUTHURL = "https://api.instagram.com/oauth/authorize/"
    static let INSTAGRAM_CLIENT_ID = "2f463b82cddf4095873ad9d515aab2e8"
    static let INSTAGRAM_CLIENTSERCRET = " c2099d0114e641f7bfb8e88b5a1790a6"
    static let INSTAGRAM_REDIRECT_URI = "https://www.google.com"
    static let INSTAGRAM_ACCESS_TOKEN = "access_token"
    static let INSTAGRAM_USER_INFO = "https://api.instagram.com/v1/users/self/?access_token="
    static let INSTAGRAM_SCOPE = "public_content" /* add whatever scope you need https://www.instagram.com/developer/authorization/ */
}
