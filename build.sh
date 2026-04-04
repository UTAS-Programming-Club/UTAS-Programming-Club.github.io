#!/bin/sh

# TODO: Try to remove any html tags from markdown code
# TODO: Add heading self anchors

# Currently setup.sh only fetches pandoc and magick, should it download cosmo execs like on windows if somehow missing?
if [ ! -f bin/pandoc ] || [ ! -f bin/magick ] || ! command -v cp           >/dev/null || ! command -v date  >/dev/null\
  || ! command -v dirname >/dev/null          || ! command -v git"$GITEXT" >/dev/null || ! command -v mkdir >/dev/null\
  || ! command -v rm      >/dev/null          || ! command -v sed          >/dev/null || ! command -v xargs >/dev/null ; then
  if [ "$OS" = Windows_NT ]; then
    SETUPEXT=.bat
  else
    SETUPEXT=.sh
  fi
  printf "Required binaries are missing, please run setup%s to acquire them\n" $SETUPEXT
  exit 1
fi

PAGES="index projects events about tools websiteabout"

PANDOC_VERSION=$(bin/pandoc -v | sed -n 's/^pandoc //p' | sed "s/$(printf '\r')//")
MAGICK_VERSION=$(bin/magick --version | sed -n 's/^Version: ImageMagick \([[:digit:]]\{1,\}\.[[:digit:]]\{1,\}\.[[:digit:]]\{1,\}-[[:digit:]]\{1,\}\).*/\1/p')

BUILD_TIME=$(date "+%Y-%m-%dT%T")$(. ./gettimezone.sh)
BUILD_COMMIT=$(git"$GITEXT" show -s --format=%H)
BUILD_COMMIT_AUTHORS=$(git"$GITEXT" show -s --format=%an)" "\($(git"$GITEXT" show -s --format=%ae)\)
BUILD_COMMIT_COMMITTER=$(git"$GITEXT" show -s --format=%cn)" "\($(git"$GITEXT" show -s --format=%ce)\)
BUILD_COMMIT_TIME=$(git"$GITEXT" show -s --format=%cI)
#TODO: Make a link if the branch has a remote
#TODO: Report if any local changes have occurred since last commit
BUILD_COMMIT_BRANCH=$(git"$GITEXT" rev-parse --abbrev-ref HEAD)

if [ "$BUILD_COMMIT_AUTHORS" != "$BUILD_COMMIT_COMMITTER" ]; then
  BUILD_COMMIT_AUTHORS="$BUILD_COMMIT_AUTHORS, $BUILD_COMMIT_COMMITTER"
fi

mkdir -p output/assets/2021-2022 output/assets/2022-2023

