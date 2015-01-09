//
//  QCBellTableViewCell.h
//  QingChunApp
//
//  Created by Peter Lee on 15/1/9.
//  Copyright (c) 2015年 Peter Lee. All rights reserved.
//

#import "BaseTableViewCell.h"

@class QCBellDataModel;

@interface QCBellTableViewCell : BaseTableViewCell

@property (strong, nonatomic) QCBellDataModel *qcbellDataModel;

@end
