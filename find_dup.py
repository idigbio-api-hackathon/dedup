import sys
import pandas as pd
import lib.segment as segment
import lib.dupe as dupe

data_file = sys.argv[1]
seg_method = sys.argv[2]
comp_method = sys.argv[3]

data = pd.read_csv(data_file)
segments = segment.assign_segments(seg_method, data)
i = 0

print "Using", seg_method, "for segmentation of data set."
print "Using", comp_method, "for comparing records."

for s in segments:
    print "comparing segment ", s
    for x in data.loc[data["segment"] == s].iterrows():
        #print "comparing data to id ", x[1]["id"]
        for y in data.loc[data["segment"] == s].iterrows():
            if x[1]["id"] == y[1]["id"]:
                continue
            else:
                score = dupe.compare(comp_method, x, y)
                i = i + 1
                if i > 100:
                    break

#print data.head()
print segments
print i