for output_page in $PAGES; do
  if [ ! -f pages/"$output_page".md ]; then
    printf "Page %s is missing, skipping\n" "$output_page"
    continue
  fi

  navbar="\n"
  for navbar_page in $PAGES; do
    if [ ! -f pages/"$navbar_page".md ]; then
      continue
    fi

    ignore=$(sed -n 's/^no-nav-entry: //p' pages/"$navbar_page".md)
    if [ "$ignore" = True ]; then
      continue
    fi

    name=$(sed -n 's/^pagetitle: //p' pages/"$navbar_page".md)
    if [ -z "$name" ]; then
      name=$(sed -n 's/^title: //p' pages/"$navbar_page".md)
    fi
    if [ -z "$name" ]; then
      printf "Skipping %s due to missing yaml title\n" "$navbar_page"
      continue
    fi

    navbar="$navbar                <li class=\"nav-item mb-2 px-2\">\n"
    navbar="$navbar                  <a class=\"nav-link pt-1 button\""
    if [ "$output_page" = "$navbar_page" ]; then
      navbar="$navbar aria-current=\"page\" href=\"#"
    else
      navbar="$navbar href=\"$navbar_page.html"
    fi
    navbar="$navbar\">$name</a>\n"
    navbar="$navbar                </li>\n"
  done
  navbar="$navbar              "

  printf "Processing %s\n" "pages/$output_page.md"
  bin/pandoc templates/setup.yaml --eol=lf -s --template templates/template.html\
             -f markdown-implicit_figures-smart --wrap=preserve -B templates/header.html\
             -A templates/footer.html "pages/$output_page.md" -o "output/$output_page.html"
  sed -i.tmp -e "s\`%NAVBAR_ITEMS%\`$navbar\`" -e 's# />#>#' -e "s/%PANDOC_VERSION%/$PANDOC_VERSION/"\
             -e "s/%MAGICK_VERSION%/$MAGICK_VERSION/" -e "s/%BUILD_TIME%/$BUILD_TIME/"\
             -e "s/%BUILD_COMMIT%/$BUILD_COMMIT/g" -e "s/%BUILD_COMMIT_AUTHOR%/$BUILD_COMMIT_AUTHORS/"\
             -e "s/%BUILD_COMMIT_TIME%/$BUILD_COMMIT_TIME/" -e "s/%BUILD_COMMIT_BRANCH%/$BUILD_COMMIT_BRANCH/g"\
             -e 's#%ALERT(\(.*\))%#<div class="alert alert-info alert-dismissible fade show mx-2 mx-sm-3" role="alert">\n          \1\n          <button type="button" class="btn-close vertical-centre-button" data-bs-dismiss="alert" aria-label="Close"></button>\n        </div>#'\
             -e 's@%CAROUSELSTART(\([^(]*\), \([^,]*\))%@<a href="#\2" class="button" role="button" data-bs-toggle="collapse" data-bs-target="#\2" aria-expanded="true" aria-controls="\2">Toggle \1</a>\n<div id="\2" class="multi-collapse show slide tabs" aria-label="\1">\n  <nav>\n    <div class="nav nav-tabs" role="tablist">@'\
             -e 's@%CAROUSELMIDDLE%@    </div>\n  </nav>\n  <div class="tab-content border border-top-0 p-2">@' -e s'@%CAROUSELEND%@  </div>\n</div>@'\
             -e 's@%CAROUSELBUTTON(\([^,(]*\), \([^,]*\), \([^,]*\)\(,\(.*\)\)\?)%@      <input class="btn-check" id="\2Tab\3" name="\2" type="radio" role="tab" autocomplete="off" aria-controls="\2Div\3"\5>\n      <label class="btn btn-outline-primary nav-link" id="\2\3" for="\2Tab\3">\1</label>@'\
             -e 's@%CAROUSELIMAGE(\([^,(]*\), \([^,]*\), \([^,]*\), \([^,]*\))%@    <div class="tab-pane fade show" id="\2Div\3" role="tabpanel" aria-labelledby="\2\3" tabindex="0">\n      <picture>\n        <source srcset="assets/\4.avif" type="image/avif">\n        <source srcset="assets/\4.webp" type="image/webp">\n        <img src="assets/\4.png" class="d-block img-fluid m-auto w-auto" alt="\1">\n      </picture>\n    </div>@'\
             -e '/<!-- TODO: .*-->/d'\
             -e '/[ "]no-anchor[ "]/b; s#^<h\([123456]\)\(.*\)id="\([^"]*\)"\(.*\)</h\1>#<h\1\2id="\3"><span\4</span><a class="ms-2" href="\#\3"><svg class="heading-anchor-icon"><title>Link icon</title></svg></a></h\1>#'\
             -e 's/<table>/<table class="table table-striped">/' -e 's/<tbody>/<tbody class="table-group-divider">/'\
             "output/$output_page.html"
  rm "output/$output_page.html.tmp"
done

cp assets/logo.svg output/assets/logo.svg
cp assets/script.js output/assets/script.js
cp assets/tools.js output/assets/tools.js
cp assets/style.css output/assets/style.css
cp assets/style-winxp.css output/assets/style-winxp.css
cp assets/minutestemplate1.typ output/assets/minutestemplate1.typ
cp assets/minutestemplate2.typ output/assets/minutestemplate2.typ
cp assets/"Programming Club Constitution.pdf" output/assets/"Programming Club Constitution.pdf"
rm -r output/meetings/ 2>/dev/null | true
cp -R assets/meetings/ output/assets/meetings/
rm -r output/assets/winxp/ 2>/dev/null || true
cp -R assets/winxp/ output/assets/winxp/
rm -r output/game/ 2>/dev/null || true
cp -R pages/game/ output/game/

