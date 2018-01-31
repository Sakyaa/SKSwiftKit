//
//  WCDBTool.h
//  GZCanLian
//
//  Created by Sakya on 2017/12/26.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OfflineDownloadAreaModel.h"
#import "PersonalInformationModel.h"
#import "OfflineAreaModel.h"

//表类型
typedef NS_OPTIONS(NSInteger, WCDBTableType) {
    // 离线下载的表
    WCDBTableOfflineDownload = 0,
    //录入用的表
    WCDBTableDataEntry
};
//残疾人信息需要修改的表名
typedef NS_OPTIONS(NSInteger, PersonalInformationChangeType) {
    
    PersonalInfoBasic = 0,///<
    PersonalInfoEducation = 1,///<
    PersonalInfoJobHelpPoor = 2,///<
    PersonalInfoLegalServices = 3,///<
    PersonalInfoEconomyHousing = 4,///<
    PersonalInfoCulturesports = 5,///<
    PersonalInfoSocialsecurity = 6,///<
    PersonalInfoTreatmentrecure = 7,///<
    PersonalInfoSupplementaryQuestion = 8, ///< 补充问题
    PersonalInfoUpdatePersonalId = 9  ///< 补充问题更新用户信息
};


@interface WCDBTool : NSObject
+ (instancetype)shareInstance;
/**
 创建数据库
 @param tableName 表名称
 @return 是否创建成功
 */
- (BOOL)creatDataBaseWithName:(NSString *)tableName;


#pragma mark -- dowm area data

- (BOOL)updateUserAreaData:(NSDictionary *)areaData;
- (NSArray *)selectAreaCode:(NSString *)areaCode;

#pragma mark -- local user area manage data
// 拉取个人的本地区域信息
- (NSArray <OfflineAreaModel *>*)getLocalAraeList;
//删除的时候
- (BOOL)deleteLocalAreaManageWithAreaCode:(NSString *)areaCode;

#pragma mark -- download  user table data
//再下载表的时候是以userid为唯一
- (BOOL)insertDownloadResult:(NSDictionary *)result
                     isExist:(BOOL)isExist
                    areaName:(NSString *)areaName
                    areaCode:(NSString *)areaCode;
- (BOOL)insertUserInfo:(NSArray *)users
               isExist:(BOOL)isExist
              areaCode:(NSString *)areaCode
              areaName:(NSString *)areaName;
//删除所有的用户啊
- (BOOL)deleteAllUsers;
- (NSArray *)searchUserWithYear:(NSString *)year
                         holder:(NSString *)holder
                       finished:(NSString *)finished
                       areaCode:(NSString *)areaCode
                        content:(NSString *)content;
- (NSArray *)searchPageUserWithYear:(NSString *)year
                             holder:(NSString *)holder
                           finished:(NSString *)finished
                           areaCode:(NSString *)areaCode
                            content:(NSString *)content
                           pageSize:(NSInteger)pageSize
                             pageNo:(NSInteger)pageNo;
- (PersonalInformationModel *)searchUserWithPersonalId:(NSString *)personalId;
#pragma mark -- entry user info data
//在录入表的时候是以用户身份证号的为唯一 在第一张表的时候会传身份证号

/**
 用户的基本信息录入 会判断用没有改用户

 @param citizenId 用户的身份证id
 @param infoString 录入的数据
 */
- (void)updataBasicEntryDataCitizenId:(NSString *)citizenId
                           infoString:(NSString *)infoString;
- (void)insertEntryDataCitizenId:(NSString *)citizenId
                      infoString:(NSString *)infoString;

/**
 录入本地数据类型 会判断用户是否存在
 @param type 更新的表
 @param citizenId 用户的身份证id
 @param info 更新的内容
 */
- (void)entryLocalDataType:(PersonalInformationChangeType)type
                 citizenId:(NSString *)citizenId
                      info:(NSString *)info;
//- (BOOL)updateEntryDataType:(PersonalInformationChangeType)type
//                  citizenId:(NSString *)citizenId
//                       info:(NSString *)info;
/**
 查询用户信息
 @param citizenId 用户的身份证id
 @return PersonalInformationModels
 */
- (NSArray *)seleteEntryDataCitizenId:(NSString *)citizenId;

/**
 删除录入表
 @param citizenId 表对用户的身份证id
 */
- (BOOL)deleteEntryDataCitizenId:(NSString *)citizenId;


@end

