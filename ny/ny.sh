#!/bin/bash
if ! (ls *.txt); then
  > tmp.txt
  > ny.txt
  echo "{TITEL}{titel}" > ny.txt
  echo "{AFSNIT}{afsnit}" >> ny.txt
  echo "{KODE}{kode}" >> ny.txt
  echo "{KILDE}{kilde}" >> ny.txt
  echo "{DATO}" >> ny.txt
  exit
fi
if ! (ls *.html); then
  exit
else
  files=$(ls *.html)
fi
i=1
for j in $files
do
  echo "$i.$j"
  file[i]=$j
  i=$(( i + 1 ))
done
echo -n "Fil der skal opdateres "
read input
fil=${file[$input]}
paste < $fil > tmp.txt
kapitler=$(($(grep -c "#C" tmp.txt)/2))
afsnit=$(($kapitler + 1))
paste < ny.txt > tmp.txt
sed -i 's/</\&lt;/g' tmp.txt
sed -i 's/>/\&gt;/g' tmp.txt
if (grep "{TITEL}" ny.txt); then
  if ! ((afsnit % 2)); then
    sed -i 's/{TITEL}/<!-- '"#C$afsnit"' -->\n<div class="w3-row-padding w3-light-grey w3-padding-32 w3-container">\n  <div class="w3-content">\n    <div #class="w3">\n      <h3 class="w3-padding-16" id="'"C$afsnit"'">/g' tmp.txt
  else
    sed -i 's/{TITEL}/<!-- '"#C$afsnit"' -->\n<div class="w3-row-padding w3-padding-32 w3-container">\n  <div class="w3-content">\n    <div class="w3">\n      <h3 class="w3-padding-16" id="'"C$afsnit"'">/g' tmp.txt
  fi
  sed -i 's/{titel}/<\/h3>/g' tmp.txt
fi
if (grep "{AFSNIT}" ny.txt); then
  sed -i 's/{AFSNIT}/      <p class="w3-text-grey">/g' tmp.txt
  sed -i 's/{afsnit}/<\/p>/g' tmp.txt
fi
if (grep "{KODE}" ny.txt); then
  if ! ((afsnit % 2)); then
    sed -i 's/{KODE}/      <pre><p class="w3-code">/g' tmp.txt
  else
    sed -i 's/{KODE}/      <pre><p class="w3-code w3-light-grey">/g' tmp.txt
  fi
  sed -i 's/{kode}/<\/p><\/pre>/g' tmp.txt
fi
if (grep "{KILDE}" ny.txt); then
  sed -i 's/{KILDE}/      <p class="w3-text-grey"><a href="/g' tmp.txt
  sed -i 's/{kilde}/" target="_blank">Kilde<\/a><\/p>/g' tmp.txt
fi
if (grep "{DATO}" ny.txt); then
  dato=$(date +"%d.%m.%y")
  sed -i 's/{DATO}/      <p class="w3-text-grey">Opdateret: '"$dato"'<\/p>/g' tmp.txt
fi
if (grep "{TITEL}" ny.txt); then
cat << EOF >> tmp.txt
    </div>
  </div>
</div>

EOF
fi
sed -i -e '/<!-- Footer -->/r tmp.txt' -e 'x;$G' $fil
paste < ny.txt > tmp.txt
overskrift=$(head -n 1 tmp.txt)
echo $overskrift > tmp.txt
if (grep "{TITEL}" ny.txt); then
  sed -i 's/{TITEL}/  <p><a href="'"#C$afsnit"'" class="w3-table">/g' tmp.txt
  sed -i 's/{titel}/<\/a><\/p>/g' tmp.txt
  sed -i -e '/<\/header>/r tmp.txt' -e 'x;$G' $fil
fi
sed -i '/./,$!d' $fil # slet tomme linjer i toppen
