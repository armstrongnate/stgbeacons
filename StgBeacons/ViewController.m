//
//  ViewController.m
//  StgBeacons
//
//  Created by Nate Armstrong on 3/11/14.
//  Copyright (c) 2014 Nate Armstrong. All rights reserved.
//

@import CoreLocation;

#import "ViewController.h"

NSString * const kBEACON_UUID = @"6A484D3E-708F-4416-9BB9-0448CD02BA9C";

@interface ViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;

    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:kBEACON_UUID];
    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"com.natearmstrong.stgbeacons"];

    region.notifyOnEntry = YES;
    region.notifyOnExit = YES;
    region.notifyEntryStateOnDisplay = YES;

    [self.locationManager startRangingBeaconsInRegion:region];

    // later
    [self.locationManager requestStateForRegion:region];
}

#pragma mark - CLLocationManagerDelegate

// later
- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    if (state == CLRegionStateInside)
    {
        CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
        [self.locationManager startRangingBeaconsInRegion:beaconRegion];
    }
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    if ([region isKindOfClass:[CLBeaconRegion class]])
    {
        CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
        if ([beaconRegion.identifier isEqualToString:@"com.natearmstrong.stgbeacons"])
        {
            [self.locationManager startRangingBeaconsInRegion:beaconRegion];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    if ([region isKindOfClass:[CLBeaconRegion class]])
    {
        CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
        if ([beaconRegion.identifier isEqualToString:@"com.natearmstrong.stgbeacons"])
        {
            [self.locationManager stopRangingBeaconsInRegion:beaconRegion];
        }
    }
}

- (NSString *)stringForProximity:(CLProximity)proximity {
    switch (proximity) {
        case CLProximityUnknown:    return @"Unknown";
        case CLProximityFar:        return @"Far";
        case CLProximityNear:       return @"Near";
        case CLProximityImmediate:  return @"Immediate";
        default:
            return nil;
    }
}

- (void)setColorForProximity:(CLProximity)proximity
{
    switch (proximity)
    {
        case CLProximityUnknown:
            self.view.backgroundColor = [UIColor whiteColor];
            break;

        case CLProximityFar:
            self.view.backgroundColor = [UIColor yellowColor];
            break;

        case CLProximityNear:
            self.view.backgroundColor = [UIColor orangeColor];
            break;

        case CLProximityImmediate:
            self.view.backgroundColor = [UIColor redColor];
            break;

        default:
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    for (CLBeacon *beacon in beacons)
    {
        NSLog(@"Ranging beacon: %@", beacon.proximityUUID);
        NSLog(@"%@ - %@", beacon.major, beacon.minor);
        NSLog(@"Proximity: %@", [self stringForProximity:beacon.proximity]);
        [self setColorForProximity:beacon.proximity];
    }
}

@end
