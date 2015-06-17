//
//  BatteryView.m
//  EnergyBreakapp
//
//  Created by Utkarsh Dalal on 12/12/13.
//  Copyright (c) 2013 UC Berkeley. All rights reserved.
//

#import "BatteryView.h"

@implementation BatteryView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        hasDistribution = NO;
    }
    return self;
}

-(void) setDistributionForCoal: (double) coalPercentage Oil: (double) oilPercentage Gas: (double) gasPercentage Nuclear: (double) nuclearPercentage Hydro: (double) hydroPercentage Renewable: (double) renewablePercentage Other: (double) otherPercentage Geothermal: (double) geothermalPercentage Wind: (double) windPercentage Solar: (double) solarPercentage Biomass: (double) biomassPercentage Biogas: (double) biogasPercentage  Unknown: (double) newUnknownPercentage AndTotal: (double) totalPercentage AndStartCharge:(double)startChargeValue
{
    NSLog(@"Other is %f out of a total of %f", otherPercentage, totalPercentage);
    currentCoalPercentage = coalPercentage/totalPercentage;
    currentOilPercentage = oilPercentage/totalPercentage;
    currentGasPercentage = gasPercentage/totalPercentage;
    currentNuclearPercentage = nuclearPercentage/totalPercentage;
    currentHydroPercentage = hydroPercentage/totalPercentage;
    currentRenewablePercentage = renewablePercentage/totalPercentage;
    currentOtherPercentage = otherPercentage/totalPercentage;
    NSLog(@"Other fossil percentage in Battery View setup is %f", currentOtherPercentage);
    currentGeothermalPercentage = geothermalPercentage/totalPercentage;
    currentWindPercentage = windPercentage/totalPercentage;
    currentSolarPercentage = solarPercentage/totalPercentage;
    currentBiomassPercentage = biomassPercentage/totalPercentage;
    currentBiogasPercentage = biogasPercentage/totalPercentage;
    currentTotalPercentage = totalPercentage;
    unknownPercentage = newUnknownPercentage;
    startCharge = startChargeValue;
    hasDistribution = YES;
    [self setNeedsDisplay];
}

-(void) setPreviousDistributionForCoal: (double)coalPercentage Oil:(double)oilPercentage Gas:(double)gasPercentage Nuclear:(double)nuclearPercentage Hydro:(double)hydroPercentage Renewable:(double)renewablePercentage Other:(double)otherPercentage Geothermal:(double)geothermalPercentage Wind:(double)windPercentage Solar:(double)solarPercentage Biomass:(double)biomassPercentage Biogas:(double)biogasPercentage Unknown: (double) newUnknownPercentage AndTotal:(double)totalPercentage
{
    NSLog(@"Other is %f out of a total of %f", otherPercentage, totalPercentage);
    previousCoalPercentage = coalPercentage/totalPercentage;
    previousOilPercentage = oilPercentage/totalPercentage;
    previousGasPercentage = gasPercentage/totalPercentage;
    previousNuclearPercentage = nuclearPercentage/totalPercentage;
    previousHydroPercentage = hydroPercentage/totalPercentage;
    previousRenewablePercentage = renewablePercentage/totalPercentage;
    previousOtherPercentage = otherPercentage/totalPercentage;
    NSLog(@"Other fossil percentage in Battery View setup is %f", previousOtherPercentage);
    previousGeothermalPercentage = geothermalPercentage/totalPercentage;
    previousWindPercentage = windPercentage/totalPercentage;
    previousSolarPercentage = solarPercentage/totalPercentage;
    previousBiomassPercentage = biomassPercentage/totalPercentage;
    previousBiogasPercentage = biogasPercentage/totalPercentage;
    previousTotalPercentage = totalPercentage;
    unknownPercentage = newUnknownPercentage;
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect
{
    if (hasDistribution) {
        [self fillBattery];
    }
}

- (void)drawBattery
{
    CGFloat top = self.bounds.origin.y;
    CGFloat left = self.bounds.origin.x;
    CGFloat right = left + self.bounds.size.width;
    CGFloat bottom = top + self.bounds.size.height;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.5);
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    CGRect batteryRectangle = CGRectMake(left + 1.25, top + 1.25, self.bounds.size.width - 12.5, self.bounds.size.height - 2.5);
    CGRect batteryTopRectangle = CGRectMake(right - 11.25, self.bounds.size.height/2 - 10, 7.5, 20);
    CGContextAddRect(context, batteryRectangle);
    CGContextAddRect(context, batteryTopRectangle);
    CGContextStrokePath(context);
}

