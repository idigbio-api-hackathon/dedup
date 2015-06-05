import pandas as pd

def assign_segments(df):
    num_seg = 100
    df["segment"] = 1 * df.shape[1]
    return pd.unique(df["segment"])
