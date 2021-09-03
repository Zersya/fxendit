#import "FxenditPlugin.h"
#if __has_include(<fxendit/FxenditPlugin.h>)
#import <fxendit/FxenditPlugin.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "FxenditPlugin.h"
#endif

#import <Xendit/Xendit-Swift.h>

@implementation FxenditPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel *channel =
            [FlutterMethodChannel methodChannelWithName:@"fxendit"
                                        binaryMessenger:registrar.messenger];
    
    FxenditPlugin *instance = [[FxenditPlugin alloc] init];
        [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result{
    
    if ([call.method isEqualToString:@"createSingleToken"]) {
        [self createSingleToken:call result:result];
    }
//    else if ([call.method isEqualToString:@"createMultiToken"]) {
//        result(@"createMultiToken");
//    } else if ([call.method isEqualToString:@"createAuthentication"]) {
//        result(@"createAuthentication");
//    }
}

- (void)init:(NSString*) publishedKey{
    Xendit.publishableKey = publishedKey;
    
    NSLog(@"%@", Xendit.publishableKey);
}

- (void)createSingleToken: (FlutterMethodCall *)call result:(FlutterResult)result{
    
    NSString *publishedKey = call.arguments[@"publishedKey"];
    
    if (publishedKey == nil) {
        return;
    }
    
    [self init:publishedKey];
    
    NSDictionary *_card = call.arguments[@"card"];
    
    if(_card == nil){
        return;
    }
    
    XenditCardData *cardData = [XenditCardData alloc ];
    cardData.cardNumber = _card[@"creditCardNumber"];
    cardData.cardCvn = _card[@"creditCardCVN"];
    cardData.cardExpMonth = _card[@"expirationMonth"];
    cardData.cardExpYear = _card[@"expirationYear"];
    
    bool _shouldAuthenticate = (bool) call.arguments[@"shouldAuthenticate"];
    bool shouldAuthenticate = true;
    
    if(_shouldAuthenticate){
        shouldAuthenticate = _shouldAuthenticate;
    }
    
    NSNumber *amount = call.arguments[@"amount"];
    NSString *onBehalfOf = call.arguments[@"onBehalfOf"];
    

    XenditTokenizationRequest *tokenRequest = [XenditTokenizationRequest alloc];
    tokenRequest.amount = amount;
    tokenRequest.cardData = cardData;
    tokenRequest.shouldAuthenticate = shouldAuthenticate;
    tokenRequest.isSingleUse = true;
    
    [Xendit createTokenFromViewController:self tokenizationRequest:tokenRequest onBehalfOf:onBehalfOf completion:^(XENCCToken * _Nullable token, XENError * _Nullable error) {
        if(error != nil){
            [NSException raise:NSGenericException format:@"%@", error.message];
        }
        
        NSDictionary *dict = @{
                    @"id": token.tokenID,
                    @"status": token.status,
                    @"authenticationId": token.authenticationId,
                    @"maskedCardNumber": token.maskedCardNumber,
                    @"should3ds": @NO,
                    @"cardInfo": @{
                            @"bank": token.cardInfo.bank,
                            @"country": token.cardInfo.country,
                            @"type": token.cardInfo.type,
                            @"brand": token.cardInfo.brand,
//                            @"cardArtUrl": token.cardInfo.cardArtUrl,
                            @"fingerprint": token.cardInfo.fingerprint,
                    }
        };
        
        result(dict);

    }];
        
    
    
//
//    [Xendit createTokenFromViewController:self cardData:cardData shouldAuthenticate:shouldAuthenticate onBehalfOf:onBehalfOf completion:^(XENCCToken * _Nullable token, XENError * _Nullable error) {
//        if(error != nil){
//            [NSException raise:NSInternalInconsistencyException format:error.message];
//            return;
//        }
//
//
//        NSLog(@"Token : %@, Status %@", token.tokenID, token.status);
//
//        NSDictionary *dict = @{
//            @"id": token.tokenID,
//            @"status": token.status,
//            @"authenticationId": token.authenticationId,
//            @"maskedCardNumber": token.maskedCardNumber,
//            @"should3ds": @NO,
//            @"cardInfo": @{
//                    @"bank": token.cardInfo.bank,
//                    @"country": token.cardInfo.country,
//                    @"type": token.cardInfo.type,
//                    @"brand": token.cardInfo.brand,
//                    @"cardArtUrl": token.cardInfo.cardArtUrl,
//                    @"fingerprint": token.cardInfo.fingerprint,
//            }
//        };
//    }];
    
   
    
}
@end
