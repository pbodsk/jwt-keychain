import Vapor
import Fluent
import Foundation
import Auth
import VaporJWT
import Core
import HTTP

extension User {
    
    /// Generates a token for the user
    ///
    /// - Returns: string with valid token
    /// - Throws: unable to generate token
    public func generateToken() throws -> String{
        
        // Prepare payload Node
        var payload: Node
        
        // Prepare contents for payload
        var contents: [Claim] = []
        
        // Create a claim with user ID
        guard let userId = self.id else {
            throw Abort.custom(status: .internalServerError, message: "Cannot generate tokens for unexisting users")
        }
        
        guard let subClaim = SubjectClaim(Node(["user_id": userId])) else {
            throw Abort.custom(status: .internalServerError, message: "Could not generate subject claim")
        }
        
        contents.append(subClaim)
        
        // Prepare expiration claim if needed
        if Configuration.secondsToExpire! > 0 {
            
            contents.append(ExpirationTimeClaim(try Configuration.generateExpirationDate()))
    
        }
        
        payload = Node(contents)
        
        // Generate our Token
        let jwt = try JWT(
            payload: payload,
            signer: HS256(key: Configuration.getTokenSignatureKey())
        )
        
        // Return the token string
        return try jwt.createToken()
        
    }

}
