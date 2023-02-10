//
//  UploadImageViewModel.swift
//  DispatchGroup
//
//  Created by Inderjeet Singh on 09/02/23.
//

import UIKit

class UploadImageViewModel{
    static let shared = UploadImageViewModel()
    private let group = DispatchGroup()
    private init() { }
    
    func uplaodImage(images: [UIImage]) {
        var imageCount = 0
        if images.isEmpty {
            debugPrint("No Images")
        }else{
            debugPrint("Start hitting")
            for image in images {
                if let imageValue = image.jpegData(compressionQuality: 1.0){
                    let ImageSting = imageValue.base64EncodedString()
                    self.group.enter()
                    self.hitApi(param: ImageSting) {
                        self.group.leave()
                        imageCount += 1
                        debugPrint("Success")
                    } failuer: {
                        self.group.leave()
                        debugPrint("Failuer")
                    }
                }
            }
            
            self.group.notify(queue: .main) {
                debugPrint("Stop hitting")
                if imageCount == images.count{
                    debugPrint("Photos uploaded successfully...!!!")
                }
            }
        }
    }
    
    // MARK: - Hit Api
    func hitApi(param: String, complition: @escaping (() -> Void), failuer: @escaping (() -> Void)){
        var semaphore = DispatchSemaphore (value: 0)
        let parameters = "{\n    \"mimeType\": \"image/jpg\", \n    \"fileName\": \"filename.png\", \n    \"content\": \"\(param)\"\n}"
        let postData = parameters.data(using: .utf8)
        var request = URLRequest(url: URL(string: "https://dev-helix.devofferpad.com/customer/v3/cash-offer-transactions/39650604/upload-photo")!,timeoutInterval: Double.infinity)
        request.addValue("Bearer eyJhbGciOiJSUzI1NiIsImtpZCI6IlpjUzFQZmU5VGVfNl9JMWNTbUJ3LXFXUHNTdyIsInR5cCI6IkpXVCIsIng1dCI6IlpjUzFQZmU5VGVfNl9JMWNTbUJ3LXFXUHNTdyJ9.eyJuYmYiOjE2NzU4NzQ4MDUsImV4cCI6MTY3NTk2MTIwNSwiaXNzIjoiaHR0cHM6Ly9vcC1kZXYtaWQuZGV2b2ZmZXJwYWQuY29tIiwiYXVkIjpbImh0dHBzOi8vb3AtZGV2LWlkLmRldm9mZmVycGFkLmNvbS9yZXNvdXJjZXMiLCJJbmZyYXN0cnVjdHVyZURvY3VtZW50cyIsIkN1c3RvbWVyUHJvZmlsZSJdLCJjbGllbnRfaWQiOiJPUFR3aXJsIiwic3ViIjoiNGJlMWY5YjUtMWM4NC00MGY3LWEwMjEtYjgwY2M4NGQ1MTA0IiwiYXV0aF90aW1lIjoxNjc1ODU1MDUyLCJpZHAiOiJsb2NhbCIsIkN1c3RvbWVyIjoiVHJ1ZSIsIkVtYWlsIjoiSW5kZXJAeW9wbWFpbC5jb20iLCJFbWFpbENvbmZpcm1lZCI6IkZhbHNlIiwiZW1haWwiOiJJbmRlckB5b3BtYWlsLmNvbSIsImVtYWlsQ29uZmlybWVkIjoiRmFsc2UiLCJhZ2VudElkIjoiIiwicGhvbmVOdW1iZXIiOiI5ODc2NTQzMjEwIiwicGhvbmVOdW1iZXJDb25maXJtZWQiOiJGYWxzZSIsImRyaXZlcnNMaWNlbnNlQ29uZmlybWVkIjoiRmFsc2UiLCJmaXJzdE5hbWUiOiJJbmRlciIsImxhc3ROYW1lIjoiU2luZ2giLCJhZ2VudCI6IkZhbHNlIiwiYnJva2VyYWdlTmFtZSI6IiIsInNlbGxBY3RpdmUiOiJUcnVlIiwiYnV5QWN0aXZlIjoiVHJ1ZSIsInNjb3BlIjpbIm9wZW5pZCIsImVtYWlsIiwicHJvZmlsZSIsImluZnJhc3RydWN0dXJlLWRvY3VtZW50cyIsImN1c3RvbWVyLXByb2ZpbGUiLCJvZmZsaW5lX2FjY2VzcyJdLCJhbXIiOlsicHdkIl19.G5BKIAp9277ZrDKet8uOZUsfgkmdwubX9PRbAUKMtSGX00hubNQIHxJl3i2ixATPkbvgjM4gPdiFbv05mcZ1u7r3cD08ohML0yRJpKAo0nQhBcvpk7WYrYdXBvMJevNASTlJcBPDhOBoF6iW8-4ocVNq55FCd0jMYJxHmdJEIFw2F2Tz6_zP4YAsWvrR3njvc1icTki2c32Hnty4VPgvh2guezMpGaCdemCpMCMA57Aa6yaN9419e7x-GS755yeSOehjuQCe6ZjalPnjw_w73PvzpSe3rzzKIzM8UE2eOr6GDN7G3Fu46o07Uc6Ixf9A29tzJSsrO7COmBi5PrlAuw", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = postData
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                semaphore.signal()
                failuer()
                return
            }
            complition()
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
}
