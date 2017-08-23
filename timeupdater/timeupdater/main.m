//
//  main.m
//  TimeChange
//
//  Created by ... on 4/13/15.
//  Copyright (c) 2015 .... All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/time.h>
#include <errno.h>

extern int errno;

void NSLogTime(const struct tm *restrict temp, suseconds_t microseconds)
{
    char tmbuf[64], buf[64];
    strftime(tmbuf, sizeof tmbuf, "%Y-%m-%d %H:%M:%S", temp);
    snprintf(buf, sizeof buf, "%s.%06d\n", tmbuf, microseconds);
    NSLog(@"   %@", [[NSString alloc] initWithUTF8String:buf]);
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // Built from samples based on the URL listed below
        // http://stackoverflow.com/questions/2408976/struct-timeval-to-printable-format
        // http://www.linuxquestions.org/questions/programming-9/c-code-to-change-date-time-on-linux-707384/
        
        // Do whatever you need to set the following variable
        // In this example I am hard-coding it
        int month = 8;
        int day = 23;
        int year = 2017;
        
        NSLog(@"Getting current date/time...");
        struct timeval currentTime;
        int success = gettimeofday(&currentTime, 0); // should check for success
        struct tm *localTime = localtime(&currentTime.tv_sec);
        
        NSLogTime(localTime, currentTime.tv_usec);
        
        if (localTime)
        {
            NSLog(@"...create new date/time structure...");
            localTime->tm_mon  = month - 1;
            localTime->tm_mday = day;
            localTime->tm_year = year - 1900;
            
            const struct timeval tv = {mktime(localTime), 0};
            success = settimeofday(&tv, 0);
            
            // check if we are success
            if (success == 0)
            {
                NSLog(@"...time was changed!");
                
                // get the new time from the system and display it
                struct timeval updatedTime;
                gettimeofday(&updatedTime, 0); // should check for success
                NSLogTime(localtime(&updatedTime.tv_sec), updatedTime.tv_usec);
            }
            else
            {
                // display the error message
                NSLog(@"Error Setting Date: %s", strerror(errno));
            }
        }
        
    }
    return 0;
}
