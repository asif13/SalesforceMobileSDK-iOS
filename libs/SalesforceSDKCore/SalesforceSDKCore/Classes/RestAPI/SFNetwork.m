/*
 SFNetwork.m
 SalesforceSDKCore
 
 Created by Bharath Hariharan on 2/15/17.
 
 Copyright (c) 2017-present, salesforce.com, inc. All rights reserved.
 
 Redistribution and use of this software in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright notice, this list of conditions
 and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, this list of
 conditions and the following disclaimer in the documentation and/or other materials provided
 with the distribution.
 * Neither the name of salesforce.com, inc. nor the names of its contributors may be used to
 endorse or promote products derived from this software without specific prior written
 permission of salesforce.com, inc.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
 FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY
 WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "SFNetwork.h"
#import "SalesforceSDKManager+Internal.h"
@interface SFNetwork()

@property (nonatomic, readwrite, strong, nonnull) NSURLSession *ephemeralSession;
@property (nonatomic, readwrite, strong, nonnull) NSURLSession *backgroundSession;

@end

@implementation SFNetwork

static NSURLSessionConfiguration *kSFEphemeralSessionConfig;
static NSURLSessionConfiguration *kSFBackgroundSessionConfig;

- (instancetype)init {
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *ephemeralSessionConfig = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        if (kSFEphemeralSessionConfig) {
            ephemeralSessionConfig = kSFEphemeralSessionConfig;
        }
        NSString *certificateName = [SalesforceSDKManager sharedManager].appConfig.sslPiningCertificate;
        //If certificate name is set, than we add a delegate to NSURLSession to handle ssl pining
        if (certificateName != NULL){
            self.ephemeralSession = [NSURLSession sessionWithConfiguration:ephemeralSessionConfig delegate:self delegateQueue:nil];
        }else {
            self.ephemeralSession = [NSURLSession sessionWithConfiguration:ephemeralSessionConfig];
        }

        
        NSString *identifier = [NSString stringWithFormat:@"com.salesforce.network.%lu", (unsigned long)self.hash];
        NSURLSessionConfiguration *backgroundSessionConfig = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:identifier];
        if (kSFBackgroundSessionConfig) {
            backgroundSessionConfig = kSFBackgroundSessionConfig;
        }
        if (certificateName != NULL){
            self.backgroundSession = [NSURLSession sessionWithConfiguration:backgroundSessionConfig];
        }else {
            self.backgroundSession = [NSURLSession sessionWithConfiguration:backgroundSessionConfig delegate:self delegateQueue:nil];

        }
        
        self.useBackground = NO;
        
    }
    return self;
}

- (NSURLSessionDataTask *)sendRequest:(nonnull NSURLRequest *)urlRequest dataResponseBlock:(nullable SFDataResponseBlock)dataResponseBlock {
    NSURLSessionDataTask *dataTask = [[self activeSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (dataResponseBlock) {
            dataResponseBlock(data, response, error);
        }
    }];
    [dataTask resume];
    return dataTask;
}

- (NSURLSession *)activeSession {
    return (self.useBackground ? self.backgroundSession : self.ephemeralSession);
}

+ (void)setSessionConfiguration:(NSURLSessionConfiguration *)sessionConfig isBackgroundSession:(BOOL)isBackgroundSession {
    if (isBackgroundSession) {
        kSFBackgroundSessionConfig = sessionConfig;
    } else {
        kSFEphemeralSessionConfig = sessionConfig;
    }
}
#pragma mark - NSUrlSessionDelegate

-(void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    
    // Get remote certificate
    SecTrustRef serverTrust = challenge.protectionSpace.serverTrust;
    SecCertificateRef certificate = SecTrustGetCertificateAtIndex(serverTrust, 0);
    
    // Set SSL policies for domain name check
    NSMutableArray *policies = [NSMutableArray array];
    [policies addObject:(__bridge_transfer id)SecPolicyCreateSSL(true, (__bridge CFStringRef)challenge.protectionSpace.host)];
    SecTrustSetPolicies(serverTrust, (__bridge CFArrayRef)policies);
    
    // Evaluate server certificate
    SecTrustResultType result;
    SecTrustEvaluate(serverTrust, &result);
    BOOL certificateIsValid = (result == kSecTrustResultUnspecified || result == kSecTrustResultProceed);
    
    // Get local and remote cert data
    NSData *remoteCertificateData = CFBridgingRelease(SecCertificateCopyData(certificate));
    NSString *certificateName = [SalesforceSDKManager sharedManager].appConfig.sslPiningCertificate;
    NSString *pathToCert = [[NSBundle mainBundle]pathForResource:certificateName ofType:@"cer"];
    NSData *localCertificate = [NSData dataWithContentsOfFile:pathToCert];
    
    // The pinnning check
    if ([remoteCertificateData isEqualToData:localCertificate] && certificateIsValid) {
        NSURLCredential *credential = [NSURLCredential credentialForTrust:serverTrust];
        completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
    } else {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, NULL);
    }
}

@end
