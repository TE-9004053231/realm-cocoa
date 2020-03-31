////////////////////////////////////////////////////////////////////////////
//
// Copyright 2016 Realm Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
////////////////////////////////////////////////////////////////////////////

#import "RLMAppCredentials_Private.hpp"
#import "RLMSyncUtil_Private.h"
#import "RLMUtil.hpp"

using namespace realm;

@interface RLMAppCredentials ()

- (instancetype) initWithAppCredentials:(const app::AppCredentials&)credentials NS_DESIGNATED_INITIALIZER;

@end

@implementation RLMAppCredentials

- (instancetype)initWithAppCredentials:(const app::AppCredentials&)credentials {
    if (self = [super init]) {
        _appCredentials = std::move(credentials);
        self.provider = @(credentials.provider_as_string().data());
        return self;
    }
    return nil;
}

+ (instancetype)credentialsWithFacebookToken:(RLMAppCredentialsToken)token {
    return [[self alloc] initWithAppCredentials: app::AppCredentials::facebook(token.UTF8String)];
}

+ (instancetype)credentialsWithGoogleToken:(RLMAppCredentialsToken)token {
    return [[self alloc] initWithAppCredentials: app::AppCredentials::google(token.UTF8String)];
}

+ (instancetype)credentialsWithAppleToken:(RLMAppCredentialsToken)token {
    return [[self alloc] initWithAppCredentials: app::AppCredentials::apple(token.UTF8String)];
}

+ (instancetype)credentialsWithUsername:(NSString *)username
                               password:(NSString *)password {
    return [[self alloc] initWithAppCredentials: app::AppCredentials::username_password(username.UTF8String,
                                                                                        password.UTF8String)];
}

+ (instancetype)credentialsWithJWT:(NSString *)token {
    return [[self alloc] initWithAppCredentials: app::AppCredentials::custom(token.UTF8String)];
}
    
+ (instancetype)anonymousCredentials {
    return [[self alloc] initWithAppCredentials: realm::app::AppCredentials::anonymous()];
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[RLMAppCredentials class]]) {
        return NO;
    }
    RLMAppCredentials *that = (RLMAppCredentials *)object;
    return ([self.provider isEqualToString:that.provider]
            && self.appCredentials.serialize_as_json() == that.appCredentials.serialize_as_json());
}

@end