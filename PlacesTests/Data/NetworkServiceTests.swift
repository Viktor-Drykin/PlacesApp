//
//  NetworkServiceTests.swift
//  PlacesTests
//

import Foundation
import Testing
@testable import Places

@Suite(.serialized)
struct NetworkServiceTests {
    @Test func successfulStatusCodeReturnsData() async throws {
        let expectedData = Data("hello".utf8)
        URLProtocolStub.stub(data: expectedData, statusCode: 200)

        let data = try await makeSUT().fetchData(from: URL(string: "https://example.com")!)

        #expect(data == expectedData)
    }

    @Test func upperBoundOf2xxIsTreatedAsSuccess() async throws {
        let expectedData = Data("ok".utf8)
        URLProtocolStub.stub(data: expectedData, statusCode: 299)

        let data = try await makeSUT().fetchData(from: URL(string: "https://example.com")!)

        #expect(data == expectedData)
    }

    @Test func clientErrorStatusCodeThrowsInvalidResponse() async {
        URLProtocolStub.stub(data: Data(), statusCode: 404)

        await #expect(throws: NetworkServiceError.invalidResponse) {
            _ = try await makeSUT().fetchData(from: URL(string: "https://example.com")!)
        }
    }

    @Test func serverErrorStatusCodeThrowsInvalidResponse() async {
        URLProtocolStub.stub(data: Data(), statusCode: 500)

        await #expect(throws: NetworkServiceError.invalidResponse) {
            _ = try await makeSUT().fetchData(from: URL(string: "https://example.com")!)
        }
    }

    @Test func transportFailurePropagatesTheUnderlyingError() async {
        URLProtocolStub.stub(error: URLError(.notConnectedToInternet))

        await #expect(throws: URLError.self) {
            _ = try await makeSUT().fetchData(from: URL(string: "https://example.com")!)
        }
    }

    private func makeSUT() -> NetworkService {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        return NetworkService(urlSession: URLSession(configuration: configuration))
    }
}

/// Intercepts requests made through a `URLSession` configured with it,
/// so `NetworkService` can be tested against canned responses without
/// touching the network. Stub state is static (`URLProtocol` instances are
/// created internally by `URLSession`), so the suite runs `.serialized`.
private final class URLProtocolStub: URLProtocol {
    private static var stubbedData = Data()
    private static var stubbedStatusCode = 200
    private static var stubbedError: Error?

    static func stub(data: Data, statusCode: Int) {
        stubbedData = data
        stubbedStatusCode = statusCode
        stubbedError = nil
    }

    static func stub(error: Error) {
        stubbedError = error
    }

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        if let error = Self.stubbedError {
            client?.urlProtocol(self, didFailWithError: error)
            return
        }

        let response = HTTPURLResponse(url: request.url!, statusCode: Self.stubbedStatusCode, httpVersion: nil, headerFields: nil)!
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: Self.stubbedData)
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}
