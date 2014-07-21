//
//  detailPage.h
//  ePaisaDemo
//
//  Created by Ashish Pisey on 7/22/14.
//  Copyright (c) 2014 com.lionkingmedia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "MapPoint.h"

#define kGOOGLE_API_KEY @"AIzaSyDPtKZM9XJMG4Sfrc5FFYh4rj_Kz4nInMs"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)


@interface detailPage : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate,
UISearchBarDelegate>
{
    MKUserLocation *currentLocation;
    NSString *searchString;
    CLLocationManager *locationManager;
    CLLocationCoordinate2D currentCentre;
    int currenDist;
    BOOL firstLaunch;
}

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
- (IBAction)backBtnAction:(UIButton *)sender;

@end
