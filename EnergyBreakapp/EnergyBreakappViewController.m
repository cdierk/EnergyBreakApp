//
//  EnergyBreakappViewController.m
//  EnergyBreakapp
//
//  Created by Class Account on 10/10/13.
//  Copyright (c) 2013 UC Berkeley. All rights reserved.
//

#import "EnergyBreakappViewController.h"

@interface EnergyBreakappViewController ()

@end

@implementation EnergyBreakappViewController
@synthesize currentDistribution;
@synthesize batteryView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    
    /* Here the app first checks the stored data to see if the app has been used before.
     It stores the total value of each energy source over the lifetime of the app and can be used
     to display the user's total consumption of each kind of fuel. */
    
    //if standardUserDefaults hasn't been created, then the app has never been used
    if (![standardUserDefaults objectForKey:@"totalPercentage"]) {
        
        NSLog(@"Initialize to all unknown");
        
        totalCoalPercentage = 0.0;
        totalOilPercentage = 0.0;
        totalGasPercentage = 0.0;
        totalNuclearPercentage = 0.0;
        totalHydroPercentage = 0.0;
        totalRenewablePercentage = 0.0;
        totalOtherFossilPercentage = 0.0;
        totalGeothermalPercentage = 0.0;
        totalWindPercentage = 0.0;
        totalSolarPercentage = 0.0;
        totalBiomassPercentage = 0.0;
        totalBiogasPercentage = 0.0;
        totalPercentage = 1.0;
        unknownPercentage = 1.0;
        
        //set values; first time application is used so all is unknown
        [standardUserDefaults setDouble:totalCoalPercentage forKey:@"totalCoal"];
        [standardUserDefaults setDouble:totalOilPercentage forKey:@"totalOil"];
        [standardUserDefaults setDouble:totalGasPercentage forKey:@"totalGas"];
        [standardUserDefaults setDouble:totalNuclearPercentage forKey:@"totalNuclear"];
        [standardUserDefaults setDouble:totalHydroPercentage forKey:@"totalHydro"];
        [standardUserDefaults setDouble:totalRenewablePercentage forKey:@"totalRenewable"];
        [standardUserDefaults setDouble:totalOtherFossilPercentage forKey:@"totalOtherFossil"];
        [standardUserDefaults setDouble:totalGeothermalPercentage forKey:@"totalGeothermal"];
        [standardUserDefaults setDouble:totalGeothermalPercentage forKey:@"totalGeothermal"];
        [standardUserDefaults setDouble:totalWindPercentage forKey:@"totalWind"];
        [standardUserDefaults setDouble:totalSolarPercentage forKey:@"totalSolar"];
        [standardUserDefaults setDouble:totalBiomassPercentage forKey:@"totalBiomass"];
        [standardUserDefaults setDouble:totalBiogasPercentage forKey:@"totalBiogas"];
        [standardUserDefaults setDouble:unknownPercentage forKey:@"unknown"];
        [standardUserDefaults setDouble:totalPercentage forKey:@"total"];
        [standardUserDefaults synchronize];
    }
    
    //otherwise, the app has been used before
    else
    {
        
        //get values from store
        totalCoalPercentage = [standardUserDefaults doubleForKey:@"totalCoal"];
        totalOilPercentage = [standardUserDefaults doubleForKey:@"totalOil"];
        totalGasPercentage = [standardUserDefaults doubleForKey:@"totalGas"];
        totalNuclearPercentage = [standardUserDefaults doubleForKey:@"totalNuclear"];
        totalHydroPercentage = [standardUserDefaults doubleForKey:@"totalHydro"];
        totalRenewablePercentage = [standardUserDefaults doubleForKey:@"totalRenewable"];
        totalOtherFossilPercentage = [standardUserDefaults doubleForKey:@"totalOtherFossil"];
        totalGeothermalPercentage = [standardUserDefaults doubleForKey:@"totalGeothermal"];
        totalGeothermalPercentage = [standardUserDefaults doubleForKey:@"totalGeothermal"];
        totalWindPercentage = [standardUserDefaults doubleForKey:@"totalWind"];
        totalSolarPercentage = [standardUserDefaults doubleForKey:@"totalSolar"];
        totalBiomassPercentage = [standardUserDefaults doubleForKey:@"totalBiomass"];
        totalBiogasPercentage = [standardUserDefaults doubleForKey:@"totalBiogas"];
        unknownPercentage = [standardUserDefaults doubleForKey:@"unknown"];
        totalPercentage = [standardUserDefaults doubleForKey:@"total"];

    }
    [[UIDevice currentDevice] setBatteryMonitoringEnabled:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(batteryStateDidChange:)
                                                 name:UIDeviceBatteryStateDidChangeNotification
                                               object:nil];
    
    startCharge = 0;
    currentCoalPercentage = totalCoalPercentage;
    currentOilPercentage = totalOilPercentage;
    currentGasPercentage = totalGasPercentage;
    currentNuclearPercentage = totalNuclearPercentage;
    currentHydroPercentage = totalHydroPercentage;
    currentGeothermalPercentage = totalGeothermalPercentage;
    currentRenewablePercentage = totalRenewablePercentage;
    currentWindPercentage = totalWindPercentage;
    currentSolarPercentage = totalSolarPercentage;
    currentBiomassPercentage = totalBiomassPercentage;
    currentOtherPercentage = totalOtherFossilPercentage;
    currentTotalPercentage = totalPercentage;
    
    //set values for previous charge
    [batteryView setPreviousDistributionForCoal:totalCoalPercentage Oil:totalOilPercentage Gas:totalGasPercentage Nuclear:totalNuclearPercentage Hydro:totalHydroPercentage Renewable:totalRenewablePercentage Other:totalOtherFossilPercentage Geothermal:totalGeothermalPercentage Wind:totalWindPercentage Solar:totalSolarPercentage Biomass:totalBiomassPercentage Biogas:totalBiogasPercentage Unknown: unknownPercentage AndTotal:totalPercentage];
    
    isCharging = NO;
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder
{
    return YES;
}

