import pandas as pd
import lib.segment as segment
import lib.dupe as dupe

data = pd.read_csv("data/occurrence.txt")
segments = segment.assign_segments(data)
i = 0

for s in segments:
    print "comparing segment ", s
    for x in data.loc[data["segment"] == s].iterrows():
        #print "comparing data to id ", x[1]["id"]
        for y in data.loc[data["segment"] == s].iterrows():
            if x[1]["id"] == y[1]["id"]:
                continue
            else:
                score = dupe.compare(x, y)
                i = i + 1

#print data.head()
print segments
print i

