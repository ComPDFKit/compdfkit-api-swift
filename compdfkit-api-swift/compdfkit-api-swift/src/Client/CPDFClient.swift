//
//  CPDFClient.swift
//  compdfkit-api-swift
//

#if os(iOS)
import Foundation
#else
import Cocoa
#endif

public enum CPDFFileUploadParameterKey: String {
    case pageOptions         = "pageOptions"
    case rotation            = "rotation"
    case targetPage          = "targetPage"
    case width               = "width"
    case height              = "height"
    case number              = "number"
    
    case isContainAnnot      = "isContainAnnot"
    case isContainImg        = "isContainImg"
    case isFlowLayout        = "isFlowLayout"
    
    case contentOptions      = "contentOptions"
    case worksheetOptions    = "worksheetOptions"
    
    case isCsvMerge          = "isCsvMerge"
    
    case imgDpi              = "imgDpi"
    
    case lang                = "lang"
    
    case type                = "type"
    case scale               = "scale"
    case opacity             = "opacity"
    case targetPages         = "targetPages"
    case vertalign           = "vertalign"
    case horizalign          = "horizalign"
    case xoffset             = "xoffset"
    case yoffset             = "yoffset"
    case content             = "content"
    case textColor           = "textColor"
    case front               = "front"
    case fullScreen          = "fullScreen"
    case horizontalSpace     = "horizontalSpace"
    case verticalSpace       = "verticalSpace"
    case cpdfExtension       = "extension"
    
    case quality             = "quality"
    case filepath            = "filepath"
    
    public func string() -> String {
        return self.rawValue
    }
}

public enum CPDFClientLanguage: String {
    case english        = "1"
    case chinese        = "2"
}

extension CPDFClient.Parameter {
    static let publicKey        = "publicKey"
    static let secretKey        = "secretKey"
    
    static let taskId           = "taskId"
    static let password         = "password"
    static let parameter        = "parameter"
    static let file             = "file"
    
    static let language         = "language"
    static let fileKey          = "fileKey"
    
    static let filepath         = "filepath"
}

extension CPDFClient.Data {
    static let accessToken      = "accessToken"
    static let expiresIn        = "expiresIn"

    static let taskId           = "taskId"

    static let fileKey          = "fileKey"
    static let fileUrl          = "fileUrl"

    static let taskStatus       = "taskStatus"
    static let fileInfoDTOList  = "fileInfoDTOList"
}

public class CPDFClient: NSObject {
    private var _publicKey: String?
    var publicKey: String? {
        get {
            return self._publicKey
        }
    }
    private var _secretKey: String?
    var secretKey: String? {
        get {
            return self._secretKey
        }
    }
    
    private var accessToken: String?
    private var expireTime: TimeInterval?
    
    struct Parameter {

    }
    
    struct Data {
        
    }
    
    public convenience init(publicKey: String, secretKey: String) {
        self.init()
        
        self._publicKey = publicKey
        self._secretKey = secretKey
    }
    
    public func createTask(url: String, language: CPDFClientLanguage = .chinese, callback:@escaping (CPDFCreateTaskResult?)->Void) {
        if (!self.accessTokenIsValid()) {
            self.auth { [weak self] model in
                guard let _ = model else {
                    let _model = CPDFCreateTaskResult(dict: [:])
                    _model.errorDesc = "auth failure"
                    callback(_model)
                    return
                }
                
                self?.createTask(url: url, language: language, callback: callback)
            }
            return
        }
        
        var parameter: [String : String] = [:]
        parameter[CPDFClient.Parameter.language] = language.rawValue

        CPDFHttpClient.GET(urlString: CPDFURL.API_V1_CREATE_TASK+url, parameter: parameter, headers: self.getRequestHeaderInfo()) { result, dataDict, error in
            guard let _dataDict = dataDict else {
                let model = CPDFCreateTaskResult(dict: [:])
                model.errorDesc = error
                callback(model)
                return
            }
            let model = CPDFCreateTaskResult(dict: _dataDict)
            callback(model)
        }
    }
    
    @available(macOS 10.15.0, iOS 13.0, *)
    public func createTask(url: String, language: CPDFClientLanguage = .chinese) async -> CPDFCreateTaskResult? {
        return await withCheckedContinuation({ continuation in
            self.createTask(url: url, language: language) { model in
                continuation.resume(returning: model)
            }
        })
    }
    
