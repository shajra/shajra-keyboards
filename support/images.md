I made my keyboard layout images with [a service](http://www.keyboard-layout-editor.com) that has been un/under-maintained for some years, but keeps on functioning. The image-export feature of this website doesn't meet my satisfaction, so I have the following process, which I haven't automated:

1.  Take a screenshot of the images with my browser zoomed in at 150%.
2.  From the GNU Image Manipulation Program a. Use `Image → Crop to Content` b. `File → Export As…` a PNG
3.  Reduce the filesize with the following ImageMagik command.

```sh
convert image.oversized.png
    -colors 256 \
    -strip \
    -quality 95 \
    -define png:compression-level=9 \
    -define png:compression-strategy=1 \
    image.compressed.png
```

I haven't had the desire to automate this because the process is so tenuous and I have made changes to my keymaps so infrequently. This document is enough for me to retrace my steps.
