import Vapor
import HTTP
import VaporForms

/// Handles the validation of storing a User
public class StoreRequest: Form {
    
    public let name: String
    public let email: String
    public let password: String
    
    public static let fieldset = Fieldset([
        "name": StringField(String.MinimumLengthValidator(characters: 2)),
        "email": StringField(String.EmailValidator(), UniqueFieldValidator<User>(column: "email", message: "Email already taken")),
        "password": StringField(String.MinimumLengthValidator(characters: 6), RegexValidator(regex: "^(?=.*[0-9])(?=.*[A-Z])(?=.*[a-z])", message: "Password not strong enough. Must contain a number, a capital letter and a small letter.")),
        ], requiring: ["name", "email", "password"])
    
    
    required public init(validatedData: [String: Node]) throws {
        // validatedData is guaranteed to contain correct field names and values.
        self.name = validatedData["name"]!.string!
        self.email = validatedData["email"]!.string!
        self.password = validatedData["password"]!.string!
    }
    
}