//
//  IPAddress.h
//  Unity-iPhone
//
//  Created by jiangtao on 2016/8/11.
//
//

#ifndef IPAddress_h
#define IPAddress_h


#endif /* IPAddress_h */
#define MAXADDRS 32

extern char *if_names[MAXADDRS];
extern char *ip_names[MAXADDRS];
extern char *hw_addrs[MAXADDRS];
extern unsigned long ip_addrs[MAXADDRS];

// Function prototypes

void InitAddresses();
void FreeAddresses();
void GetIPAddresses();
void GetHWAddresses();