    public func auth(callback:@escaping ((CPDFOauthResult?)->Void)) {
        let options = [CPDFClient.Parameter.publicKey : self.publicKey ?? "", CPDFClient.Parameter.secretKey: self.secretKey ?? ""]
        CPDFHttpClient.POST(urlString: CPDFURL.API_V1_OAUTH_TOKEN, parameter: options) { [weak self] result, dataDict, error in
            if let _dataDict = dataDict {
                let model = CPDFOauthResult(dict: _dataDict)
                self?.accessToken = model.accessToken
                if let expiresIn = model.expiresIn, let data = Float(expiresIn) {
                    self?.expireTime = Date().timeIntervalSince1970*1000+Double(data*1000)
                }
                callback(model)
            } else {
                self?.accessToken = nil
                self?.expireTime = nil
                callback(nil)
            }
        }
    }
    
    @available(macOS 10.15.0, iOS 13.0, *)
    public func auth() async -> CPDFOauthResult? {
        return await withCheckedContinuation({ continuation in
            self.auth { model in
                continuation.resume(returning: model)
            }
        })
    }
    
    public func uploadFile(filepath: String, password: String? = nil, language: CPDFClientLanguage = .chinese, params:[String : Any], taskId: String, callback:@escaping ((CPDFUploadFileResult?)->Void)) {
        if (!self.accessTokenIsValid()) {
            self.auth { [weak self] model in
                guard let _ = model else {
                    let _model = CPDFUploadFileResult()
                    _model.errorDesc = "auth failure"
                    callback(_model)
                    return
                }
                
                self?.uploadFile(filepath: filepath, language: language, params: params, taskId: taskId, callback: callback)
            }
            return
        }
        
        var parameter: [String : Any] = [:]
        parameter[CPDFClient.Parameter.taskId] = taskId
        parameter[CPDFClient.Parameter.language] = language.rawValue
        if let data = password {
            parameter[CPDFClient.Parameter.password] = data
        }
        
        if let type = params[CPDFFileUploadParameterKey.type.string()] as? String, type == "image" {
            parameter[CPDFClient.Parameter.filepath] = params[CPDFFileUploadParameterKey.filepath.string()]
        }
        
        if let data = try?JSONSerialization.data(withJSONObject: params, options: .fragmentsAllowed) {
            let jsonString = String(data: data, encoding: .utf8)
            parameter[CPDFClient.Parameter.parameter] = jsonString
        }
        
        CPDFHttpClient.UploadFile(urlString: CPDFURL.API_V1_UPLOAD_FILE, parameter: parameter, headers: self.getRequestHeaderInfo(), filepath: filepath) { result, dataDict, error in
            guard let _dataDict = dataDict else {
                let model = CPDFUploadFileResult(dict: [:])
                model.errorDesc = error
                callback(model)
                return
            }
            let model = CPDFUploadFileResult(dict: _dataDict)
            callback(model)
        }
    }
    
    @available(macOS 10.15.0, iOS 13.0, *)
    public func uploadFile(filepath: String, password: String? = nil, language: CPDFClientLanguage = .chinese, params:[String : Any], taskId: String) async ->CPDFUploadFileResult? {
        return await withCheckedContinuation({ continuation in
            self.uploadFile(filepath: filepath, password: password, language: language, params: params, taskId: taskId) { model in
                continuation.resume(returning: model)
            }
        })
    }
    
    public func resumeTask(taskId: String, language: CPDFClientLanguage = .chinese, callback:@escaping ((CPDFTaskInfoResult?)->Void)) {
        if (!self.accessTokenIsValid()) {
            self.auth { [weak self] model in
                guard let _ = model else {
                    let _model = CPDFTaskInfoResult()
                    _model.errorDesc = "auth failure"
                    callback(_model)
                    return
                }
                self?.resumeTask(taskId: taskId, language: language, callback: callback)
            }
            return
        }
        
        self.processFiles(taskId: taskId, language: language) { [weak self] model in
            guard let _ = model?.taskId else {
                let _model = CPDFTaskInfoResult()
                _model.errorDesc = "Process Files failure"
                callback(_model)
                return
            }
            self?.getTaskInfo(taskId: taskId, language: language, callback: callback)
        }
    }
    