/* The following code taken from http://www.raywenderlich.com/32283/core-graphics-tutorial-lines-rectangles-and-gradients */

void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor)
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

/*To show biogas' contribution to the fuel mix, make it so that the battery draws it as well.
 Don't forget to add it to the colour-label key in the storyboard!*/

-(void) fillBattery
{
    NSLog(@"start charge is %f", startCharge);
    
    [self drawBattery];
    CGFloat top = self.bounds.origin.y + 5;
    CGFloat currentPosition = self.bounds.origin.x + 5;
    CGFloat width = self.bounds.size.width - 20;
    double currentCharge = [[UIDevice currentDevice] batteryLevel];
    CGFloat remainingWidth = width*(currentCharge - startCharge) - 5;
    CGFloat height = self.bounds.size.height - 10;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    NSLog(@"width is %f", width);
    NSLog(@"currentCharge is %f", currentCharge);
    NSLog(@"startCharge is %f", startCharge);
    NSLog(@"remaining width is %f", remainingWidth);
    
    CGRect startChargeRectangle = CGRectMake(currentPosition, top, startCharge*width, height);
    currentPosition += startCharge*width;
    CGContextAddRect(context, startChargeRectangle);
    UIColor * dGreyColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0];
    UIColor * lGreyColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0];
    drawLinearGradient(context, startChargeRectangle, lGreyColor.CGColor, dGreyColor.CGColor);
    
    //can use same color because unknown is subset of start charge
    if (startCharge == 0){
        CGRect unknownChargeRectangle = CGRectMake(currentPosition, top, unknownPercentage*remainingWidth, height);
        currentPosition += unknownPercentage*remainingWidth;
        CGContextAddRect(context, unknownChargeRectangle);
        UIColor * dGreyColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0];
        UIColor * lGreyColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1.0];
        drawLinearGradient(context, unknownChargeRectangle, lGreyColor.CGColor, dGreyColor.CGColor);
    }
    
    CGRect coalRectangle = CGRectMake(currentPosition, top, currentCoalPercentage*remainingWidth, height);
    currentPosition += currentCoalPercentage*remainingWidth;
    CGContextAddRect(context, coalRectangle);
    UIColor * darkwhiteColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1.0];
    UIColor * whiteColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    drawLinearGradient(context, coalRectangle, whiteColor.CGColor, darkwhiteColor.CGColor);
    
    CGRect oilRectangle = CGRectMake(currentPosition, top, currentOilPercentage*remainingWidth, height);
    currentPosition += currentOilPercentage*remainingWidth;
    CGContextAddRect(context, oilRectangle);
    UIColor * darkOrangeColor = [UIColor colorWithRed:0.5 green:0.2 blue:0.1 alpha:1.0];
    UIColor * lightOrangeColor = [UIColor colorWithRed:0.9 green:0.5 blue:0.0 alpha:1.0];
    drawLinearGradient(context, oilRectangle, lightOrangeColor.CGColor, darkOrangeColor.CGColor);
    
    CGRect gasRectangle = CGRectMake(currentPosition, top, currentGasPercentage*remainingWidth, height);
    currentPosition += currentGasPercentage*remainingWidth;
    CGContextAddRect(context, gasRectangle);
    UIColor * darkRedColor = [UIColor colorWithRed:0.3 green:0.1 blue:0.0 alpha:1.0];
    UIColor * lightRedColor = [UIColor colorWithRed:0.7 green:0.1 blue:0.0 alpha:1.0];
    drawLinearGradient(context, gasRectangle, lightRedColor.CGColor, darkRedColor.CGColor);
    
    CGRect nuclearRectangle = CGRectMake(currentPosition, top, currentNuclearPercentage*remainingWidth, height);
    currentPosition += currentNuclearPercentage*remainingWidth;
    CGContextAddRect(context, nuclearRectangle);
    UIColor * darkNuclearGreenColor = [UIColor colorWithRed:0.0 green:0.4 blue:0.0 alpha:1.0];
    UIColor * lightNuclearGreenColor = [UIColor colorWithRed:0.0 green:0.8 blue:0.0 alpha:1.0];
    drawLinearGradient(context, nuclearRectangle, lightNuclearGreenColor.CGColor, darkNuclearGreenColor.CGColor);
    NSLog(@"Current drawing position is %f", currentPosition);
    
    CGRect hydroRectangle = CGRectMake(currentPosition, top, currentHydroPercentage*remainingWidth, height);
    currentPosition += currentHydroPercentage*remainingWidth;
    CGContextAddRect(context, hydroRectangle);
    UIColor * darkBlueColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.3 alpha:1.0];
    UIColor * lightBlueColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.7 alpha:1.0];
    drawLinearGradient(context, hydroRectangle, lightBlueColor.CGColor, darkBlueColor.CGColor);
    
    CGRect geothermalRectangle = CGRectMake(currentPosition, top, currentGeothermalPercentage*remainingWidth, height);
    currentPosition += currentGeothermalPercentage*remainingWidth;
    CGContextAddRect(context, geothermalRectangle);
    UIColor * darkEarthyColor = [UIColor colorWithRed:0.25 green:0.1 blue:0.05 alpha:1.0];
    UIColor * lightEarthyColor = [UIColor colorWithRed:0.5 green:0.25 blue:0.1 alpha:1.0];
    drawLinearGradient(context, geothermalRectangle, lightEarthyColor.CGColor, darkEarthyColor.CGColor);
    
    CGRect windRectangle = CGRectMake(currentPosition, top, currentWindPercentage*remainingWidth, height);
    currentPosition += currentWindPercentage*remainingWidth;
    CGContextAddRect(context, windRectangle);
    UIColor * darkWindyColor = [UIColor colorWithRed:0.0 green:0.4 blue:0.4 alpha:1.0];
    UIColor * lightWindyColor = [UIColor colorWithRed:0.0 green:0.9 blue:0.9 alpha:1.0];
    drawLinearGradient(context, windRectangle, lightWindyColor.CGColor, darkWindyColor.CGColor);
    
    NSLog(@"Solar percentage is %f", currentSolarPercentage);
    CGRect solarRectangle = CGRectMake(currentPosition, top, currentSolarPercentage*remainingWidth, height);
    currentPosition += currentSolarPercentage*remainingWidth;
    CGContextAddRect(context, solarRectangle);
    UIColor * darkYellowColor = [UIColor colorWithRed:0.5 green:0.4 blue:0.0 alpha:1.0];
    UIColor * lightYellowColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.0 alpha:1.0];
    drawLinearGradient(context, solarRectangle, lightYellowColor.CGColor, darkYellowColor.CGColor);
    
    CGRect biomassRectangle = CGRectMake(currentPosition, top, currentBiomassPercentage*remainingWidth, height);
    currentPosition += currentBiomassPercentage*remainingWidth;
    CGContextAddRect(context, biomassRectangle);
    UIColor * darkBiomassColor = [UIColor colorWithRed:0.0 green:0.2 blue:0.0 alpha:1.0];
    UIColor * lightBiomassColor = [UIColor colorWithRed:0.0 green:0.6 blue:0.0 alpha:1.0];
    drawLinearGradient(context, biomassRectangle, lightBiomassColor.CGColor, darkBiomassColor.CGColor);
    
    NSLog(@"Other percentage is %f", currentOtherPercentage);
    CGRect otherFossilRectangle = CGRectMake(currentPosition, top, currentOtherPercentage*remainingWidth, height);
    currentPosition += currentOtherPercentage*remainingWidth;
    CGContextAddRect(context, otherFossilRectangle);
    UIColor * darkPurpleColor = [UIColor colorWithRed:0.4 green:0.0 blue:0.4 alpha:1.0];
    UIColor * lightPurpleColor = [UIColor colorWithRed:0.9 green:0.0 blue:0.9 alpha:1.0];
    drawLinearGradient(context, otherFossilRectangle, lightPurpleColor.CGColor, darkPurpleColor.CGColor);
    
    NSLog(@"Current drawing position is %f", currentPosition);
    
    NSLog(@"startCharge: %f, currentCharge: %f, currentCoal: %f, currentOil: %f, currentGas: %f, currentNuclear, %f, currentHydro: %f, currentRenewable: %f, currentOther: %f, currentGeothermal: %f, currentWind: %f, currentSolar: %f, currentBiomass: %f, currentBiogas: %f, unknown: %f", startCharge, currentCharge, currentCoalPercentage, currentOilPercentage, currentGasPercentage, currentNuclearPercentage, currentHydroPercentage, currentRenewablePercentage, currentOtherPercentage, currentGeothermalPercentage, currentWindPercentage, currentSolarPercentage, currentBiomassPercentage, currentBiogasPercentage, unknownPercentage);
}

