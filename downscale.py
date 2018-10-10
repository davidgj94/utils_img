import cv2
from pathlib import Path
from argparse import ArgumentParser
import os.path
import pdb
from math import ceil
import shutil

def make_parser():
    p = ArgumentParser()
    p.add_argument('--path', type=str, required=True)
    p.add_argument('--save_path', type=str, required=True)
    p.add_argument('--max_dim', type=int, required=True)
    p.add_argument('--output_format', type=str, required=True)
    p.add_argument('-m', dest='is_mask', action='store_true')
    p.set_defaults(antialias=False)
    return p

def get_padding(sz):
    
    pad_amount = int(ceil(float(sz) / 32) * 32 - sz)
    
    if pad_amount % 2:
        
        padding = (pad_amount / 2 , pad_amount - pad_amount / 2)
    else:
        padding = (pad_amount / 2, pad_amount / 2)
        
    return padding

if __name__ == "__main__":
    
    parser = make_parser()
    args = parser.parse_args()

    if os.path.exists(args.save_path):
        shutil.rmtree(args.save_path, ignore_errors=True)
    os.makedirs(args.save_path)

    path = Path(args.path)

    for glob in path.glob('*'):
        img = cv2.imread(os.path.join(args.path, glob.parts[-1]))
        height, width = img.shape[:2]
        # only shrink if img is bigger than required
        if args.max_dim < height or args.max_dim < width:
            # get scaling factor
            scaling_factor = args.max_dim / float(height)
            if args.max_dim/float(width) < scaling_factor:
                scaling_factor = args.max_dim / float(width)
        # resize image
        if not args.is_mask:
            down_img = cv2.resize(img, None, fx=scaling_factor, fy=scaling_factor, interpolation=cv2.INTER_AREA)
        else:
            down_img = cv2.resize(img[:,:,0], None, fx=scaling_factor, fy=scaling_factor, interpolation=cv2.INTER_NEAREST)
        # pad image so that its dimension are multiple of 32
        new_height, new_width = down_img.shape[:2]
        x_pad = get_padding(new_width)
        y_pad = get_padding(new_height)
        down_img_padded = cv2.copyMakeBorder(down_img, y_pad[0], y_pad[1], x_pad[0], x_pad[1], cv2.BORDER_CONSTANT, value=[0, 0, 0])
        # save downscaled image
        img_name = os.path.splitext(glob.parts[-1])[0]
        cv2.imwrite(os.path.join(args.save_path, '{}.{}'.format(img_name, args.output_format)), down_img_padded)
    


