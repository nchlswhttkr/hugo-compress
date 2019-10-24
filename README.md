# hugo-compress

Compress media files as a build step when using site generator [Hugo](https://gohugo.io).

## Usage

This image currently expects the working directory to be set to the root of your Hugo project, and for your build output to be written to the default `public` directory.

It builds your site with the default `hugo` command, and then compresses JPEG and PNG media files with [mozjpeg](https://github.com/mozilla/mozjpeg) and [pngquant](https://pngquant.org/) respectively.

```sh
docker build -t hugo-compress . < Dockerfile
docker run -v /path/to/site:/src -w /src hugo-compress
```
