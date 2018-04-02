# Salesforce.com Mobile SDK for iOS

This repository has been forked from [offical salesforce sdk](https://github.com/forcedotcom/SalesforceMobileSDK-iOS).

#### Key features added: 
- Log in Without getting redirect to salesforce page in a web view
  - update username, password while calling launch function
  - set oauthScopes to [api,web]
  - update remoteAccessConsumerKey, oAuthRedirectURI and clientSecret in app config. You can find these values in connected app in salesforce
- Parses json response from salesforce to corresponding swift class.
  - SFRestAPIPromisesPresets is the extension where we define
    - enum for salesforce objects 
    - predfined fields for salesforce object
    - class used to decode JSON responses
- SSL Pining which encrypts all the communication between salesforce and iOS SDK
  - update sslpiningcertificate name in appConfig to enable ssl pinning.
- Use CMObjectType and CMCondition to build queries.

Getting Started
==
- If you'd like to work with the source code of the SDK itself, you've come to the right place!  You can browse sample app source code and debug down through the layers to get a feel for how everything works under the covers.
- If you're just eager to start developing your own new application, the quickest way is to use cocoapod.
```
  pod 'SalesforceAnalytics',:git => 'https://git.assembla.com/pwc-digital-services-libraries.salesforceiossdk.git'
	pod 'SalesforceSDKCore',:git =>  'https://git.assembla.com/pwc-digital-services-libraries.salesforceiossdk.git'
	pod 'SmartStore',:git =>  'https://git.assembla.com/pwc-digital-services-libraries.salesforceiossdk.git'
	pod 'SmartSync',:git =>  'https://git.assembla.com/pwc-digital-services-libraries.salesforceiossdk.git'
	pod 'SalesforceSwiftSDK',:git =>  'https://git.assembla.com/pwc-digital-services-libraries.salesforceiossdk.git'
	pod 'PromiseKit', :git => 'https://github.com/mxcl/PromiseKit', :tag => '5.0.3'

```

## Setting up the repo
First, clone the repo:

- Open the Terminal App
- `cd` to the parent directory where the repo directory will live
- `git clone https://git.assembla.com/pwc-digital-services-libraries.salesforceiossdk.git`

After cloning the repo:

- `cd SalesforceMobileSDK-iOS`
- `./install.sh`

This script pulls the submodule dependencies from GitHub, to finalize setup of the workspace.  You can then work with the Mobile SDK by opening `SalesforceMobileSDK.xcworkspace` from Xcode.

See [build.md](build.md) for information on generating binary distributions and app templates.

The Salesforce Mobile SDK for iOS requires iOS 10.0 or greater.  The install.sh script checks for this, and aborts if the configured SDK version is incorrect.  Building from the command line has been tested using ant 1.8.  Older versions might work, but we recommend using the latest version of ant.


Documentation
==

* [SalesforceAnalytics Library Reference](http://forcedotcom.github.io/SalesforceMobileSDK-iOS/Documentation/SalesforceAnalytics/html/index.html)
* [SalesforceSDKCore Library Reference](http://forcedotcom.github.io/SalesforceMobileSDK-iOS/Documentation/SalesforceSDKCore/html/index.html)
* [SmartStore Library Reference](http://forcedotcom.github.io/SalesforceMobileSDK-iOS/Documentation/SmartStore/html/index.html)
* [SmartSync Library Reference](http://forcedotcom.github.io/SalesforceMobileSDK-iOS/Documentation/SmartSync/html/index.html)
* [SalesforceHybridSDK Library Reference](http://forcedotcom.github.io/SalesforceMobileSDK-iOS/Documentation/SalesforceHybridSDK/html/index.html)
* [SalesforceReact Library Reference](http://forcedotcom.github.io/SalesforceMobileSDK-iOS/Documentation/SalesforceReact/html/index.html)
* [SalesforceSwiftSDK Library Reference](http://forcedotcom.github.io/SalesforceMobileSDK-iOS/Documentation/SalesforceSwiftSDK/index.html)
* Salesforce Mobile SDK Development Guide -- [PDF](https://github.com/forcedotcom/SalesforceMobileSDK-Shared/blob/master/doc/mobile_sdk.pdf) | [HTML](https://developer.salesforce.com/docs/atlas.en-us.mobile_sdk.meta/mobile_sdk/preface_intro.htm)
* [Mobile SDK Trail](https://trailhead.salesforce.com/trails/mobile_sdk_intro)

