"""In this example we plot a record's annotations on top of the curve of the
local GC content in the record's sequence.

BASED ON
example in https://github.com/Edinburgh-Genome-Foundry/DnaFeaturesViewer/blob/master/examples/with_gc_plot.py
@Author @lonelyjoeparker
@Date 2024-02-07

USAGE:
    record = SeqIO.read("example_sequence.gb", "genbank")
    translator = BiopythonTranslator()
    graphic_record = translator.translate_record(record)

    fig, (ax1, ax2, ax3) = plt.subplots(
        3, 1, figsize=(10, 3), sharex=True, gridspec_kw={"height_ratios": [4, 1, 1]}
    )
    graphic_record.plot(ax=ax1, with_ruler=False, strand_in_label_threshold=4)
    plot_local_gc_content(record, window_size=50, ax=ax2)
    plot_depth_content(record, window_size=50, ax=ax3, depthfile='example_coverage_data.tdf')

    fig.tight_layout()  # Resize the figure to the right height
    fig.savefig("with_gc_plot2.png")

"""
import matplotlib.pyplot as plt
from dna_features_viewer import BiopythonTranslator
from Bio import SeqIO
import numpy as np
import pandas as pd


def plot_local_gc_content(record, window_size, ax):
    """Plot windowed GC content on a designated Matplotlib ax."""
    def gc_content(s):
        return 100.0 * len([c for c in s if c in "GC"]) / len(s)

    yy = [
        gc_content(record.seq[i : i + window_size])
        for i in range(len(record.seq) - window_size)
    ]
    xx = np.arange(len(record.seq) - window_size) + 25
    ax.fill_between(xx, yy, alpha=0.3)
    ax.set_ylim(bottom=0)
    ax.set_ylabel("GC(%)")

def plot_depth_content(record, window_size, ax, depthfile):
    """Plot dummy content on a designated Matplotlib ax."""
    # 'example_coverage_data.tdf' example file
    df = pd.read_csv(depthfile,sep="\t",header=None,names=('chromosome','pos','depth'))
    """
    # these lines would print each position inthe depth file, depth only (we've set the headers in the names() arg to read_csv above)
    for line in df.depth:
        print(line.depth)
    """

    xx = np.arange(len(record.seq) - window_size) + 25
    yy = df.depth[1:(len(xx)+1)]
    ax.fill_between(xx, yy, alpha=0.3)
    ax.set_ylim(bottom=0)
    ax.set_ylabel("DEPTH")