# From https://stackoverflow.com/a/63869938
# Replaces ${1%.*} which somehow causes a seg fault with cosmo dash when assigned to a var
# i.e. echo "${1%.*}" is fine but FILE="${1%.*}" gives SIGSEGV
remove_file_ext() {
  printf "%s" "$1" | sed -re 's/(^.*[^/])\.[^./]*$/\1/'
}

# Must call wait after one or more process_image calls
process_image() {
  FILE=$(remove_file_ext "$1")
  dirname "output/$image" | xargs mkdir -p

  if [ -f "output/$FILE.avif" ] && [ -f "output/$FILE.png" ] && [ -f "output/$FILE.webp" ]; then
    printf "Skipping %s\n" "$1"
  else
    printf "Processing %s\n" "$1"
  fi

  # shellcheck disable=SC2086
  [ -f "output/$FILE.avif" ] || bin/magick "$1" -strip -background none $2 "output/$FILE.avif" &
  # shellcheck disable=SC2086
  [ -f "output/$FILE.png" ]  || bin/magick "$1" -strip -background none $2 "output/$FILE.png" &
  # shellcheck disable=SC2086
  [ -f "output/$FILE.webp" ] || bin/magick "$1" -strip -background none $2 "output/$FILE.webp"
}

[ -f output/assets/favicon.ico ] || bin/magick assets/logo.png -strip -background none -resize 48x48 -density 48x48 output/assets/favicon.ico
wait

for image in assets/2023-2024/committee-*.jpg assets/2024-2025/committee-*.*; do
  process_image "$image" "-compress lossless" &
done
wait

for image in assets/2023-2024/discord-*.png assets/2024-2025/discord-*.png; do
  process_image "$image" "-compress lossless" &
done
wait

process_image assets/2023-2024/minecraft-1.png       "-resize 1024x576 -density 1024x576" &
process_image assets/2023-2024/minecraft-2.png       "-resize 1024x576 -density 1024x576" &
process_image assets/2023-2024/minecraft-3.png       "-resize  521x576 -density  521x576" &
process_image assets/2024-2025/minecraft-highway.png "-resize 1024x576 -density 1024x576"
wait

process_image assets/2021-2022/first_meetup.jpg     "-resize  960x502 -density  960x502" &
process_image assets/2022-2023/holiday-meetup-1.jpg "-resize  720x540 -density  720x540" &
process_image assets/2022-2023/meetup-2.jpg         "-resize  921x691 -density  921x691" &
process_image assets/2022-2023/meetup-2-cropped.jpg "-resize 2304x679 -density 2304x679" &
process_image assets/2023-2024/meetup.jpg           "-resize 1008x567 -density 1008x567"
wait

process_image assets/2023-2024/tasjam-1.jpg "-resize 805x604 -density 805x604" &
process_image assets/2023-2024/tasjam-2.jpg "-resize 805x604 -density 805x604" &
process_image assets/2024-2025/pcjam25-1.png "-resize 805x453 -density 805x453" &
process_image assets/2024-2025/pcjam25-2.jpg "-resize 805x604 -density 805x604"
wait

process_image assets/2022-2023/industry-night-1.jpg "-resize 1008x496 -density 1008x496" &
process_image assets/2022-2023/industry-night-2.jpg "-resize 1008x496 -density 1008x496" &
process_image assets/2022-2023/industry-night-4.jpg "-resize 1008x496 -density 1008x496"
wait

process_image assets/2022-2023/c\&s-1-cropped.jpg "-resize  985x625 -density  985x625"&
process_image assets/2022-2023/open-day.jpg       "-resize 1080x608 -density 1080x608"&
process_image assets/2023-2024/mini-c\&s.jpg      "-resize  806x604 -density  806x604"&
process_image assets/2024-2025/c\&s.png           "-resize  560x560 -density  560x560"
wait
