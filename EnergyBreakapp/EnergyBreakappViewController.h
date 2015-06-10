//
//  EnergyBreakappViewController.h
//  EnergyBreakapp
//
//  Created by Class Account on 10/10/13.
//  Copyright (c) 2013 UC Berkeley. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreLocation/CoreLocation.h>
#import "EnergyBreakappAppDelegate.h"
#import "EnergyDataGetter.h"
#import "EnergyDistribution.h"
#import "BatteryView.h"

@interface EnergyBreakappViewController : UIViewController <CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    NSManagedObjectContext *context;
    EnergyBreakappAppDelegate *appDelegate;
    NSFetchRequest *fetchRequest;
    NSEntityDescription *entity;
    NSArray *fetchedObjects;
    BOOL isCharging;
    EnergyDistribution *distribution;
    double startCharge;
    double currentCoalPercentage, currentOilPercentage, currentGasPercentage, currentNuclearPercentage, currentHydroPercentage, currentRenewablePercentage, currentOtherPercentage, currentGeothermalPercentage, currentWindPercentage, currentSolarPercentage, currentBiomassPercentage, currentBiogasPercentage, currentTotalPercentage;
    double totalCoalPercentage, totalOilPercentage, totalGasPercentage, totalNuclearPercentage, totalHydroPercentage, totalRenewablePercentage, totalOtherFossilPercentage, totalGeothermalPercentage, totalWindPercentage, totalSolarPercentage, totalBiomassPercentage, totalBiogasPercentage, totalPercentage;
}
/*@property (weak, nonatomic) IBOutlet UITextView *LocationText;
@property (weak, nonatomic) IBOutlet UITextView *CoalText;
@property (weak, nonatomic) IBOutlet UITextView *OilText;
@property (weak, nonatomic) IBOutlet UITextView *GasText;
@property (weak, nonatomic) IBOutlet UITextView *NuclearText;
@property (weak, nonatomic) IBOutlet UITextView *HydroText;
@property (weak, nonatomic) IBOutlet UITextView *RenewableText;*/
@property NSManagedObject *currentDistribution;
@property NSDate *startDate;
@property NSDate *endDate;
@property float startChargePercentage;
@property float endChargePercentage;
@property float percentCharged;
@property NSTimeInterval secondsSpentCharging;
- (IBAction)updateLocation:(id)sender;
@property (strong, nonatomic) IBOutlet BatteryView *batteryView;
@property (weak, nonatomic) IBOutlet UITextView *locationText;
@property (weak, nonatomic) IBOutlet UITextView *dateText;

-(void) getUpdatedData;
-(void) setDistributionDisplay: (NSManagedObject*) distribution;
- (IBAction)updateDisplay:(id)sender;
-(void) math;

@end
