//
//  MockURLProtocol.swift
//  NetworkApp
//
//  Created by Md Shabbir Alam on 28/02/26.
//

import Foundation

actor MockStore {
    
    private var testURLs: [URL: (data: Data?, response: URLResponse?, error: Error?)] = [:]
    
    func set(
        data: Data?,
        response: URLResponse?,
        error: Error? = nil,
        for url: URL
    ) {
        testURLs[url] = (data, response, error)
    }
    
    func get(for url: URL) -> (Data?, URLResponse?, Error?) {
        testURLs[url] ?? (nil, nil, nil)
    }
    
    func reset(for url: URL) {
        testURLs.removeValue(forKey: url)
    }
}

final class MockURLProtocol: URLProtocol {
    
    static let mockStore = MockStore()
    
    override class func canInit(with request: URLRequest) -> Bool {
        true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
    
    override func startLoading() {
        
        guard let url = request.url else {
            client?.urlProtocolDidFinishLoading(self)
            return
        }
        
        Task {
            let (data, response, error) = await Self.mockStore.get(for: url)
            
            if let error {
                client?.urlProtocol(self, didFailWithError: error)
                return
            }
            
            if let response {
                client?.urlProtocol(
                    self,
                    didReceive: response,
                    cacheStoragePolicy: .notAllowed
                )
            }
            
            if let data {
                client?.urlProtocol(self, didLoad: data)
            }
            
            client?.urlProtocolDidFinishLoading(self)
        }
    }
    
    override func stopLoading() {}
}