    public func processFiles(taskId: String, language: CPDFClientLanguage = .chinese, callback:@escaping ((CPDFCreateTaskResult?)->Void)) {
        if (!self.accessTokenIsValid()) {
            self.auth { [weak self] model in
                guard let _ = model else {
                    let _model = CPDFCreateTaskResult(dict: [:])
                    _model.errorDesc = "auth failure"
                    callback(_model)
                    return
                }
                self?.processFiles(taskId: taskId, language: language, callback: callback)
            }
            return
        }
        
        var parameter: [String : String] = [:]
        parameter[CPDFClient.Parameter.taskId] = taskId
        parameter[CPDFClient.Parameter.language] = language.rawValue
        CPDFHttpClient.GET(urlString: CPDFURL.API_V1_EXECUTE_TASK, parameter: parameter, headers: self.getRequestHeaderInfo()) { result, dataDict , error in
            guard let _dataDict = dataDict else {
                let model = CPDFCreateTaskResult(dict: [:])
                model.errorDesc = error
                callback(model)
                return
            }
            let model = CPDFCreateTaskResult(dict: _dataDict)
            callback(model)
        }
    }
    
    @available(macOS 10.15.0, iOS 13.0, *)
    public func processFiles(taskId: String, language: CPDFClientLanguage = .chinese) async -> CPDFCreateTaskResult? {
        return await withCheckedContinuation({ continuation in
            self.processFiles(taskId: taskId, language: language) { model in
                continuation.resume(returning: model)
            }
        })
    }
    
    public func getTaskInfoComplete(taskId: String, language: CPDFClientLanguage = .chinese, callback:@escaping ((_ isFinish: Bool, _ params: Any...)->Void)) {
        if (!self.accessTokenIsValid()) {
            self.auth { [weak self] accessToken in
                guard let _ = accessToken else {
                    callback(false, "auth failure")
                    return
                }
                self?.getTaskInfoComplete(taskId: taskId, language: language, callback: callback)
            }
            return
        }
        
        var parameter: [String : String] = [:]
        parameter[CPDFClient.Parameter.taskId] = taskId
        parameter[CPDFClient.Parameter.language] = language.rawValue
        CPDFHttpClient.GET(urlString: CPDFURL.API_V1_TASK_INFO, parameter: parameter, headers: self.getRequestHeaderInfo()) { result, dataDict , error in
            if let data = dataDict?[CPDFClient.Data.taskStatus] as? String, (data.elementsEqual("TaskProcessing") || data.elementsEqual("TaskWaiting")) {
                sleep(5)
                self.getTaskInfoComplete(taskId: taskId, language: language, callback: callback)
                return
            }
            var isFinish = false
            if let data = dataDict?[CPDFClient.Data.taskStatus] as? String, data.elementsEqual("TaskFinish") {
                isFinish = true
            }
            callback(isFinish, dataDict?[CPDFClient.Data.fileInfoDTOList] as Any)
        }
    }
    
    public func getTaskInfo(taskId: String, language: CPDFClientLanguage = .chinese, callback:@escaping ((CPDFTaskInfoResult?)->Void)) {
        if (!self.accessTokenIsValid()) {
            self.auth { [weak self] model in
                guard let _ = model else {
                    let _model = CPDFTaskInfoResult()
                    _model.errorDesc = "auth failure"
                    callback(_model)
                    return
                }
                self?.getTaskInfo(taskId: taskId, language: language, callback: callback)
            }
            return
        }
        
        var parameter: [String : String] = [:]
        parameter[CPDFClient.Parameter.taskId] = taskId
        parameter[CPDFClient.Parameter.language] = language.rawValue
        CPDFHttpClient.GET(urlString: CPDFURL.API_V1_TASK_INFO, parameter: parameter, headers: self.getRequestHeaderInfo()) { result, dataDict , error in
            guard let _dataDict = dataDict else {
                let model = CPDFTaskInfoResult(dict: [:])
                model.errorDesc = error
                callback(model)
                return
            }
            let model = CPDFTaskInfoResult(dict: _dataDict)
            callback(model)
        }
    }
    
    @available(macOS 10.15.0, iOS 13.0, *)
    public func getTaskInfo(taskId: String, language: CPDFClientLanguage = .chinese) async -> CPDFTaskInfoResult? {
        return await withCheckedContinuation({ continuation in
            self.getTaskInfo(taskId: taskId, language: language) { model in
                continuation.resume(returning: model)
            }
        })
    }
    
