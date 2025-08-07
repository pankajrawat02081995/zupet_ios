//
//  GoogleSignInManager.swift
//  Zupet
//
//  Created by Pankaj Rawat on 07/08/25.
//

import Foundation
import GoogleSignIn
import UIKit

final class GoogleSignInManager {
    static let shared = GoogleSignInManager()

    private init() {}

    struct GoogleUser {
        let id: String
        let name: String
        let email: String
        let profileImageURL: URL?
        let idToken: String
    }

    func signIn(from viewController: UIViewController) async throws -> GoogleUser {
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: viewController)

        let user = result.user
        guard let idToken = user.idToken?.tokenString else {
            throw NSError(
                domain: "GoogleSignInError",
                code: -2,
                userInfo: [NSLocalizedDescriptionKey: "Missing ID token"]
            )
        }

        let profile = user.profile

        return GoogleUser(
            id: user.userID ?? "",
            name: profile?.name ?? "",
            email: profile?.email ?? "",
            profileImageURL: profile?.imageURL(withDimension: 100),
            idToken: idToken
        )
    }

    func signOut() {
        GIDSignIn.sharedInstance.signOut()
    }
}
