//
//  CPDFResultMap.swift
//  compdfkit-api-swift
//

#if os(iOS)
import Foundation
#else
import Cocoa
#endif

public class CPDFResultMap: NSObject {
    public var code: String?
    public var msg: String?
    public var data: Any?
    
    convenience init(dict: [String : Any]) {
        self.init()
        
        self.code = dict["code"] as? String
        self.msg = dict["msg"] as? String
        self.data = dict["data"]
    }
    
    public func isSuccess() -> Bool {
        guard let _code = self.code else {
            return false
        }
        return _code == "200"
    }
}
