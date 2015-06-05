import sys
import pandas as pd
import lib.segment as segment
import lib.dupe as dupe

data_file = sys.argv[1]
seg_method = sys.argv[2]
comp_method = sys.argv[3]

data = pd.read_csv(data_file)
segments = segment.assign_segments(seg_method, data)

print "Using", seg_method, "for segmentation of data set."
print "Using", comp_method, "for comparing records."

i = 0
d = 0
results = []
for s in segments:
    print "comparing segment ", s
    for x in data.loc[data["segment"] == s].iterrows():
        #print "comparing data to id ", x[1]["id"]
        for y in data.loc[data["segment"] == s].iterrows():
            if x[1]["key"] == y[1]["key"]:
                continue
            else:
                i = i + 1
                score = dupe.compare(comp_method, x, y)
                if score > 0.8:
                    d = d + 1
                results.append({"id_x":x[1]["id"], "id_y":y[1]["id"], "score":score})
                
results_df = pd.DataFrame(results)
results_df.to_csv("output/results.csv")

print "Compared", i, "records."
print "Found", d , "possible duplicates."

