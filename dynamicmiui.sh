#!bin/bash

# Variables
PARTITIONS=("system" "product" "opproduct")
payload_extractor="tools/update_payload_extractor/extract.py"
LOCALDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
outdir="$LOCALDIR/cache"
tmpdir="$outdir/tmp"
HOST="$(uname)"
toolsdir="$LOCALDIR/tools"
simg2img="$toolsdir/$HOST/bin/simg2img"
packsparseimg="$toolsdir/$HOST/bin/packsparseimg"
unsin="$toolsdir/$HOST/bin/unsin"
payload_extractor="$toolsdir/update_payload_extractor/extract.py"
sdat2img="$toolsdir/sdat2img.py"
ozipdecrypt="$toolsdir/oppo_ozip_decrypt/ozipdecrypt.py"
brotli_exec="$toolsdir/$HOST/bin/brotli"
#############################################################

echo Unzipping fw..
mkdir -p $tmpdir
unzip *.zip -p -d $tmpdir
echo "Converting system image..."
$brotli_exec -d "$tmpdir/system.new.dat.br"
rm -f $tmpdir/system.new.dat.br
cd $tmpdir
python3 $sdat2img system.new.dat system.transfer.list "system.img"
rm -rf system.new.dat system.transfer.list
$simg2img system.img system.img.raw
rm -f system.img 
mv system.img.raw system.img
cd ..
# Unzip product partition
echo "Converting product image .."
$brotli_exec -d "$tmpdir/product.new.dat.br"
rm -f $tmpdir/product.new.dat.br
cd $tmpdir
python3 $sdat2img product.new.dat product.transfer.list "product.img"
$simg2img product.img product.img.raw
rm -f product.img
mv product.img.raw product.img

# Make new dummy image
echo "Creating dummy image"
dd if=/dev/zero of=final.img bs=4k count=1048576
mkfs.ext4 final.img
tune2fs -c0 -i0 final.img

# Mount the two files
echo "Merging two images.."
mkdir mountsys &&mkdir mountpro &&mkdir mountfin
sudo mount final.img mountfin
sudo mount system.img mountsys
sudo mount product.img mountpro
sudo cp -v -r -p mountpro/* mountfin/system/product
sudo umount product.img
sudo umount final.img
sudo umount system.img
cd ../../

# Clean up
echo "Cleaning up.."
sudo rm -rf $tmpdir
cp $tmpdir/final.img $outdir
mv $outdir/final.img system.img

# Finalize
echo "Please finish creating GSI using make.sh script"
