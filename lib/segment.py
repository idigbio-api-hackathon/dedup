import pandas as pd

def assign_segments(method, df):
    if method == "single":
            return assign_segments_single(df)
    else:
            return False
    
def assign_segments_single(df):
    num_seg = 100
    df["segment"] = 1 * df.shape[1]
    return pd.unique(df["segment"])