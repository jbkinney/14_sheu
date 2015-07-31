% Format:
% short_name, smoothing_window_in_kb, min_height, max_width, end_clip_in_kb, display_name

annotations = {...
'A4', 1.0, 0.10, 20, 0, '{\it MCM4 }';
'B4', 1.0, 0.10, 20, 0, '{\it mcm4 }^{{\Delta}74-174}';
'C4', 1.0, 0.10, 20, 0, '{\it sld3 38A }';
'D4', 1.0, 0.10, 20, 0, '{\it sld3 38A mcm4 }^{{\Delta}74-174}';
'E4', 1.0, 0.10, 20, 0, '{\it dbf4 19A }';
'F4', 1.0, 0.10, 20, 0, '{\it dbf4 19A mcm4 }^{{\Delta}74-174}';
'G4', 1.0, 0.10, 20, 0, '{\it sld3 38A dbf4 19A }';
'H4', 1.0, 0.10, 20, 0, '{\it sld3 38A dbf4 19A mcm4 }^{{\Delta}74-174}'; 

'A5', 1.0, 0.30, 12, 0, 'wt';
'B5', 1.0, 0.30, 12, 0, '{\it mcm4 }^{{\Delta}74{\rm-}174}';
'C5', 1.0, 0.30, 12, 0, '{\it sld3 38A}';
'D5', 1.0, 0.30, 12, 0, '{\it sld3 38A} {\it mcm4 }^{{\Delta}74{\rm-}174}';
'E5', 1.0, 0.30, 12, 0, '{\it dbf4 19A}';
'F5', 1.0, 0.30, 12, 0, '{\it dbf4 19A} {\it mcm4 }^{{\Delta}74{\rm-}174}';
'G5', 1.0, 0.30, 12, 0, '{\it dbf4 19A} {\it sld3 38A}';
'H5', 1.0, 0.30, 12, 0, '{\it dbf4 19A} {\it sld3 38A} {\it mcm4 }^{{\Delta}74{\rm-}174}';  

'A6', 1.0, 0.30, 15, 0, 'WT S25';
'B6', 1.0, 0.30, 15, 0, '{\it mcm4 }^{{\Delta}2{\rm-}145} S25';
'C6', 1.0, 0.30, 15, 0, '{\it mcm4 }^{{\Delta}2{\rm-}174} S25';
'D6', 1.0, 0.30, 15, 0, '{\it mcm4 }^{{\Delta}74{\rm-}174} S25';
'E6', 1.0, 0.30, 15, 0, '{\it mcm4 }^{{\Delta}74{\rm-}174, CDK4A} S25';
'F6', 1.0, 0.30, 15, 0, '{\it mcm4 }^{{\Delta}74{\rm-}174, CDK4D} S25';
'G6', 0.5, 0.10, 12, 0, 'WT HU25';
'H6', 0.5, 0.10, 12, 0, 'WT HU50';
'I6', 0.5, 0.10, 12, 0, 'WT HU75';
'J6', 0.5, 0.10, 12, 0, '{\it sld3} 38A{\it dbf4} 19A {\it mcm4 }^{{\Delta}74{\rm-}174} HU25';
'K6', 0.5, 0.10, 12, 0, '{\it sld3} 38A{\it dbf4} 19A {\it mcm4 }^{{\Delta}74{\rm-}174} HU50';
'L6', 0.5, 0.10, 12, 0, '{\it sld3} 38A{\it dbf4} 19A {\it mcm4 }^{{\Delta}74{\rm-}174} HU75';    

'A7', 1.0, 0.30, 35, 0, 'WT';
'B7', 1.0, 0.30, 35, 0, '{\it mcm4 }^{{\Delta}74{\rm-}174}';
'C7', 1.0, 0.30, 35, 0, '{\it sld3} 38A';
'D7', 1.0, 0.30, 35, 0, '{\it mcm4 }^{{\Delta}74{\rm-}174} {\it sld3} 38A';
'E7', 1.0, 0.30, 35, 0, '{\it mcm4 }^{{\Delta}74{\rm-}174, CDK4A} {\it sld3} 38A';
'F7', 1.0, 0.30, 35, 0, '{\it mcm4 }^{{\Delta}2{\rm-}145}';
'G7', 1.0, 0.30, 35, 0, '{\it mcm4 }^{{\Delta}2{\rm-}145} {\it sld3} 38A';
'H7', 2.0, 0.30, 35, 0, 'WT';
'I7', 1.0, 0.30, 35, 0, '{\it mcm4 }^{{\Delta}74{\rm-}174} {\it dbf4} 19A {\it sld3} 38A';
'J7', 2.0, 0.30, 35, 0, '{\it sml1\Delta::HIS3}';
'K7', 2.0, 0.30, 35, 0, '{\it mec1\Delta::TRP1}{\it sml1\Delta::HIS3}';
'L7', 2.0, 0.30, 35, 0, '{\it rad53\Delta::KanMX}{\it sml1\Delta::HIS3}';

'H7_c', 2.0, 0.30, 35, 30, 'WT';
'I7_c', 1.0, 0.30, 35, 30, '{\it mcm4 }^{{\Delta}74{\rm-}174} {\it dbf4} 19A {\it sld3} 38A';
'J7_c', 2.0, 0.30, 35, 30, '{\it sml1\Delta::HIS3}';
'K7_c', 2.0, 0.30, 35, 30, '{\it mec1\Delta::TRP1}{\it sml1\Delta::HIS3}';
'L7_c', 2.0, 0.30, 35, 30, '{\it rad53\Delta::KanMX}{\it sml1\Delta::HIS3}';  

'A8', 0.5, 0.10, 12, 0, '{\it dbf4} 19A {\it sld3} 38A HU25';
'B8', 0.5, 0.10, 12, 0, '{\it dbf4} 19A {\it sld3} 38A HU50';
'C8', 0.5, 0.10, 12, 0, '{\it dbf4} 19A {\it sld3} 38A HU75';
'D8', 0.5, 0.10, 12, 0, '{\it mcm4 }^{{\Delta}7{\rm-}174} {\it dbf4} 19A {\it sld3} 38A HU25';
'E8', 0.5, 0.10, 12, 0, '{\it mcm4 }^{{\Delta}7{\rm-}174} {\it dbf4} 19A {\it sld3} 38A HU50';
'F8', 0.5, 0.10, 12, 0, '{\it mcm4 }^{{\Delta}7{\rm-}174} {\it dbf4} 19A {\it sld3} 38A HU75';
'I8', 2.0, 0.30, 40, 0, '{\it MCM4 }';
'J8', 2.0, 0.30, 40, 0, '{\it mcm4 }^{{\Delta}2{\rm-}145}';
'K8', 2.0, 0.30, 40, 0, '{\it mcm4 }^{{\Delta}2{\rm-}174}';
'L8', 2.0, 0.30, 40, 0, '{\it mcm4 }^{{\Delta}74{\rm-}174}';
'M8', 2.0, 0.30, 40, 0, '{\it mcm4 }^{{\Delta}74{\rm-}174, 4(SP \rightarrow {AP})}';
'N8', 2.0, 0.30, 40, 0, '{\it mcm4 }^{{\Delta}74{\rm-}174, 4(SP \rightarrow {DP})}';

'A10', 2.0, 0.30, 40, 0, 'WT';
'B10', 2.0, 0.30, 40, 0, '{\it mcm4 }^{{\Delta}74{\rm-}174}';
'C10', 2.0, 0.30, 40, 0, '{\it sld3} 38A';
'D10', 2.0, 0.30, 40, 0, '{\it mcm4 }^{{\Delta}74{\rm-}174} {\it sld3} 38A';
'E10', 2.0, 0.30, 40, 0, '{\it dbf4} 19A';
'F10', 2.0, 0.30, 40, 0, '{\it mcm4 }^{{\Delta}74{\rm-}174} {\it dbf4} 19A';
'G10', 2.0, 0.30, 40, 0, '{\it dbf4} 19A {\it sld3} 38A';
'H10', 2.0, 0.30, 40, 0, '{\it mcm4 }^{{\Delta}74{\rm-}174} {\it dbf4} 19A {\it sld3} 38A'; 
};