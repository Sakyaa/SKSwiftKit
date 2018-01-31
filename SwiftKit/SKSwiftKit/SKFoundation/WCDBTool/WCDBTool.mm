//
//  WCDBTool.m
//  GZCanLian
//
//  Created by Sakya on 2017/12/26.
//  Copyright © 2017年 Sakya. All rights reserved.
//

#import "WCDBTool.h"
#import <MJExtension/MJExtension.h>
#import "PersonalInformationModel+WCTTableCoding.h"
#import "OfflineAreaModel+WCTTableCoding.h"
#import "OfflineDownloadAreaModel+WCTTableCoding.h"

//录入表
static NSString *const TABLE_ENTRY_DATA = @"tableEntryInformation";
//下载的用户信息表
static NSString *const TABLE_DOWNLOADUSER_DATA = @"tableDownloadUserInformation";
//区域下载用户信息的管理表
static NSString *const TABLE_LOCALAREAMANAGE_DATA = @"tableAreaManageInformation";
//下载所用区域表
static NSString *const TABLE_DOWNLOADAREA_DATA = @"tableDownloadAreaInformation";

@interface WCDBTool() {
    WCTDatabase *database; ///
}
@end
@implementation WCDBTool
+ (instancetype)shareInstance{
    static WCDBTool * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WCDBTool alloc]init];
    });
    return instance;
}
#pragma mark -- creattable
- (BOOL)creatDataBaseWithName:(NSString *)tableName {

    //判断
    [self creatTableWithTableName:tableName];
    // 数据库加密
    //NSData *password = [@"MyPassword" dataUsingEncoding:NSASCIIStringEncoding];
    //[database setCipherKey:password];
    return YES;
}
- (void)creatTableWithTableName:(NSString *)tableName {
    //获取沙盒根目录
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    // 文件路径
    NSString *filePath = [documentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@table.sqlite",tableName]];
    NSLog(@"path = %@",filePath);
    database = [[WCTDatabase alloc]initWithPath:filePath];
    //测试数据库是否能够打开
    if ([database canOpen]) {
        // WCDB大量使用延迟初始化（Lazy initialization）的方式管理对象，因此SQLite连接会在第一次被访问时被打开。开发者不需要手动打开数据库。
        // 先判断表是不是已经存在
        if ([database isOpened]) {
            //录入表
            if ([database isTableExists:TABLE_ENTRY_DATA]) {
                NSLog(@"录入表已经存在");
            } else {
             [database createTableAndIndexesOfName:TABLE_ENTRY_DATA withClass:PersonalInformationModel.class];
            }
            //            离线下载表
            if ([database isTableExists:TABLE_DOWNLOADUSER_DATA]) {
                NSLog(@"下载表已经存在");
            } else {
                 [database createTableAndIndexesOfName:TABLE_DOWNLOADUSER_DATA withClass:PersonalInformationModel.class];
            }
            //      本地保存的地区
            if ([database isTableExists:TABLE_LOCALAREAMANAGE_DATA]) {
                NSLog(@"地区管理表已经存在");
            } else {
                [database createTableAndIndexesOfName:TABLE_LOCALAREAMANAGE_DATA withClass:OfflineAreaModel.class];
            }
            //本地下载的区域信息 很大哦
            if ([database isTableExists:TABLE_DOWNLOADAREA_DATA]) {
                NSLog(@"本地下载的区域信息表已经存在");
            } else {
                [database createTableAndIndexesOfName:TABLE_DOWNLOADAREA_DATA withClass:OfflineDownloadAreaModel.class];
            }
        }
    }
}
#pragma mark --download area
//下载保存区域信息
- (BOOL)updateUserAreaData:(NSDictionary *)areaData {
    NSArray *areas = areaData[@"data"];
    NSArray *downloadAreas = [OfflineDownloadAreaModel mj_objectArrayWithKeyValuesArray:areas];
    [database deleteAllObjectsFromTable:TABLE_DOWNLOADAREA_DATA];
   // WCTDatabase 事务操作，利用WCTTransaction 或 block
    BOOL ret = [database beginTransaction];
    ret = [database insertObjects:downloadAreas into:TABLE_DOWNLOADAREA_DATA];
    if (ret) {
        [database commitTransaction];
    }else
        [database rollbackTransaction];
    
    return ret;
}
//查询父级code下的区域
- (NSArray *)selectAreaCode:(NSString *)areaCode {
    //父类的code
    NSArray<OfflineDownloadAreaModel *> *areas = [database getObjectsOfClass:OfflineDownloadAreaModel.class fromTable:TABLE_DOWNLOADAREA_DATA where:OfflineDownloadAreaModel.parentCode == areaCode];
    return areas == nil ? [NSMutableArray array]  : areas;;
}

#pragma mark -- download area manage
//本地用户已经下载的区域用户信息查询的
- (NSArray <OfflineAreaModel *>*)getLocalAraeList {
    NSArray<OfflineAreaModel *> *areas = [database getObjectsOfClass:OfflineAreaModel.class fromTable:TABLE_LOCALAREAMANAGE_DATA orderBy:OfflineAreaModel.updateTime.order((WCTOrderedDescending))];
    return areas == nil ? [NSMutableArray array]  : areas;
}
- (BOOL)insertAreaListAreaCode:(NSString *)areaCode
                      areaName:(NSString *)areaName
                         count:(NSInteger)count
                    updateTime:(NSDate *)updateTime {

    OfflineAreaModel *areaModel = [[OfflineAreaModel alloc] init];
    areaModel.areaCode = areaCode;
    areaModel.areaName = areaName;
    areaModel.count = count;
    areaModel.updateTime = updateTime;
    [database insertObject:areaModel into:TABLE_LOCALAREAMANAGE_DATA];
    return YES;
}
//更新用户地区的信息了啊
- (BOOL)updateAreaListWithAreaCode:(NSString *)areaCode
                          areaName:(NSString *)areaName
                             count:(NSInteger)count
                        updateTime:(NSDate *)updateTime {
    OfflineAreaModel *areaModel = [[OfflineAreaModel alloc] init];
    areaModel.areaName = areaName;
    areaModel.count = count;
    areaModel.updateTime = updateTime;
    BOOL result = [database updateRowsInTable:TABLE_LOCALAREAMANAGE_DATA onProperties:{OfflineAreaModel.areaName, OfflineAreaModel.count,OfflineAreaModel.updateTime} withObject:areaModel where:PersonalInformationModel.areaCode == areaCode];
    return result;
}
- (BOOL)deleteLocalAreaManageWithAreaCode:(NSString *)areaCode {
    BOOL manageResult =  [database deleteObjectsFromTable:TABLE_LOCALAREAMANAGE_DATA where:OfflineAreaModel.areaCode == areaCode];
    [self deletaUserWithAreaCode:areaCode];
    return manageResult;
}
#pragma mark -- difference download user data
//下载数据
- (BOOL)insertDownloadResult:(NSDictionary *)result
                    isExist:(BOOL)isExist
                    areaName:(NSString *)areaName
                    areaCode:(NSString *)areaCode {
    NSArray *datas = result[@"data"];
    NSArray *users = [PersonalInformationModel mj_objectArrayWithKeyValuesArray:datas];
    if (isExist) {
        //先删除所有的 本地区的数据在增加
        [self deletaUserWithAreaCode:areaCode];
    }
    BOOL resultStatus = [self insertUserInfo:users isExist:isExist areaCode:areaCode areaName:areaName];
    return resultStatus;
}
- (BOOL)insertUserInfo:(NSArray *)users
               isExist:(BOOL)isExist
              areaCode:(NSString *)areaCode
              areaName:(NSString *)areaName {
    NSDate *time = [NSDate date];
    if (isExist) {
        //本地保存的下载列表更新
        [self updateAreaListWithAreaCode:areaCode areaName:areaName count:users.count updateTime:time];
    } else {
        [database runTransaction:^BOOL{
            BOOL ret = [self insertAreaListAreaCode:areaCode areaName:areaName count:users.count updateTime:time];
            if (ret) {
                return YES;
            }else
                return NO;
        } event:^(WCTTransactionEvent event) {
            NSLog(@"Event %d", event);
        }];
    }
    BOOL result = YES;
    if (users.count > 0) {
        [users enumerateObjectsUsingBlock:^(PersonalInformationModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.updateTime = time;
        }];
        result = [database beginTransaction];
        result =  [database insertObjects:users into:TABLE_DOWNLOADUSER_DATA];
        if (result) {
            [database commitTransaction];
        }else {
            [database rollbackTransaction];
        }
    }
    return result;
}
//删除区域数据
- (BOOL)deletaUserWithAreaCode:(NSString *)areaCode {
    BOOL result = [database deleteObjectsFromTable:TABLE_DOWNLOADUSER_DATA where:PersonalInformationModel.areaCode == areaCode];
    return result;
}
- (BOOL)isExistPersonalId:(NSString *)personalId {
    PersonalInformationModel *user = [database getOneObjectOfClass:PersonalInformationModel.class fromTable:TABLE_DOWNLOADUSER_DATA where:PersonalInformationModel.personalId == personalId];
    if (user != nil) return YES;
    return NO;
}
//NSData *classList = [NSKeyedArchiver archivedDataWithRootObject:classArray];
//classArray = [NSKeyedUnarchiver unarchiveObjectWithData:[result dataForColumn:@"classList"]];
//没有分页的啊
- (NSArray *)searchUserWithYear:(NSString *)year
                         holder:(NSString *)holder
                       finished:(NSString *)finished
                       areaCode:(NSString *)areaCode
                        content:(NSString *)content {
    WCTCondition conditions = [self conditionsWithYear:year holder:holder finished:finished areaCode:areaCode content:content];
    NSArray <PersonalInformationModel *> *users = [database getObjectsOfClass:PersonalInformationModel.class
                                                                    fromTable:TABLE_DOWNLOADUSER_DATA where:conditions
                                                                      orderBy:OfflineAreaModel.updateTime.order((WCTOrderedDescending))];
    return users;
}
//带分页的
- (NSArray *)searchPageUserWithYear:(NSString *)year
                             holder:(NSString *)holder
                           finished:(NSString *)finished
                           areaCode:(NSString *)areaCode
                            content:(NSString *)content
                           pageSize:(NSInteger)pageSize
                             pageNo:(NSInteger)pageNo {
    
    //LIMIT 4 OFFSET 3指示MySQL等DBMS返回从第3行（从0行计数）起的4行数据。第一个数字是检索的行数，第二个数字是指从哪儿开始。 20 1
    WCTCondition conditions = [self conditionsWithYear:year holder:holder finished:finished areaCode:areaCode content:content];
    NSInteger offset = pageSize * pageNo;
    NSArray <PersonalInformationModel *> *users = [database getObjectsOfClass:PersonalInformationModel.class
                                                                    fromTable:TABLE_DOWNLOADUSER_DATA where:conditions
                                                                      orderBy:OfflineAreaModel.updateTime.order((WCTOrderedDescending))
                                                                        limit:pageSize
                                                                       offset:offset];
    return users;
}
- (WCTCondition)conditionsWithYear:(NSString *)year
                              holder:(NSString *)holder
                            finished:(NSString *)finished
                            areaCode:(NSString *)areaCode
                             content:(NSString *)content {
    NSString *conditionContent = [NSString stringWithFormat:@"%%%@%%",content];
    //    持证状态的修改
    BOOL conditionHolder = NO;
    if ([holder isEqualToString:@"1"]){ conditionHolder = YES;}
    //code 规则 52 00 00 000 000
    NSString *conditionAreaCode;
    if ([areaCode hasSuffix:@"0000000000"]) {
        conditionAreaCode = [NSString stringWithFormat:@"%@%%",[areaCode substringToIndex:2]];
    } else if ([areaCode hasSuffix:@"00000000"]) {
        conditionAreaCode = [NSString stringWithFormat:@"%@%%",[areaCode substringToIndex:4]];
    } else if ([areaCode hasSuffix:@"000000"]) {
        conditionAreaCode = [NSString stringWithFormat:@"%@%%",[areaCode substringToIndex:6]];
    }  else if ([areaCode hasSuffix:@"000"]) {
        conditionAreaCode = [NSString stringWithFormat:@"%@%%",[areaCode substringToIndex:9]];
    } else {
        conditionAreaCode = [NSString stringWithFormat:@"%@",areaCode];
    }
    WCTCondition conditions =
    (PersonalInformationModel.year == year) &&
    PersonalInformationModel.areaCode.like(conditionAreaCode) &&
    ([finished isEqualToString:@"0"] ? PersonalInformationModel.finished.isNotNull() : PersonalInformationModel.finished == finished) &&
    ([holder isEqualToString:@"3"] ? PersonalInformationModel.holder.isNotNull() : PersonalInformationModel.holder == holder) &&
    (content == nil ? PersonalInformationModel.name.isNotNull() : (PersonalInformationModel.name.like(conditionContent)||PersonalInformationModel.idcard.like(conditionContent)));
    return conditions;
}
//精确查找的通过personalid查找
- (PersonalInformationModel *)searchUserWithPersonalId:(NSString *)personalId {
    PersonalInformationModel *user = [database getOneObjectOfClass:PersonalInformationModel.class fromTable:TABLE_DOWNLOADUSER_DATA where:PersonalInformationModel.personalId == personalId];
    return user;
}
- (BOOL)deleteAllUsers {
    return NO;
}

#pragma mark -- entryTable
- (void)entryLocalDataType:(PersonalInformationChangeType)type
                 citizenId:(NSString *)citizenId
                      info:(NSString *)info {

    
    
}
- (void)updataBasicEntryDataCitizenId:(NSString *)citizenId
                           infoString:(NSString *)infoString {
    //先判断是否表中已经存在这个记录如果存在就替换
    NSArray<PersonalInformationModel *> * informations = [database getObjectsOfClass:PersonalInformationModel.class fromTable:TABLE_ENTRY_DATA where:PersonalInformationModel.personalId == citizenId];
    if (informations.count > 0) {
        //更新
//        [self updateEntryDataType:PersonalInfoBasic citizenId:citizenId info:infoString];
        
    } else {
        [self insertEntryDataCitizenId:citizenId infoString:infoString];
    }
}
- (void)insertEntryDataCitizenId:(NSString *)citizenId
                      infoString:(NSString *)infoString {
    
    PersonalInformationModel *informationModel = [[PersonalInformationModel alloc] init];
    //插入
//    informationModel.createTime = [NSDate date];
//    PersonalBasicInformationModel *basicModel = [[PersonalBasicInformationModel alloc] init];
//    basicModel.name = @"hello basic wcdb";
    //    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:basicModel];
    //classArray = [NSKeyedUnarchiver unarchiveObjectWithData:[result dataForColumn:@"classList"]];
    //    informationModel.personalBasicInformation = basicModel;
    /*
     INSERT INTO message(localID, content, createTime, modifiedTime)
     VALUES(1, "Hello, WCDB!", 1496396165, 1496396165);
     */
    [database insertObject:informationModel  into:TABLE_ENTRY_DATA];
}
//更新失败则可能用户不存在
    /**
- (BOOL)updateEntryDataType:(PersonalInformationChangeType)type
                     citizenId:(NSString *)citizenId
                       info:(NSString *)info {
    PersonalInformationModel *informationModel = [[PersonalInformationModel alloc] init];
//    (const WCTCondition &)condition
    WCTCondition condition = PersonalInformationModel.personalId == citizenId || PersonalInformationModel.userId == citizenId;
    switch (type) {
        case PersonalInfoBasic:
            informationModel.personalBasicInformation = info;
            return [database updateRowsInTable:TABLE_ENTRY_DATA onProperty:PersonalInformationModel.personalBasicInformation withObject:informationModel where:condition];
        case PersonalInfoEducation:
            informationModel.educationInformation = info;
            return [database updateRowsInTable:TABLE_ENTRY_DATA onProperty:PersonalInformationModel.educationInformation withObject:informationModel where:condition];
        case PersonalInfoJobHelpPoor:
            informationModel.jobHelpPoorInformation = info;
            return [database updateRowsInTable:TABLE_ENTRY_DATA onProperty:PersonalInformationModel.jobHelpPoorInformation withObject:informationModel where:condition];
            break;
        case PersonalInfoLegalServices:
            informationModel.legalServicesInformation = info;
            return [database updateRowsInTable:TABLE_ENTRY_DATA onProperty:PersonalInformationModel.legalServicesInformation withObject:informationModel where:condition];
            break;
        case PersonalInfoEconomyHousing:
            informationModel.economyHousingInformation = info;
            return [database updateRowsInTable:TABLE_ENTRY_DATA onProperty:PersonalInformationModel.economyHousingInformation withObject:informationModel where:condition];
            break;
        case PersonalInfoCulturesports:
            informationModel.cultureSportsInformation = info;
            return [database updateRowsInTable:TABLE_ENTRY_DATA onProperty:PersonalInformationModel.cultureSportsInformation withObject:informationModel where:condition];
            break;
        case PersonalInfoSocialsecurity:
            informationModel.socialSecurityInformation = info;
            return [database updateRowsInTable:TABLE_ENTRY_DATA onProperty:PersonalInformationModel.socialSecurityInformation withObject:informationModel where:condition];
            break;
        case PersonalInfoTreatmentrecure:
            informationModel.treatmentRecureInformation = info;
            return [database updateRowsInTable:TABLE_ENTRY_DATA onProperty:PersonalInformationModel.treatmentRecureInformation withObject:informationModel where:condition];
        case PersonalInfoSupplementaryQuestion:
            informationModel.supplementaryQuestion = info;
            return [database updateRowsInTable:TABLE_ENTRY_DATA onProperty:PersonalInformationModel.supplementaryQuestion withObject:informationModel where:condition];
        case PersonalInfoUpdatePersonalId:
            informationModel.userId = info;
            return [database updateRowsInTable:TABLE_ENTRY_DATA onProperty:PersonalInformationModel.userId withObject:informationModel where:condition];
        default:
            return NO;
    }

}
     */
- (NSArray *)seleteEntryDataCitizenId:(NSString *)citizenId {
    
    //SELECT * FROM message ORDER BY localID
    NSArray<PersonalInformationModel *> *information = [database getObjectsOfClass:PersonalInformationModel.class fromTable:TABLE_ENTRY_DATA where:PersonalInformationModel.personalId == citizenId||PersonalInformationModel.personalId == citizenId];
    return information;
}

- (BOOL)deleteEntryDataCitizenId:(NSString *)citizenId {
    //删除
    //DELETE FROM message WHERE localID>0;
    return [database deleteObjectsFromTable:TABLE_ENTRY_DATA where:PersonalInformationModel.personalId == citizenId];
}
@end




