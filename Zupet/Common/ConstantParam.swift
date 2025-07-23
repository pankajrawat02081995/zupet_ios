//
//  ConstantParam.swift
//  Broker Portal
//
//  Created by Pankaj on 23/04/25.
//

enum ErrorMessages: String {
    case invalidEmail = "Enter a valid email address."
    case invalidPassword = "Password must be at least 8 characters, include uppercase, lowercase, and a number."
    case requiredField = "This field is required"
    case passwordRequired = "Password cannot be empty."
    case emailRequired = "Email cannot be empty."
    case somethingWentWrong = "Something went wrong."
    case nouserfound = "No user found."
    case invalidURL = "Invalid view or URL."
}

enum ConstantParam:String, Codable{
    case UserID = "user_id"
    case Password = "password"
    case FirstName = "first_name"
    case MiddleName = "middle_name"
    case LastName = "last_name"
    case Address = "address"
    case State = "state"
    case City = "city"
    case Zipcode = "zipcode"
    case ContactOffice = "contact_number_office"
    case ContactMobile = "contact_number_mobile"
    case Email = "email"
    case PasswordUser = "pwd"
    case UserType = "user_type_id"
    case Id = "id"
}

struct ConstantApiParam{
    static let UserID = "user_id"
    static let Password = "password"
    static let AgencyID = "agency_id"
    static let Email = "email"
    static let State = "state"
    static let Business_Email = "Business Email"
}

struct ConstantPlaceholderValue{
    static let Select = "--Select--"
    static let Enter = "Enter..."
    static let Phone = "Eg: (212) 555 4567"
    static let Eg_Johne = "Eg: Johne"
    static let Eg_David = "Eg: David"
    static let Eg_Smith = "Eg: Smith"
    static let Eg_Address = "Eg: 3555 Pennsylvania Avenue"
    static let Eg_City = "Eg: Bluefield"
    static let Eg_Email = "abc@example.com"
    static let Eg_Passowrd = "********"
}

struct ConstantTitle{
    static let FirstName = "First Name"
    static let MiddleName = "Middle Name"
    static let LastName = "Last Name"
    static let Address = "Address"
    static let City = "City"
    static let State = "State"
    static let Zipcode = "Zip Code"
    static let ContactNumberOffice = "Contact Number Office"
    static let ContactNumberMobile = "Contact Number Mobile"
    static let UserType = "User Type"
    static let BusinessEmail = "Business Email"
    static let Password = "Password"
}
