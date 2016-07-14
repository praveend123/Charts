//
//  BarChartData.swift
//  Charts
//
//  Created by Daniel Cohen Gindi on 26/2/15.
//
//  Copyright 2015 Daniel Cohen Gindi & Philipp Jahoda
//  A port of MPAndroidChart for iOS
//  Licensed under Apache License 2.0
//
//  https://github.com/danielgindi/Charts
//

import Foundation
import CoreGraphics

public class BarChartData: BarLineScatterCandleBubbleChartData
{
    public override init()
    {
        super.init()
    }
    
    public override init(dataSets: [IChartDataSet]?)
    {
        super.init(dataSets: dataSets)
    }
    
    /// The width of the bars on the x-axis, in values (not pixels)
    ///
    /// **default**: 1.0
    public var barWidth = Double(1.0)
    
    /// Groups all BarDataSet objects this data object holds together by modifying the x-position of their entries.
    /// Leaves space as specified by the parameters.
    /// Do not forget to call notifyDataSetChanged() on your BarChart object after calling this method.
    ///
    /// - parameter the starting point on the x-axis where the grouping should begin
    /// - parameter groupSpace: The space between groups of bars in values (not pixels) e.g. 0.8f for bar width 1f
    /// - parameter barSpace: The space between individual bars in values (not pixels) e.g. 0.1f for bar width 1f
    public func groupBars(fromX fromX: Double, groupSpace: Double, barSpace: Double)
    {
        let setCount = _dataSets.count
        if setCount <= 1
        {
            print("BarData needs to hold at least 2 BarDataSets to allow grouping.", terminator: "\n")
            return
        }
        
        let max = maxEntryCountSet
        let maxEntryCount = max?.entryCount ?? 0
        
        let groupSpaceWidthHalf = groupSpace / 2.0
        let barSpaceHalf = barSpace / 2.0
        let barWidthHalf = self.barWidth / 2.0
        
        var fromX = fromX
        
        let interval = groupWidth(groupSpace: groupSpace, barSpace: barSpace)

        for i in 0.stride(to: maxEntryCount, by: 1)
        {
            let start = fromX
            fromX += groupSpaceWidthHalf
            
            for set in _dataSets as! [IBarChartDataSet]
            {
                fromX += barSpaceHalf
                fromX += barWidthHalf
                
                if i < set.entryCount
                {
                    if let entry = set.entryForIndex(i)
                    {
                        entry.x = fromX
                    }
                }
                
                fromX += barWidthHalf
                fromX += barSpaceHalf
            }
            
            fromX += groupSpaceWidthHalf
            let end = fromX
            let innerInterval = end - start
            let diff = interval - innerInterval
            
            // correct rounding errors
            if diff > 0 || diff < 0
            {
                fromX += diff
            }

        }
        
        notifyDataChanged()
    }
    
    /// In case of grouped bars, this method returns the space an individual group of bar needs on the x-axis.
    ///
    /// - parameter groupSpace:
    /// - parameter barSpace:
    public func groupWidth(groupSpace groupSpace: Double, barSpace: Double) -> Double
    {
        return Double(_dataSets.count) * (self.barWidth + barSpace) + groupSpace
    }
    
}
