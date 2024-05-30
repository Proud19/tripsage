//
//  URLProvider .swift
//  tripsage
//
//  Created by Proud Mpala on 5/29/24.
//

import Foundation

class URLProvider {
    static let baseURL = "postgres://tripsage_user:ikVzJY0RciGbwaeIeE92gw1jsAder3cf@dpg-cpbrqcsf7o1s7385ld30-a.oregon-postgres.render.com/tripsage/"
    
    
    static let loginUse = URL(string: baseURL + "auth/login")
    
    static let registerUser = URL(string: baseURL + "auth/register")
}
