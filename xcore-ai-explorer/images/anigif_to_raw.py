from PIL import Image
import argparse
import pygame
import numpy


def split_animated_gif(gif_file_path):
    ret = []
    gif = Image.open(gif_file_path)
    for frame_index in range(gif.n_frames):
        gif.seek(frame_index)
        frame_rgba = gif.convert("RGBA")
        pygame_image = pygame.image.fromstring(
            frame_rgba.tobytes(), frame_rgba.size, frame_rgba.mode
        )
        ret.append(pygame_image)
    return ret

def get_still(jpg_file_path):
    jpg = Image.open(jpg_file_path)
    img = jpg.convert("RGB")
    return [img]

def image_to_565data(im):
    pix = numpy.array(im)
    x, y, d = pix.shape
    raw_565 = numpy.zeros((x, y), dtype=numpy.uint16)
    for xc in range(x):
        for yc in range(y):
            r,g,b = list(pix[xc, yc])
            # g = int(g * 0.7)
            # b = int(b * 1.0)
            #Note little endian so upper and lower byte swapped
            raw_565[xc, yc] = ((r & 0xf8) << 0) | ((g & 0xe0) >>  5) | ((g & 0x1c) <<  11) | ((b & 0xf8) << 5)

    return raw_565


def make_h(images, filename):
    frame_num = 0
    num_frames = len(images)
    prefix = filename.split(".")[0]
    string = f"const unsigned {prefix}_num_frames = {num_frames};\n"

    for image in images:
        word_num = 0
        pixels = image_to_565data(image)


        string += f"uint16_t {prefix}_frame_{frame_num}[] = " + "{"
        pixels = pixels.flatten()
        for word in pixels:
            string += f"0x{word:04x}, "
            word_num += 1
            if word_num == 32:
                string += "\n\t\t"
                word_num = 0
        string += "};\n"

        frame_num += 1

        if frame_num == num_frames:
            break

    return string


parser = argparse.ArgumentParser(description='Animated gif to raw')
parser.add_argument("-j", dest='jpg', help='Input jpeg')
parser.add_argument('-g', dest='gif', help='Input animated gif')

parser.add_argument("h_file", help='Output header file')
args = vars(parser.parse_args())


screen_width = 240
screen_height = 240

pygame.init()
screen = pygame.display.set_mode((screen_width,screen_height))


h_file = args['h_file']


if args['gif']:
    images = split_animated_gif(args['gif'])
if args['jpg']:
    images = get_still(args['jpg'])
h_file_text = make_h(images, h_file)
with open(h_file, "wt") as hf:
    hf.write(h_file_text)
