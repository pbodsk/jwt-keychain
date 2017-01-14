import XCTest
@testable import Vapor
@testable import JWTKeychain
import HTTP

class JWTAuthMiddlewareTests: XCTestCase {

    private var middleware: JWTAuthMiddleware?
    private var configuration: ConfigurationType?

    static var allTests : [(String, (JWTAuthMiddlewareTests) -> () throws -> Void)] {
        return [
            ("testAbsenseOfAuthorizationHeaderThrows", testAbsenseOfAuthorizationHeaderThrows),
            ("testInvalidAuthorizationTokenThrows", testInvalidAuthorizationTokenThrows),
            ("testValidAuthorizationHeaderPasses", testValidAuthorizationHeaderPasses)
        ]
    }

    override func setUp() {
      
          self.configuration = Configuration(signer: "HS256", signatureKey: "key", publicKey: nil, secondsToExpire: 0)

          self.middleware = JWTAuthMiddleware(configuration: self.configuration!)

    }

    override func tearDown() {

    }


    // MARK: Authorization header required
    func testAbsenseOfAuthorizationHeaderThrows() {

        let next = ResponderMock()

        let req = try? Request(method: .get, uri: "api/v1/users/me")

        do {
            _ = try middleware!.respond(to: req!, chainingTo: next)
            XCTFail("No auth header should throw Abort.")
        } catch let error as Abort {

            XCTAssertEqual(error.status, Status.badRequest)

        } catch {

            XCTFail("Error thrown was not Abort")

        }
    }

    // MARK: Authorization header bearer invalid
    func testInvalidAuthorizationTokenThrows() {

        let next = ResponderMock()

        let req = try? Request(method: .get, uri: "api/v1/users/me")
        req?.headers["Authorization"] = "invalid token"

        do {
            _ = try middleware!.respond(to: req!, chainingTo: next)
            XCTFail("Inavlid auth header should throw Abort.")
        } catch let error as Abort {

            XCTAssertEqual(error.status, Status.unauthorized)

        } catch {

            XCTFail("Error thrown was not Abort")

        }

    }

    // MARK: Authorization header bearer invalid
    func testValidAuthorizationHeaderPasses() throws {

        let next = ResponderMock()

        let user = User(name: "test", email: "test", password: "test")
        user.id = Node(1)

        let req = try? Request(method: .get, uri: "api/v1/users/me")

        let token = try self.configuration!.generateToken(userId: user.id!)

        req?.headers["Authorization"] = "Bearer " + token

        do {
            _ = try middleware!.respond(to: req!, chainingTo: next)

        } catch {

            XCTFail("Valid token should not throw")

        }

    }

}