- (BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder
{
    return YES;
}

- (void)oneFingerSwipeLeft:(UITapGestureRecognizer *)recognizer {
    //NSLog(@"Swiped left");
    if (currentDistribution != nil && [currentDistribution valueForKey:@"nextDistribution"] != nil) {
        currentDistribution = [currentDistribution valueForKey:@"nextDistribution"];
        [self setDistributionDisplay:currentDistribution];
        /*int zip = [[currentDistribution valueForKey:@"zip"] integerValue];
        distribution = [[EnergyDistribution alloc] initWithZipCode:zip];
        [self setPercentages];
        NSString *currentCity = [currentDistribution valueForKey:@"city"];
        NSString *currentState = [currentDistribution valueForKey:@"state"];
        NSDate *currentDate = [currentDistribution valueForKey:@"date"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
        NSString *formattedDateString = [dateFormatter stringFromDate:currentDate];
        _locationText.textAlignment = NSTextAlignmentCenter;
        NSString *cityAndState = [NSString stringWithFormat: @"%@, %@", currentCity, currentState];
        [_locationText setText:cityAndState];
        [_dateText setText:formattedDateString];*/
    }
}

- (void)oneFingerSwipeRight:(UITapGestureRecognizer *)recognizer {
    //NSLog(@"Swiped right");
    if (currentDistribution != nil) {
        if ([currentDistribution valueForKey:@"previousDistribution"] != nil) {
            currentDistribution = [currentDistribution valueForKey:@"previousDistribution"];
            [self setDistributionDisplay:currentDistribution];
            /*int zip = [[currentDistribution valueForKey:@"zip"] integerValue];
            NSLog(@"Zip coming out is %i", ([[currentDistribution valueForKey:@"zip"] integerValue]));
            distribution = [[EnergyDistribution alloc] initWithZipCode:zip];
            [self setPercentages];
            NSString *currentCity = [currentDistribution valueForKey:@"city"];
            NSString *currentState = [currentDistribution valueForKey:@"state"];
            NSDate *currentDate = [currentDistribution valueForKey:@"date"];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
            [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
            NSString *formattedDateString = [dateFormatter stringFromDate:currentDate];
            NSString *cityAndState = [NSString stringWithFormat: @"%@, %@", currentCity, currentState];
            _locationText.textAlignment = NSTextAlignmentCenter;
            _dateText.textAlignment = NSTextAlignmentCenter;
            [_locationText setText:cityAndState];
            [_dateText setText:formattedDateString];*/
        }
    }
    else {
        [self getUpdatedData];
        currentDistribution = [fetchedObjects lastObject];
        if ([currentDistribution valueForKey:@"city"]) {
            [self setDistributionDisplay:currentDistribution];
        }
    }
    
    
}


/*To have the gesture swiping recognised, after modifying the model and adding the EnergyDistribution (as mentioned in viewDidLoad), set distribution to the saved EnergyDistribution and then call [self setPercentages], then uncomment the following code*/

/*
- (void) setDistributionDisplay:(NSManagedObject*) savedDistribution {
    int zip = [[savedDistribution valueForKey:@"zip"] integerValue];
    NSLog(@"Zip coming out is %i", ([[savedDistribution valueForKey:@"zip"] integerValue]));
    distribution = [[EnergyDistribution alloc] initWithZipCode:zip];
    NSLog(@"Total percentage is %f", [distribution totalPercentages]);
    [self setPercentages];
    NSString *currentCity = [savedDistribution valueForKey:@"city"];
    NSString *currentState = [savedDistribution valueForKey:@"state"];
    NSDate *currentDate = [savedDistribution valueForKey:@"date"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    NSString *formattedDateString = [dateFormatter stringFromDate:currentDate];
    NSString *cityAndState = [NSString stringWithFormat: @"%@, %@", currentCity, currentState];
    _locationText.textAlignment = NSTextAlignmentCenter;
    _dateText.textAlignment = NSTextAlignmentCenter;
    [_locationText setText:cityAndState];
    [_dateText setText:formattedDateString];
}
*/

//works when app is in foreground
- (void)batteryStateDidChange:(NSNotification *)notification {
    if (([[UIDevice currentDevice] batteryState] == UIDeviceBatteryStateCharging)) {
        isCharging = YES;
        
        NSLog(@"Now charging");
        
        UIAlertView *chargingAlert = [[UIAlertView alloc] initWithTitle:@"Charging" message:@"Your device is now charging" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [chargingAlert show];
        
        //get new values for current charge
        [self clearLocation];
        
        _startDate = [NSDate date];
        _startChargePercentage = [[UIDevice currentDevice] batteryLevel];
        startCharge = [[UIDevice currentDevice] batteryLevel];
        
        [locationManager startUpdatingLocation];
        
        NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
        [standardUserDefaults setDouble:currentCoalPercentage forKey:@"currentCoal"];
        [standardUserDefaults setDouble:currentOilPercentage forKey:@"currentOil"];
        [standardUserDefaults setDouble:currentGasPercentage forKey:@"currentGas"];
        [standardUserDefaults setDouble:currentNuclearPercentage forKey:@"currentNuclear"];
        [standardUserDefaults setDouble:currentHydroPercentage forKey:@"currentHydro"];
        [standardUserDefaults setDouble:currentRenewablePercentage forKey:@"currentRenewable"];
        [standardUserDefaults setDouble:currentOtherPercentage forKey:@"currentOtherFossil"];
        [standardUserDefaults setDouble:currentGeothermalPercentage forKey:@"currentGeothermal"];
        [standardUserDefaults setDouble:currentGeothermalPercentage forKey:@"currentGeothermal"];
        [standardUserDefaults setDouble:currentWindPercentage forKey:@"currentWind"];
        [standardUserDefaults setDouble:currentSolarPercentage forKey:@"currentSolar"];
        [standardUserDefaults setDouble:currentBiomassPercentage forKey:@"currentBiomass"];
        [standardUserDefaults setDouble:currentBiogasPercentage forKey:@"currentBiogas"];
        [standardUserDefaults setDouble:unknownPercentage forKey:@"unknown"];
        [standardUserDefaults setDouble:currentTotalPercentage forKey:@"currentTotal"];
        [standardUserDefaults setDouble:_startChargePercentage forKey:@"startCharge"];
        [standardUserDefaults synchronize];
        
        [self updateDisplay:NULL];
    }
    else if ([[UIDevice currentDevice] batteryState] == UIDeviceBatteryStateUnplugged) {
        
        //phone is unplugged
        isCharging = NO;
        _endDate = [NSDate date];
        _endChargePercentage = [[UIDevice currentDevice] batteryLevel];
        
        [batteryView concatDistributions];
        startCharge = [[UIDevice currentDevice] batteryLevel];
        
        _secondsSpentCharging = [_endDate timeIntervalSinceDate:_startDate];
        
        UIAlertView *unpluggedAlert = [[UIAlertView alloc] initWithTitle:@"Unplugged" message:@"Your device is no longer charging" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [unpluggedAlert show];
    }
}

- (IBAction)updateLocation:(id)sender{
    [self clearLocation];
    
    //CHANGE THE UPDATE FREQUENCY!
    [locationManager startUpdatingLocation];
    
}

-(void) clearLocation
{
    _locationText.text = @"";
    _dateText.text = @"";
}


-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //NSLog(@"Failed with error: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Could not get location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *currentLocation = [locations lastObject];
    //NSLog(@"Updated to location: %@", currentLocation);
    distribution = [[EnergyDistribution alloc] initWithLatLon: currentLocation.coordinate.latitude :currentLocation.coordinate.longitude];
    [self setPercentages];
    
    if (currentLocation != nil)
    {
        //_LocationText.text = [NSString stringWithFormat: @"Longitude: %.8f Latitude: %.8f", currentLocation.coordinate.longitude, currentLocation.coordinate.latitude];
    }
    
    [locationManager stopUpdatingLocation];
    
    /*NSLog(@"Reverse geocoding");
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *geocodingError) {
        if (geocodingError == nil && [placemarks count] > 0){
            placemark = [placemarks lastObject];
                distribution = [[EnergyDistribution alloc] initWithZipCode:[[placemark postalCode] intValue]];
            [self setPercentages];
            
            [self getUpdatedData];
        }        
        else{
            NSLog(@"Error!");
        }
    }];*/
}

-(void) getUpdatedData
{
    appDelegate = (EnergyBreakappAppDelegate*) [[UIApplication sharedApplication] delegate];
    context = appDelegate.managedObjectContext;
    
    NSError *error;
    fetchRequest = [[NSFetchRequest alloc] init];
    entity = [NSEntityDescription
              entityForName:@"EnergyDistribution" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
}


-(void) saveDistribution
{
    NSNumber* postalCode;
    postalCode = [NSNumber numberWithInt:[[placemark postalCode] integerValue]];
    NSError *error;
    
    NSManagedObject *last = [fetchedObjects lastObject];
    NSManagedObject *energyDistribution = [NSEntityDescription
                                           insertNewObjectForEntityForName:@"EnergyDistribution"
                                           inManagedObjectContext:context];
    [energyDistribution setValue:postalCode forKey:@"zip"];
    //NSLog(@"Zip put in is %@", postalCode);
    [energyDistribution setValue:[NSDate date] forKey:@"date"];
    [energyDistribution setValue:[placemark locality] forKey:@"city"];
    [energyDistribution setValue:[placemark administrativeArea] forKey:@"state"];
    
    if (last != nil) {
        [energyDistribution setValue:last forKey:@"previousDistribution"];
        [last setValue:energyDistribution forKey:@"nextDistribution"];
    }
    
    currentDistribution = energyDistribution;
    
    if (![context save:&error]) {
        //NSLog(@"Couldn't save: %@", [error localizedDescription]);
    }
}

-(void) setPercentages
{
    currentCoalPercentage = [distribution coalPercentage];
    currentOilPercentage = [distribution oilPercentage];
    currentGasPercentage = [distribution gasPercentage];
    currentNuclearPercentage = [distribution nuclearPercentage];
    currentHydroPercentage = [distribution hydroPercentage];
    currentRenewablePercentage = [distribution renewablePercentage];
    currentOtherPercentage = [distribution otherPercentage];
    //NSLog(@"Other percentage in view controller is %f", currentOtherPercentage);
    currentGeothermalPercentage = [distribution geothermalPercentage];
    currentSolarPercentage = [distribution solarPercentage];
    currentWindPercentage = [distribution windPercentage];
    currentBiomassPercentage = [distribution biomassPercentage];
    currentBiogasPercentage = [distribution biogasPercentage];
    currentTotalPercentage = [distribution totalPercentages];
    [batteryView setDistributionForCoal:currentCoalPercentage Oil:currentOilPercentage Gas:currentGasPercentage Nuclear:currentNuclearPercentage Hydro:currentHydroPercentage Renewable:currentRenewablePercentage Other:currentOtherPercentage Geothermal:currentGeothermalPercentage Wind:currentWindPercentage Solar:currentSolarPercentage Biomass:currentBiomassPercentage Biogas:currentBiogasPercentage Unknown: unknownPercentage AndTotal:currentTotalPercentage AndStartCharge:startCharge];
}

//data already gathered from API, simply update display from it
- (IBAction)updateDisplay:(id)sender {
    
    [batteryView setDistributionForCoal:currentCoalPercentage Oil:currentOilPercentage Gas:currentGasPercentage Nuclear:currentNuclearPercentage Hydro:currentHydroPercentage Renewable:currentRenewablePercentage Other:currentOtherPercentage Geothermal:currentGeothermalPercentage Wind:currentWindPercentage Solar:currentSolarPercentage Biomass:currentBiomassPercentage Biogas:currentBiogasPercentage Unknown: unknownPercentage AndTotal:currentTotalPercentage AndStartCharge:startCharge];
}

//if app is running in background
//not quite implemented
-(void) math
{
    //device is charging
    if ([[UIDevice currentDevice] batteryState] == UIDeviceBatteryStateCharging) {
        NSLog(@"Charging...");
        //if was charging before
        if(isCharging){
            
        }
        //if was not charging before
        else {
            
            NSLog(@"Now charging");
            
            UIAlertView *chargingAlert = [[UIAlertView alloc] initWithTitle:@"Charging" message:@"Your device is now charging" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [chargingAlert show];
            
            //get new values for current charge
            [self clearLocation];
            
            _startDate = [NSDate date];
            _startChargePercentage = [[UIDevice currentDevice] batteryLevel];
            startCharge = [[UIDevice currentDevice] batteryLevel];
            
            [locationManager startUpdatingLocation];
            
            NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
            [standardUserDefaults setDouble:currentCoalPercentage forKey:@"currentCoal"];
            [standardUserDefaults setDouble:currentOilPercentage forKey:@"currentOil"];
            [standardUserDefaults setDouble:currentGasPercentage forKey:@"currentGas"];
            [standardUserDefaults setDouble:currentNuclearPercentage forKey:@"currentNuclear"];
            [standardUserDefaults setDouble:currentHydroPercentage forKey:@"currentHydro"];
            [standardUserDefaults setDouble:currentRenewablePercentage forKey:@"currentRenewable"];
            [standardUserDefaults setDouble:currentOtherPercentage forKey:@"currentOtherFossil"];
            [standardUserDefaults setDouble:currentGeothermalPercentage forKey:@"currentGeothermal"];
            [standardUserDefaults setDouble:currentGeothermalPercentage forKey:@"currentGeothermal"];
            [standardUserDefaults setDouble:currentWindPercentage forKey:@"currentWind"];
            [standardUserDefaults setDouble:currentSolarPercentage forKey:@"currentSolar"];
            [standardUserDefaults setDouble:currentBiomassPercentage forKey:@"currentBiomass"];
            [standardUserDefaults setDouble:currentBiogasPercentage forKey:@"currentBiogas"];
            [standardUserDefaults setDouble:unknownPercentage forKey:@"unknown"];
            [standardUserDefaults setDouble:currentTotalPercentage forKey:@"currentTotal"];
            [standardUserDefaults setDouble:_startChargePercentage forKey:@"startCharge"];
            [standardUserDefaults synchronize];
            
            [self updateDisplay:NULL];
        }
        isCharging = YES;
    }
    else if ([[UIDevice currentDevice] batteryState] == UIDeviceBatteryStateFull) {
        NSLog(@"Completely charged");
        //if was charging before
        if(isCharging){
            _endDate = [NSDate date];
            _endChargePercentage = [[UIDevice currentDevice] batteryLevel];
            
            [batteryView concatDistributions];
            startCharge = [[UIDevice currentDevice] batteryLevel];
            
            _secondsSpentCharging = [_endDate timeIntervalSinceDate:_startDate];
            
        }
        //if was not charging before
        else {
            
        }
        isCharging = NO;
    }
    else if ([[UIDevice currentDevice] batteryState] == UIDeviceBatteryStateUnplugged) {
        NSLog(@"Not plugged in");
        //if was charging before
        if (isCharging){
            //phone is unplugged
            _endDate = [NSDate date];
            _endChargePercentage = [[UIDevice currentDevice] batteryLevel];
            
            [batteryView concatDistributions];
            startCharge = [[UIDevice currentDevice] batteryLevel];
            
            _secondsSpentCharging = [_endDate timeIntervalSinceDate:_startDate];
            
            UIAlertView *unpluggedAlert = [[UIAlertView alloc] initWithTitle:@"Unplugged" message:@"Your device is no longer charging" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [unpluggedAlert show];
            
        }
        //if was not charging before
        else {
            
        }
        isCharging = NO;
    }
}
@end