    private func accessTokenIsValid() -> Bool {
        guard let _ = self.accessToken else {
            return false
        }
        guard let _expireTime = self.expireTime else {
            return false
        }
        return _expireTime >= Date().timeIntervalSince1970 * 1000
    }
    
    private func getRequestHeaderInfo() -> [String : String] {
        var headers: [String : String] = [:]
        if let data = self.accessToken {
            headers["Authorization"] = "Bearer \(data)"
        }
        return headers
    }
}

extension CPDFClient {
    public func getSupportTools(callback:@escaping (([Any]?)->Void)) {
        CPDFHttpClient.GET(urlString: CPDFURL.API_V1_TOOL_SUPPORT, headers: self.getRequestHeaderInfo()) { reslut , dataDict, error in
            var array: [Any] = []
            if let _dataDict = dataDict {
                for dict in _dataDict {
                    array.append(dict)
                }
            }
            callback(array)
        }
    }
    
    @available(macOS 10.15.0, iOS 13.0, *)
    public func getSupportTools() async -> [Any]? {
        return await withCheckedContinuation({ continuation in
            self.getSupportTools(callback: { datas in
                continuation.resume(returning: datas)
            })
        })
    }
    
    public func getFileInfoByKey(fileKey: String, language: CPDFClientLanguage = .chinese, callback:@escaping ((CPDFFileInfo?)->Void)) {
        if (!self.accessTokenIsValid()) {
            self.auth { [weak self] model in
                guard let _ = model else {
                    let _model = CPDFFileInfo()
                    _model.errorDesc = "auth failure"
                    callback(_model)
                    return
                }
                self?.getFileInfoByKey(fileKey: fileKey, language: language, callback: callback)
            }
            return
        }
        
        CPDFHttpClient.GET(urlString: CPDFURL.API_V1_FILE_INFO, parameter: [CPDFClient.Parameter.fileKey : fileKey, CPDFClient.Parameter.language : language.rawValue], headers: self.getRequestHeaderInfo()) { result, dataDict, error in
            guard let _dataDict = dataDict else {
                let model = CPDFFileInfo(dict: [:])
                model.errorDesc = error
                callback(model)
                return
            }
            let model = CPDFFileInfo(dict: _dataDict)
            callback(model)
        }
    }
    
    @available(macOS 10.15.0, iOS 13.0, *)
    public func getFileInfoByKey(fileKey: String, language: CPDFClientLanguage = .chinese) async -> CPDFFileInfo? {
        return await withCheckedContinuation({ continuation in
            self.getFileInfoByKey(fileKey: fileKey, language: language) { model in
                continuation.resume(returning: model)
            }
        })
    }
    
    public func getAssetInfo(callback:@escaping (([Any]?)->Void)) {
        if (!self.accessTokenIsValid()) {
            self.auth { [weak self] model in
                guard let _ = model else {
                    callback(nil)
                    return
                }
                self?.getAssetInfo(callback: callback)
            }
            return
        }
        CPDFHttpClient.GET(urlString: CPDFURL.API_V1_ASSET_INFO, headers: self.getRequestHeaderInfo()) { reslut , dataDict, error in
            var array: [Any] = []
            if let _dataDict = dataDict {
                for dict in _dataDict {
                    array.append(dict)
                }
            }
            callback(array)
        }
    }
    
    @available(macOS 10.15.0, iOS 13.0, *)
    public func getAssetInfo() async -> [Any]? {
        return await withCheckedContinuation({ continuation in
            self.getAssetInfo(callback: { datas in
                continuation.resume(returning: datas)
            })
        })
    }
    
    public func getTaskList(page: Int64, size: Int64, callback:@escaping (([Any]?)->Void)) {
        if (!self.accessTokenIsValid()) {
            self.auth { [weak self] model in
                guard let _ = model else {
                    callback(nil)
                    return
                }
                self?.getTaskList(page: page, size: size,callback: callback)
            }
            return
        }
        CPDFHttpClient.GET(urlString: CPDFURL.API_V1_TASK_LIST, headers: self.getRequestHeaderInfo()) { reslut , dataDict, error in
            callback(dataDict?["records"] as? [Any])
        }
    }
    
    @available(macOS 10.15.0, iOS 13.0, *)
    public func getTaskList(page: Int64 = 1, size: Int64 = 10) async -> [Any]? {
        return await withCheckedContinuation({ continuation in
            self.getTaskList(page: page, size: size, callback: { datas in
                continuation.resume(returning: datas)
            })
        })
    }
    
}
