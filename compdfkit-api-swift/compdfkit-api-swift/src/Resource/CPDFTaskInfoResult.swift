//
//  CPDFTaskInfoResult.swift
//  compdfkit-api-swift
//

#if os(iOS)
import Foundation
#else
import Cocoa
#endif

public class CPDFTaskInfoResult: NSObject {
    public var taskId: String?
    public var taskFileNum: Int64?
    public var taskSuccessNum: Int64?
    public var taskFailNum: Int64?
    public var taskStatus: String?
    public var assetTypeId: Int64?
    public var taskCost: Int64?
    public var taskTime: Int64?
    public var sourceType: String?
    public var targetType: String?
    public var callbackUrl: String?
    public var taskLanguage: String?
    public var fileInfoDTOList: [CPDFFileInfo]?
    
    public var errorDesc: String?
    private var dict: [String : Any] = [:]
    
    convenience init(dict: [String : Any]) {
        self.init()
            
        self.dict = dict
        self.taskId = dict["taskId"] as? String
        self.taskFileNum = dict["taskFileNum"] as? Int64
        self.taskSuccessNum = dict["taskSuccessNum"] as? Int64
        self.taskFailNum = dict["taskFailNum"] as? Int64
        
        self.taskStatus = dict["taskStatus"] as? String
        
        self.assetTypeId = dict["assetTypeId"] as? Int64
        self.taskCost = dict["taskCost"] as? Int64
        self.taskTime = dict["taskTime"] as? Int64
        self.sourceType = dict["sourceType"] as? String
        self.targetType = dict["targetType"] as? String
        self.callbackUrl = dict["callbackUrl"] as? String
        self.taskLanguage = dict["taskLanguage"] as? String
        
        self.fileInfoDTOList = []
        if let data = dict["fileInfoDTOList"] as? [[String:Any]] {
            for fileInfo in data {
                self.fileInfoDTOList?.append(CPDFFileInfo(dict: fileInfo))
            }
        }
    }
    
    public func isFinish() -> Bool {
        guard let status = self.taskStatus else {
            return false
        }
        return status == "TaskFinish"
    }
    
    public func isRuning() -> Bool {
        guard let status = self.taskStatus else {
            return false
        }
        return status == "TaskProcessing" || status == "TaskWaiting"
    }
    
    public func printInfo() {
        Swift.debugPrint(self.dict)
        
        if let file = self.fileInfoDTOList?.first {
            if let downloadUrl = file.downloadUrl, !downloadUrl.isEmpty {
                Swift.debugPrint("downloadUrl: "+downloadUrl)
            }
            if let failureReason = file.failureReason, !failureReason.isEmpty {
                Swift.debugPrint("failureReason: "+failureReason)
            }
        }
    }
}
