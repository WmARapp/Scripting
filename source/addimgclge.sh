# Version 2018.04.07a
# Script to add Images to a Image catalog
print "Loading PTFs or OS Upgrade Images. Answer PTF or UPGRADE";
read type
print "Name of Image Catalog to load into. Example V7R3PTFS";
read imgclg
print "IFS location of images. Example /v7r3ptfs";
read loc
print "Name of Virtual Optical Device. Example OPTVRT01";
read dev
cd $loc;
for fn in `ls | egrep '\.bin$|\.iso$|\.udf$'`
do
system "ADDIMGCLGE IMGCLG($imgclg) fromfile('$fn') tofile(*FROMFILE)"
done
system "LODIMGCLG IMGCLG($imgclg) DEV($dev)";
system "VFYIMGCLG IMGCLG($imgclg) TYPE(*$type) SORT(*YES)";