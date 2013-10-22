//
//  MRProgressHelper.h
//  MRProgress
//
//  Created by Marius Rackwitz on 14.10.13.
//  Copyright (c) 2013 Marius Rackwitz. All rights reserved.
//


static inline CGRect MRCenterCGSizeInCGRect(CGSize innerRectSize, CGRect outerRect) {
    CGRect innerRect;
    innerRect.size = innerRectSize;
    innerRect.origin.x = outerRect.origin.x + (outerRect.size.width  - innerRectSize.width)  / 2.0f;
    innerRect.origin.y = outerRect.origin.y + (outerRect.size.height - innerRectSize.height) / 2.0f;
    return innerRect;
}
