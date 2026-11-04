"""Renders the images the Chrome Web Store and AMO listings ask for, from the 128 px icon.
Usage: python3 make-store-assets.py <out-dir>"""
import sys, os
from PIL import Image, ImageDraw, ImageFont
out = sys.argv[1]; os.makedirs(out, exist_ok=True)
BG, FG, DIM, ACCENT = (24, 24, 27), (245, 245, 247), (160, 160, 170), (99, 102, 241)
FONT = '/System/Library/Fonts/Helvetica.ttc'
def font(size, bold=False): return ImageFont.truetype(FONT, size, index=1 if bold else 0)
icon = Image.open('icons/128.png').convert('RGBA')
def canvas(w, h): return Image.new('RGB', (w, h), BG)
def paste_icon(im, size, xy):
    i = icon.resize((size, size), Image.LANCZOS); im.paste(i, xy, i)

im = canvas(1280, 800); d = ImageDraw.Draw(im)
paste_icon(im, 160, (120, 120))
d.text((320, 130), 'Send to Stash Video', font=font(64, True), fill=FG)
d.text((320, 215), 'One click sends the page you are on to Stash Video.', font=font(30), fill=DIM)
y = 380
for n, t in (('1', 'Open any video page'), ('2', 'Click the toolbar button'), ('3', 'Stash Video opens with the link filled in and analyzed')):
    d.ellipse((120, y, 176, y + 56), fill=ACCENT); d.text((148, y + 28), n, font=font(28, True), fill=FG, anchor='mm')
    d.text((210, y + 28), t, font=font(34), fill=FG, anchor='lm'); y += 110
d.text((120, 730), 'Needs Stash Video for macOS or Windows  ·  by Ayala Solutions', font=font(24), fill=DIM)
im.save(f'{out}/screenshot-1280x800.png')

for w, h, isz, fs in ((440, 280, 120, 34), (1400, 560, 300, 72)):
    im = canvas(w, h); d = ImageDraw.Draw(im)
    paste_icon(im, isz, (w // 2 - isz // 2, h // 2 - isz // 2 - fs))
    d.text((w // 2, h // 2 + isz // 2 + 10), 'Send to Stash Video', font=font(fs, True), fill=FG, anchor='mm')
    im.save(f'{out}/promo-{w}x{h}.png')
print('store assets written to', out)