//Adds previous charge and current charge when unplugged
- (void) concatDistributions
{
    float currentCharge = [[UIDevice currentDevice] batteryLevel];
    
    //alerts for debugging
    /*UIAlertView *statsAlert = [[UIAlertView alloc] initWithTitle:@"Stats" message:[NSString stringWithFormat:@"startCharge: %f, currentCharge: %f, currentCoal: %f, currentOil: %f, currentGas: %f, currentNuclear, %f, currentHydro: %f, currentRenewable: %f, currentOther: %f, currentGeothermal: %f, currentWind: %f, currentSolar: %f, currentBiomass: %f, currentBiogas: %f", startCharge, currentCharge, currentCoalPercentage, currentOilPercentage, currentGasPercentage, currentNuclearPercentage, currentHydroPercentage, currentRenewablePercentage, currentOtherPercentage, currentGeothermalPercentage, currentWindPercentage, currentSolarPercentage, currentBiomassPercentage, currentBiogasPercentage] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [statsAlert show];
    
    UIAlertView *prevStatsAlert = [[UIAlertView alloc] initWithTitle:@"Stats" message:[NSString stringWithFormat:@"startCharge: %f, currentCharge: %f, prevCoal: %f, prevOil: %f, prevGas: %f, prevNuclear, %f, prevHydro: %f, prevRenewable: %f, prevOther: %f, prevGeothermal: %f, prevWind: %f, prevSolar: %f, prevBiomass: %f, prevBiogas: %f", startCharge, currentCharge, previousCoalPercentage, previousOilPercentage, previousGasPercentage, previousNuclearPercentage, previousHydroPercentage, previousRenewablePercentage, previousOtherPercentage, previousGeothermalPercentage, previousWindPercentage, previousSolarPercentage, previousBiomassPercentage, previousBiogasPercentage] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [prevStatsAlert show];*/
    
    UIAlertView *unknownAlert = [[UIAlertView alloc] initWithTitle:@"unknown charge" message:[NSString stringWithFormat:@"unknown percentage: %f", unknownPercentage] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [unknownAlert show];
    
    UIAlertView *startAlert = [[UIAlertView alloc] initWithTitle:@"start charge" message:[NSString stringWithFormat:@"start charge: %f", startCharge] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [startAlert show];
    
    currentCoalPercentage = (previousCoalPercentage * startCharge + currentCoalPercentage * (currentCharge - startCharge))/currentCharge;
    currentOilPercentage = (previousOilPercentage * startCharge + currentOilPercentage * (currentCharge - startCharge))/currentCharge;
    currentGasPercentage = (previousGasPercentage * startCharge + currentGasPercentage * (currentCharge - startCharge))/currentCharge;
    currentNuclearPercentage = (previousNuclearPercentage * startCharge + currentNuclearPercentage * (currentCharge - startCharge))/currentCharge;
    currentHydroPercentage = (previousHydroPercentage * startCharge + currentHydroPercentage * (currentCharge - startCharge))/currentCharge;
    currentRenewablePercentage = (previousRenewablePercentage * startCharge + currentRenewablePercentage * (currentCharge - startCharge))/currentCharge;
    currentOtherPercentage = (previousOtherPercentage * startCharge + currentOtherPercentage * (currentCharge - startCharge))/currentCharge;
    currentGeothermalPercentage = (previousGeothermalPercentage * startCharge + currentGeothermalPercentage * (currentCharge - startCharge))/currentCharge;
    currentWindPercentage = (previousWindPercentage * startCharge + currentWindPercentage * (currentCharge - startCharge))/currentCharge;
    currentSolarPercentage = (previousSolarPercentage * startCharge + currentSolarPercentage * (currentCharge - startCharge))/currentCharge;
    currentBiomassPercentage = (previousBiomassPercentage * startCharge + currentBiomassPercentage * (currentCharge - startCharge))/currentCharge;
    currentBiogasPercentage = (previousBiogasPercentage * startCharge + currentBiogasPercentage * (currentCharge - startCharge))/currentCharge;
    unknownPercentage = (unknownPercentage * startCharge) / currentCharge; //never going to increase, ideally should decrease to 0
    
    NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
    [standardUserDefaults setDouble:currentCoalPercentage forKey:@"totalCoal"];
    [standardUserDefaults setDouble:currentOilPercentage forKey:@"totalOil"];
    [standardUserDefaults setDouble:currentGasPercentage forKey:@"totalGas"];
    [standardUserDefaults setDouble:currentNuclearPercentage forKey:@"totalNuclear"];
    [standardUserDefaults setDouble:currentHydroPercentage forKey:@"totalHydro"];
    [standardUserDefaults setDouble:currentRenewablePercentage forKey:@"totalRenewable"];
    [standardUserDefaults setDouble:currentOtherPercentage forKey:@"totalOtherFossil"];
    [standardUserDefaults setDouble:currentGeothermalPercentage forKey:@"totalGeothermal"];
    [standardUserDefaults setDouble:currentGeothermalPercentage forKey:@"totalGeothermal"];
    [standardUserDefaults setDouble:currentWindPercentage forKey:@"totalWind"];
    [standardUserDefaults setDouble:currentSolarPercentage forKey:@"totalSolar"];
    [standardUserDefaults setDouble:currentBiomassPercentage forKey:@"totalBiomass"];
    [standardUserDefaults setDouble:currentBiogasPercentage forKey:@"totalBiogas"];
    [standardUserDefaults setDouble:unknownPercentage forKey:@"unknown"];
    [standardUserDefaults setDouble:currentTotalPercentage forKey:@"total"];
    [standardUserDefaults synchronize];
    
    UIAlertView *newUnknownPercentage = [[UIAlertView alloc] initWithTitle:@"new unknown charge" message:[NSString stringWithFormat:@"new unknown percentage: %f", unknownPercentage] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [newUnknownPercentage show];
    
    NSLog(@"startCharge: %f, currentCharge: %f, currentCoal: %f, currentOil: %f, currentGas: %f, currentNuclear, %f, currentHydro: %f, currentRenewable: %f, currentOther: %f, currentGeothermal: %f, currentWind: %f, currentSolar: %f, currentBiomass: %f, currentBiogas: %f", startCharge, currentCharge, currentCoalPercentage, currentOilPercentage, currentGasPercentage, currentNuclearPercentage, currentHydroPercentage, currentRenewablePercentage, currentOtherPercentage, currentGeothermalPercentage, currentWindPercentage, currentSolarPercentage, currentBiomassPercentage, currentBiogasPercentage);
    

    //done with previous values, so reset for next time
    startCharge = 0.0;
    previousCoalPercentage = currentCoalPercentage;
    previousOilPercentage = currentOilPercentage;
    previousGasPercentage = currentGasPercentage;
    previousNuclearPercentage = currentNuclearPercentage;
    previousHydroPercentage = currentHydroPercentage;
    previousRenewablePercentage = currentRenewablePercentage;
    previousOtherPercentage = currentOtherPercentage;
    previousGeothermalPercentage = currentGeothermalPercentage;
    previousWindPercentage = currentWindPercentage;
    previousSolarPercentage = currentSolarPercentage;
    previousBiomassPercentage = currentBiomassPercentage;
    previousBiogasPercentage = currentBiogasPercentage;
    
    [self setNeedsDisplay];
}


@end
