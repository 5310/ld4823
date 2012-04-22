echo "This script will try to run the current folder as a LOVE2D game."
dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
love "$dir"
