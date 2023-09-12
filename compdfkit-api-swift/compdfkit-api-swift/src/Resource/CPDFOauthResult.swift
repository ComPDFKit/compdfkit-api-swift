//
//  CPDFOauthResult.swift
//  compdfkit-api-swift
//

#if os(iOS)
import Foundation
#else
import Cocoa
#endif

public class CPDFOauthResult: NSObject {
    public var tokenType: String?
    public var expiresIn: String?
    public var accessToken: String?
    public var projectName: String?
    public var scope: String?
    
    convenience init(dict: [String : Any]) {
        self.init()
        
        self.tokenType = dict["tokenType"] as? String
        self.expiresIn = dict["expiresIn"] as? String
        self.accessToken = dict["accessToken"] as? String
        self.projectName = dict["projectName"] as? String
        self.scope = dict["scope"] as? String
    }
}
