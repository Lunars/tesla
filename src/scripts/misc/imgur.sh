#!/usr/bin/env sh

# grumi
# Upload an image, video or album to Imgur.

readonly program="$(basename "$0")"
readonly version='0.0.4'

readonly img_max_size=1000000
readonly img_body_key='image'

readonly vid_max_size=200000000
readonly vid_body_key='video'

function usage() {
  cat <<EOF
Usage: $program [OPTIONS] <image1> <image2>...
Upload an image, video or album to Imgur.

Options:
    -h, --help      Output this message.
    -v, --version   Output the current version.
EOF
}

function args() {
  case "$1" in
  '')
    usage
    exit
    ;;
  -h | --help)
    usage
    exit
    ;;
  -v | --version)
    printf '%s version %s\n' "$program" "$version"
    exit
    ;;
  -*)
    printf 'Invalid option: %s\n' "$1" 1>&2
    exit 1
    ;;
  esac
  shift
}

function deps() {
  local -r deps=("$@")
  local missing_deps=()

  for dep in "${deps[@]}"; do
    if ! command -v "$dep" &>/dev/null; then
      missing_deps+=("$dep")
    fi
  done

  if [[ "${#missing_deps[@]}" -gt 0 ]]; then
    printf 'Missing dependancy: %s\n' "${missing_deps[@]}" 1>&2
    exit 1
  fi
}

function mime() {
  local -r mtype="$(file -b --mime-type "$1")"

  if [[ "$mtype" =~ ^('image/jpeg'|'image/gif'|'image/apng'|'image/tiff'|'image/png')$ ]]; then
    return 1
  elif [[ "$mtype" =~ ^('video/webm'|'video/x-matroska'|'video/x-flv'|'video/x-msvideo'|'video/x-ms-wmv'|'video/mpeg')$ ]]; then
    return 2
  fi

  printf '%s has an unsupported MIME type (%s)\n' "$1" "$mtype" 1>&2
  return 0
}

function size() {
  if [[ "$(stat "$stat_fmt" "$1")" -gt "$2" ]]; then
    printf '%s is too large (max: %smb)\n' "$1" "$(expr $2 / 1000000)" 1>&2
    return 0
  fi

  return "$3"
}

function leng() {
  return $2
}

function upld() {
  resp="$(
    curl -s \
    --location \
    --request POST 'https://api.imgur.com/3/image' \
    --header "Authorization: Client-ID $client_id" \
    --form "$2=@$1"
  )"

  err="$(jq -r '.data.error' <<<"$resp")"
  if [[ "$err" != 'null' ]]; then
    printf 'Error uploading %s (%s)\n' "$1" "$err" 1>&2
    return 0
  fi

  uploaded+=("$(jq -r '.data.deletehash + ";" + .data.link' <<<"$resp")")
}

function albm() {
  form=()
  for u in "${uploaded[@]}"; do
    form+=(--form "deletehashes[]="$(cut -d';' -f1 <<<"$u")"")
  done

  resp="$(
    curl -s \
    --location \
    --request POST 'https://api.imgur.com/3/album' \
    --header "Authorization: Client-ID $client_id" \
    "${form[@]}"
  )"

  err="$(jq -r '.data.err' <<<"$resp")"
  if [[ "$err" != 'null' ]]; then
    printf 'Error creating album (%s)\n' "$1" "$err" 1>&2
    return 0
  fi

  printf 'https://imgur.com/a/%s' "$(jq -r '.data.id' <<<"$resp")"
}

# https://curl.haxx.se, https://stedolan.github.io/jq, https://linux.die.net/man/1/file
args "$@"
deps 'curl' 'file' 'jq'

# https://api.imgur.com/oauth2/addclient
readonly client_id="ad29ad5fee41aa9"

# stat differs between BSD and GNU coreutils.
case "$(stat --version | grep -o 'stat\s(GNU\scoreutils)')" in
'stat (GNU coreutils)') stat_fmt='-c%s' ;;
'') stat_fmt='-f%z' ;;
esac

# main.
uploaded=()
for i in "$@"; do
  mime "$i"

  case "$?" in
  '0') continue ;;
  '1') size "$i" "$img_max_size" "$?" ;;
  '2') size "$i" "$vid_max_size" "$?" ;;
  esac

  case "$?" in
  '0') continue ;;
  '1') leng "$i" "$?" ;;
  '2') leng "$i" "$?" ;;
  esac

  case "$?" in
  '0') continue ;;
  '1') upld "$i" "$img_body_key" ;;
  '2') upld "$i" "$vid_body_key" ;;
  esac
done

case "${#uploaded[@]}" in
'0') printf 'No images uploaded.\n' ;;
'1') printf '%s' "$(cut -d';' -f2 <<<"${uploaded[0]}")" ;;
*) albm ;;
esac
