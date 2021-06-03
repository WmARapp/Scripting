# Version 5.08.2018a

loc=/scripts/chkJOBD/;
out=/scripts/chkJOBD/Cleanup_jobdlist.txt;
list1=/scripts/chkJOBD/output.txt;
list2=/scripts/chkJOBD/uniqlist.out;
list3=/scripts/chkJOBD/notfound.list;
wrklib=TMPLIB;

cd $loc;

system "DSPOBJD OBJ(*ALL/*ALL) OBJTYPE(*JOBD) OUTPUT(*OUTFILE) OUTFILE($wrklib/JOBDLIST)";
db2 "select ODLBNM , ODOBNM from $wrklib.JOBDLIST" | tail -n +4 | sed '$d' | sed '$d' | sed '$d' | while read fn ft; do
system "DSPJOBD JOBD($fn/$ft)" 2>/dev/null | sed -n -e '/Initial library list/,$p' | tail -n +4 | sed '$d' | awk {'print $2 " "$4 " "$6'} | tr ' ' '\n' | awk 'NF>0' >>$list1; done
sort $list1 | uniq >>$list2
for fn in `cat $list2`; do
if (system "DSPOBJD OBJ($fn) OBJTYPE(*LIB)") 2>/dev/null; then
    echo $fn found; else
    echo $fn >>$list3;
fi
done
for lib in `cat $list3`; do
db2 "SELECT ODLBNM , ODOBNM from $wrklib.JOBDLIST" | tail -n +4 | sed '$d' | sed '$d' | sed '$d' | while read fa fb; do
if (system "DSPJOBD JOBD($fa/$fb)" | grep -w $lib) 2>/dev/null; then
 echo "$lib found on Job Description $fa $fb" >>$out; else
fi
done
done

rm $list1
rm $list2
rm $list3