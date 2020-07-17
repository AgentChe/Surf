//
//  GlobalDefinitions.swift
//  FAWN
//
//  Created by Andrey Chernyshev on 18/04/2020.
//  Copyright © 2020 Алексей Петров. All rights reserved.
//

final class GlobalDefinitions {
    struct ChatService {
        static let wsDomain = "ws://84.201.169.190"
        static let restDomain = "http://84.201.169.190"
        static let appKey = "b410fe27-2b11-4573-8e92-d02fe2a2d083"
    }
    
    struct Backend {
//        static let domain = "https://surf.korrekted.com" // prod
        static let domain = "https://surf.korrekted.com" // dev
        
//        static let apiKey = "56eq2dCAkHgzgok=" // prod
        static let apiKey = "56eq2dCAkHgzgok=" // dev
    }
    
    struct Analytics {
        static let appNameForAmplitude = "SURF"
        
//        static let amplitudeAPIKey = "b503251969f4b1d7901d2f7d1388d476" // prod
            static let amplitudeAPIKey = "dde6c038a32c3082b6debe249fad5d34" // dev
    }
    
    struct TermsOfService {
        static let termsUrl = "https://surf.korrekted.com/legal/terms"
        static let policyUrl = "https://surf.korrekted.com/legal/policy"
        static let contactUrl = "https://surf.korrekted.com/legal/contact"
    }
}
