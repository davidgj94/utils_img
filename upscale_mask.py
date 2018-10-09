import cv2
from pathlib import Path
from argparse import ArgumentParser
import os.path
import pdb
from math import ceil
from downscale import get_padding
import numpy as np

def make_parser():
    p = ArgumentParser()
    p.add_argument('--path', type=str, required=True)
    p.add_argument('--save_path', type=str, required=True)
    p.add_argument('--max_dim', type=int, required=True)
    return p
    
parser = make_parser()
args = parser.parse_args()
path = Path(args.path)

for glob in path.glob('*'):
    img = cv2.imread(os.path.join(args.path, glob.parts[-1]))
    height, width = img.shape[:2]
    # get padding in x, y axis
    scaling_factor = float(args.max_dim) / 4096
    other_dim = int(round(scaling_factor * 2160))
    x_pad = get_padding(args.max_dim)
    y_pad = get_padding(other_dim)
    # remove padding
    cropped_img = img[y_pad[0]:height-y_pad[1],x_pad[0]:width-x_pad[1],:]
    # upscale cropped image
    up_img = cv2.resize(cropped_img[:,:,0], (4096, 2160), interpolation=cv2.INTER_NEAREST)
    # save downscaled image
    img_name = os.path.splitext(glob.parts[-1])[0]
    cv2.imwrite(os.path.join(args.save_path, '{}.png'.format(img_name)), up_img)
    


