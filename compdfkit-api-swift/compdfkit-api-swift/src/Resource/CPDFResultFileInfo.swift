//
//  CPDFResultFileInfo.swift
//  compdfkit-api-swift
//

#if os(iOS)
import Foundation
#else
import Cocoa
#endif

public class CPDFFileInfo: NSObject {
    public var fileKey: String?
    public var taskId: String?
    public var fileName: String?
    public var fileUrl: String?
    public var downloadUrl: String?
    public var sourceType: String?
    public var targetType: String?
    public var fileSize: String?
    public var convertSize: String?
    public var convertTime: String?
    public var status: String?
    public var failureCode: String?
    public var failureReason: String?
    public var downFileName: String?
    public var fileParameter: String?
    
    public var errorDesc: String?
    private var dict: [String : Any]?
    
    convenience init(dict: [String : Any]) {
        self.init()
        
        self.dict = dict
        self.fileUrl        = dict["fileUrl"] as? String
        self.taskId         = dict["taskId"] as? String
        self.fileName       = dict["fileName"] as? String
        self.fileKey        = dict["fileKey"] as? String
        self.downloadUrl    = dict["downloadUrl"] as? String
        self.sourceType     = dict["sourceType"] as? String
        self.targetType     = dict["targetType"] as? String
        self.fileSize       = dict["fileSize"] as? String
        self.convertSize    = dict["convertSize"] as? String
        self.convertTime    = dict["convertTime"] as? String
        self.status         = dict["status"] as? String
        self.failureCode    = dict["failureCode"] as? String
        self.failureReason  = dict["failureReason"] as? String
        self.downFileName   = dict["downFileName"] as? String
        self.fileParameter  = dict["fileParameter"] as? String
    }
    
    public func printInfo() {
        Swift.debugPrint(self.dict ?? [:])
    }
}
