from fuzzywuzzy import fuzz

def compare(method, x, y):
    if method == "fuzz":
            return compare_fuzz(x, y)
    else:
            return False

def compare_fixed(x, y):
    return 0.1


def compare_fuzz(x, y):
	return fuzz.ratio(x[1]['inst_cat'], y[1]['inst_cat']) 