//
//  FlickrSearchTests.swift
//  FlickrSearchTests
//
//  Created by Barnabás Kun on 2025. 08. 15..
//

import XCTest
import Combine
@testable import FlickrSearch

// MARK: - Main Test Class
final class FlickrSearchTests: XCTestCase {

    var cancellables: Set<AnyCancellable>!

    override func setUpWithError() throws {
        try super.setUpWithError()
        cancellables = []
        // Set up the mock URL protocol to intercept network requests
        URLProtocol.registerClass(MockURLProtocol.self)
    }

    override func tearDownWithError() throws {
        // Unregister the mock URL protocol
        URLProtocol.unregisterClass(MockURLProtocol.self)
        cancellables = nil
        try super.tearDownWithError()
    }

    
    // MARK: - FlickrModels Tests

    func testFlickrPhotoURLGeneration() {
        let photo = FlickrPhoto(id: "123", owner: "test", secret: "abc", server: "server1", farm: 1, title: "Test", ispublic: 1, isfriend: 0, isfamily: 0)
        
        XCTAssertEqual(photo.thumbnailURL, "https://farm1.staticflickr.com/server1/123_abc_m.jpg")
        XCTAssertEqual(photo.mediumURL, "https://farm1.staticflickr.com/server1/123_abc_c.jpg")
        XCTAssertEqual(photo.largeURL, "https://farm1.staticflickr.com/server1/123_abc_b.jpg")
    }
    
    func testFlickrPhotoDetailFormatting() {
        let detail = FlickrPhotoDetail(
            id: "123", secret: "abc", server: "s1", farm: 1,
            dateuploaded: "1660906800",
            isfavorite: 0, license: "4", safety_level: "0", rotation: 0,
            views: "12345", media: "photo",
            title: FlickrTitle(_content: "Title"),
            description: FlickrDescription(_content: "Desc"),
            visibility: FlickrVisibility(ispublic: 1, isfriend: 0, isfamily: 0),
            dates: FlickrDates(posted: "", taken: "2022-08-19 10:00:00", takengranularity: 0, takenunknown: "0", lastupdate: ""),
            owner: FlickrOwner(nsid: "owner", username: "user", realname: nil, location: nil, iconserver: "", iconfarm: 1, path_alias: nil),
            comments: FlickrComments(_content: "0")
        )
        
        XCTAssertEqual(detail.formattedViews, "12.3K")
        XCTAssertEqual(detail.licenseText, "Attribution")
    }
    

    // MARK: - DetailViewModel Tests

    @MainActor
    func testDetailViewModel_SuccessfulInfoLoad() async {
        let photo = FlickrPhoto(id: "53123456789", owner: "", secret: "", server: "", farm: 0, title: "", ispublic: 0, isfriend: 0, isfamily: 0)
        MockURLProtocol.error = nil
        MockURLProtocol.mockData = MockData.photoInfoResponse
        
        let viewModel = DetailViewModel(photo: photo)
        
        let expectation = XCTestExpectation(description: "Photo info loads successfully")
        
        viewModel.$photoInfo
            .dropFirst()
            .sink { photoInfo in
                XCTAssertNotNil(photoInfo)
                XCTAssertEqual(photoInfo?.photo.title._content, "Test Photo 1 Detail")
                expectation.fulfill()
            }
            .store(in: &cancellables)
            
        await fulfillment(of: [expectation], timeout: 2.0)
        
        XCTAssertFalse(viewModel.isLoadingInfo)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    @MainActor
    func testDetailViewModel_FailedInfoLoad() async {
        let photo = FlickrPhoto(id: "53123456789", owner: "", secret: "", server: "", farm: 0, title: "", ispublic: 0, isfriend: 0, isfamily: 0)
        MockURLProtocol.error = APIService.APIError.invalidResponse
        
        let viewModel = DetailViewModel(photo: photo)
        
        let expectation = XCTestExpectation(description: "Photo info loading fails")
        
        viewModel.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                XCTAssertNotNil(errorMessage)
                expectation.fulfill()
            }
            .store(in: &cancellables)
            
        await fulfillment(of: [expectation], timeout: 2.0)
        
        XCTAssertFalse(viewModel.isLoadingInfo)
        XCTAssertNil(viewModel.photoInfo)
    }
}


// MARK: - Mock Networking Layer

/// A mock URLProtocol to intercept network requests and return predefined data or errors.
class MockURLProtocol: URLProtocol {
    static var error: Error?
    static var mockData: Data?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        if let error = MockURLProtocol.error {
            self.client?.urlProtocol(self, didFailWithError: error)
        } else {
            let response = HTTPURLResponse(url: self.request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            self.client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            if let data = MockURLProtocol.mockData {
                self.client?.urlProtocol(self, didLoad: data)
            }
        }
        self.client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}

/// Contains mock data for API responses.
struct MockData {
    static let searchResponse = """
    {
        "photos": {
            "page": 1, "pages": 2, "perpage": 2, "total": 4,
            "photo": [
                { "id": "53123456789", "owner": "123@N01", "secret": "abc", "server": "65535", "farm": 66, "title": "Test Photo 1", "ispublic": 1, "isfriend": 0, "isfamily": 0 },
                { "id": "53123456790", "owner": "123@N01", "secret": "def", "server": "65535", "farm": 66, "title": "Test Photo 2", "ispublic": 1, "isfriend": 0, "isfamily": 0 }
            ]
        },
        "stat": "ok"
    }
    """.data(using: .utf8)!

    static let photoInfoResponse = """
    {
        "photo": {
            "id": "53123456789", "secret": "abc", "server": "65535", "farm": 66, "dateuploaded": "1692446400",
            "isfavorite": 0, "license": "4", "safety_level": "0", "rotation": 0, "views": "12345", "media": "photo",
            "title": { "_content": "Test Photo 1 Detail" },
            "description": { "_content": "This is a test description." },
            "visibility": { "ispublic": 1, "isfriend": 0, "isfamily": 0 },
            "dates": { "posted": "1692446400", "taken": "2023-08-19 12:00:00", "takengranularity": 0, "takenunknown": "0", "lastupdate": "1692446400" },
            "owner": { "nsid": "123@N01", "username": "testuser", "realname": "Test User", "location": "Test Location", "iconserver": "1234", "iconfarm": 1, "path_alias": "testuser" },
            "comments": { "_content": "0" }
        },
        "stat": "ok"
    }
    """.data(using: .utf8)!
}
