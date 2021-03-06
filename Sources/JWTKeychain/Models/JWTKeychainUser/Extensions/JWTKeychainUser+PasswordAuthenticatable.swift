import Authentication

extension JWTKeychainUser: PasswordAuthenticatable {

    /// See 'BasicAuthenticatable'.
    public static let passwordKey: WritableKeyPath<JWTKeychainUser, String> = \.password

    /// See 'BasicAuthenticatable'.
    public static let usernameKey: WritableKeyPath<JWTKeychainUser, String> = \.email
}
