## ComPDFKit API in Swift

[ComPDFKit](https://api.compdf.com/api/docs/introduction) API provides a variety of Swift API tools that allow you to create an efficient document processing workflow in a single API call. Try our various APIs for free — no credit card is required.



## Requirements

Programming Environment: macOS 10.13 and higher, and iOS 10 and higher.

Dependencies: Xcode13 and higher.



## Installation

Add the following dependency to your ***"Podfile"***:

```
pod 'compdfkit-api-swift'
```



## Create API Client

You can use your **publicKey** and **secretKey** to complete the authentication. You need to [sign in](https://api.compdf.com/login) your ComPDFKit API account to get your **publicKey** and **secretKey** at the [dashboard](https://api-dashboard.compdf.com/api/keys). If you are new to ComPDFKit, click here to [sign up](https://api.compdf.com/signup) for a free trial.

- Project public Key: You can find the public key in the **API Keys** section of your ComPDFKit API account.

- Project secret Key: You can find the secret key in the **API Keys** section of your ComPDFKit API account.

```Swift
// Create a client
let client: CPDFClient = CPDFClient(publicKey: public_key, secretKey: secret_key)
```



## Create Task

A task ID is automatically generated for you based on the type of PDF tool you choose. You can provide the callback notification URL. After the task processing is completed, we will notify you of the task result through the callback interface. You can perform other operations according to the request result, such as checking the status of the task, uploading files, starting the task, or downloading the result file. There are two ways to create a task in Swift below.

Async Block:

```Swift
// Create a client
let client: CPDFClient = CPDFClient(publicKey: public_key, secretKey: secret_key)

// Create a task
client.createTask(url: CPDFConversion.PDF_TO_WORD, language: .english) { taskModel in
    guard let taskId = taskModel?.taskId else {
        Swift.debugPrint(taskModel?.errorDesc ?? "")
        return
    }
}
```

Async Await:

When creating a task with the method async await, the programming environment should be macOS 10.15 and higher, and iOS 13 and higher.

```Swift
// Create a client
let client: CPDFClient = CPDFClient(publicKey: public_key, secretKey: secret_key)

Task { @MainActor in
    // Create a task
    let taskModel = await client.createTask(url: CPDFConversion.PDF_TO_WORD, language: .english)
    let taskId = taskModel?.taskId ?? ""
}
```



## Upload Files

Upload the original file and bind the file to the task ID. The field parameter is used to pass the JSON string to set the processing parameters for the file. Each file will generate automatically a unique file key. Please note that a maximum of five files can be uploaded for a task ID and no files can be uploaded for that task after it has started. There are two ways to upload files in Swift below.

Async Block:

```Swift
// Create a client
let client: CPDFClient = CPDFClient(publicKey: public_key, secretKey: secret_key)

// Create a task
client.createTask(url: CPDFConversion.PDF_TO_WORD, language: .english) { taskModel in
    guard let taskId = taskModel?.taskId else {
        Swift.debugPrint(taskModel?.errorDesc ?? "")
        return
    }
            
    // Upload file
    let group = DispatchGroup()
    group.enter()
    let path = Bundle.main.path(forResource: "test", ofType: "pdf")
    client.uploadFile(filepath: path!, password: "", language: .english, params: [
        CPDFFileUploadParameterKey.isContainAnnot.string() : "1",
        CPDFFileUploadParameterKey.isContainImg.string() : "1",
        CPDFFileUploadParameterKey.isFlowLayout.string() : "1"
    ], taskId: taskId) { uploadFileModel in
        if let errorInfo = uploadFileModel?.errorDesc {
            Swift.debugPrint(errorInfo)
        }
        group.leave()
    }
}
```

Async Await:

When uploading files with the method async await, the programming environment should be macOS 10.15 and higher, and iOS 13 and higher.

```Swift
// Create a client
let client: CPDFClient = CPDFClient(publicKey: public_key, secretKey: secret_key)

Task { @MainActor in
    // Create a task
    let taskModel = await client.createTask(url: CPDFConversion.PDF_TO_WORD, language: .english)
    let taskId = taskModel?.taskId ?? ""

    // Upload file
    let path = Bundle.main.path(forResource: "test", ofType: "pdf")
    let uploadFileModel = await client.uploadFile(filepath: path ?? "", password: "", language: .english, params: [
        CPDFFileUploadParameterKey.isContainAnnot.string() : "1",
        CPDFFileUploadParameterKey.isContainImg.string() : "1",
        CPDFFileUploadParameterKey.isFlowLayout.string() : "1"
    ], taskId: taskId)
}
```



## Execute the task 

After completing the file upload, call this interface with the task ID to process the files. There are two ways to execute the task in Swift below.

Async Block:

```Swift
// Create a client
let client: CPDFClient = CPDFClient(publicKey: public_key, secretKey: secret_key)

// Create a task
client.createTask(url: CPDFConversion.PDF_TO_WORD, language: .english) { taskModel in
    guard let taskId = taskModel?.taskId else {
        Swift.debugPrint(taskModel?.errorDesc ?? "")
        return
    }
            
    // Upload file
    let group = DispatchGroup()
    group.enter()
    let path = Bundle.main.path(forResource: "test", ofType: "pdf")
    client.uploadFile(filepath: path!, password: "", language: .english, params: [
        CPDFFileUploadParameterKey.isContainAnnot.string() : "1",
        CPDFFileUploadParameterKey.isContainImg.string() : "1",
        CPDFFileUploadParameterKey.isFlowLayout.string() : "1"
    ], taskId: taskId) { uploadFileModel in
        if let errorInfo = uploadFileModel?.errorDesc {
            Swift.debugPrint(errorInfo)
        }
        group.leave()
    }
            
    group.notify(queue: .main) {
        // Execute task
        client.processFiles(taskId: taskId, language: .english) { processFileModel in
            if let errorInfo = processFileModel?.errorDesc {
                Swift.debugPrint(errorInfo)
            }
        }
    }
}
```

Async Await:

When executing the task with the method async await, the programming environment should be macOS 10.15 and higher, and iOS 13 and higher.

```Swift
// Create a client
let client: CPDFClient = CPDFClient(publicKey: public_key, secretKey: secret_key)

Task { @MainActor in
    // Create a task
    let taskModel = await client.createTask(url: CPDFConversion.PDF_TO_WORD, language: .english)
    let taskId = taskModel?.taskId ?? ""

    // Upload file
    let path = Bundle.main.path(forResource: "test", ofType: "pdf")
    let uploadFileModel = await client.uploadFile(filepath: path ?? "", password: "", language: .english, params: [
        CPDFFileUploadParameterKey.isContainAnnot.string() : "1",
        CPDFFileUploadParameterKey.isContainImg.string() : "1",
        CPDFFileUploadParameterKey.isFlowLayout.string() : "1"
    ], taskId: taskId)
    
    // Execute task
    let _ = await client.processFiles(taskId: taskId, language: .english)
}
```



## Get Task Info

Request task status and file-related metadata based on the task ID. There are two ways to get the task information in Swift below.

Async Block:

```Swift
// Create a client
let client: CPDFClient = CPDFClient(publicKey: public_key, secretKey: secret_key)

// Create a task
client.createTask(url: CPDFConversion.PDF_TO_WORD, language: .english) { taskModel in
    guard let taskId = taskModel?.taskId else {
        Swift.debugPrint(taskModel?.errorDesc ?? "")
        return
    }
            
    // Upload file
    let group = DispatchGroup()
    group.enter()
    let path = Bundle.main.path(forResource: "test", ofType: "pdf")
    client.uploadFile(filepath: path!, password: "", language: .english, params: [
        CPDFFileUploadParameterKey.isContainAnnot.string() : "1",
        CPDFFileUploadParameterKey.isContainImg.string() : "1",
        CPDFFileUploadParameterKey.isFlowLayout.string() : "1"
    ], taskId: taskId) { uploadFileModel in
        if let errorInfo = uploadFileModel?.errorDesc {
            Swift.debugPrint(errorInfo)
        }
        group.leave()
    }
            
    group.notify(queue: .main) {
        // Execute task
        client.processFiles(taskId: taskId, language: .english) { processFileModel in
            if let errorInfo = processFileModel?.errorDesc {
                Swift.debugPrint(errorInfo)
            }
            // Get task processing information
            client.getTaskInfo(taskId: taskId, language: .english) { taskInfoModel in
                guard let _model = taskInfoModel else {
                    Swift.debugPrint("error:....")
                    return
                }
                if (_model.isFinish()) {
                    _model.printInfo()
                } else if (_model.isRuning()) {
                    Swift.debugPrint("Task incomplete processing")
                } else {
                    Swift.debugPrint("error: \(_model.errorDesc ?? "")")
                }
            }
        }
    }
}
```

Async Await:

When getting the task information with the method Async Await, the programming environment should be macOS 10.15 and higher, and iOS 13 and higher.

```Swift
// Create a client
let client: CPDFClient = CPDFClient(publicKey: public_key, secretKey: secret_key)

Task { @MainActor in
    // Create a task
    let taskModel = await client.createTask(url: CPDFConversion.PDF_TO_WORD, language: .english)
    let taskId = taskModel?.taskId ?? ""

    // Upload file
    let path = Bundle.main.path(forResource: "test", ofType: "pdf")
    let uploadFileModel = await client.uploadFile(filepath: path ?? "", password: "", language: .english, params: [
        CPDFFileUploadParameterKey.isContainAnnot.string() : "1",
        CPDFFileUploadParameterKey.isContainImg.string() : "1",
        CPDFFileUploadParameterKey.isFlowLayout.string() : "1"
    ], taskId: taskId)
    
    // Execute task
    let _ = await client.processFiles(taskId: taskId, language: .english)
    // Get task processing information
    let taskInfoModel = await client.getTaskInfo(taskId: taskId, language: .english)
    guard let _model = taskInfoModel else {
        Swift.debugPrint("error:....")
        return
    }
    if (_model.isFinish()) {
        _model.printInfo()
    } else if (_model.isRuning()) {
        Swift.debugPrint("Task incomplete processing")
        client.getTaskInfoComplete(taskId: taskId) { isFinish, params in
            Swift.debugPrint(params)
        }
    } else {
        Swift.debugPrint("error: \(taskInfoModel?.errorDesc ?? "")")
    }
}
```



## Samples

See ***"Samples"*** folder in this folder.



## Resources

* [ComPDFKit API Libraries](https://api.compdf.com/api-libraries/overview)
* [ComPDFKit API Documentation](https://api.compdf.com/api/docs/introduction)


