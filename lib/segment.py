import pandas as pd

def assign_segments(method, df):
    if method == "single":
            return assign_segments_single(df)
    if method == "uniform":
            return assign_segments_uniform(df)
    else:
            return False

def assign_segments_uniform(df):
    num_segs = 10
    recs = df.shape[1]
    segs = range(num_segs) * (recs / num_segs)
    segs.extend(range(recs - len(segs)))
    df["segment"] = pd.Series(segs)
    return range(num_segs)
            
def assign_segments_single(df):
    df["segment"] = 1 * df.shape[1]
    return pd.unique(df["segment"])
    
def assign_segments_entropy(df):
    num_seg = 100
    df["segment"] = 1 * df.shape[1]
    return pd.unique(df["segment"])