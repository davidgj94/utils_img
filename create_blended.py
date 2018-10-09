from PIL import Image
import sys
import numpy as np
import os
from pathlib import Path
import shutil
import vis
import pdb

png_images_dir = sys.argv[1]
segmentation_class_raw_dir = sys.argv[2]
save_dir = sys.argv[3]

if os.path.exists(save_dir):
    shutil.rmtree(save_dir, ignore_errors=True)
os.makedirs(save_dir)


p = Path(segmentation_class_raw_dir)
#pdb.set_trace()
for glob in p.glob("*.png"):
    img_name = glob.parts[-1]
    #pdb.set_trace()
    sat = np.array(Image.open(png_images_dir + img_name))
    label = np.array(Image.open(segmentation_class_raw_dir + img_name))
    #pdb.set_trace()
    print img_name
    vis_img = Image.fromarray(vis.vis_seg(sat, label, vis.make_palette(3)))
    vis_img.save(os.path.join(save_dir, img_name))
