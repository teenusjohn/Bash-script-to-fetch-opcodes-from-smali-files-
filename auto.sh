#!/bin/bash

for file in ./*.apk; do apktool d -f $file; done
for dir in $(ls -d */);
do 
	mkdir ${dir}smali/opcodes
	FILES=$(find ${dir}smali -type f -name '*.smali')
	for file in $FILES;
		do
			grep -v [0*.#:}{\"] $file | sed '/^$/d' | sed 's/ //g' | cut -d"," -f1 | sort -u  >> ./${dir}smali/opcodes/opcodes.txt
		done
done

for dir in $(ls -d */);
do
	sed "s/v[0-9]//" ./${dir}smali/opcodes/opcodes.txt > ./${dir}smali/opcodes/opcodesv1.txt
	sed "s/p[0-9]//" ./${dir}smali/opcodes/opcodesv1.txt > ./${dir}smali/opcodes/opcodesv2.txt
#	sed "s/{v[0-9]}//" ./${dir}smali/opcodes/opcodesv2.txt > ./${dir}smali/opcodes/opcodesv3.txt
#       sed "s/{p[0-9]}//" ./${dir}smali/opcodes/opcodesv3.txt > ./${dir}smali/opcodes/opcodesv4.txt
	sed "s/[0-9]$//" ./${dir}smali/opcodes/opcodesv2.txt > ./${dir}smali/opcodes/opcodesv3.txt
	python ngram.py ./${dir}smali/opcodes/opcodesv3.txt ./${dir}smali/opcodes/ 
	fn="${dir::-1}.txt"
#	cat ./${dir}smali/opcodes/grams.txt | sort | uniq -c | sort -rn> $fn
done
