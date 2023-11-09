read_bidir_oci()
{
input="host.lst"
while IFS="|" read -r host ext1 rep1 ext2 rep2 dist1 dist2 fileext1 filedist1 fileext2 filedist2 aliascdb1 aliaspdb1 aliascdb2 aliaspdb2; do
export ogghost=$host
export oggext1=$ext1
export oggrep1=$rep1
export oggext2=$ext2
export oggrep2=$rep2
export oggdist1=$dist1
export oggdist2=$dist2
export oggfileext1=$fileext1
export oggfiledist1=$filedist1
export oggfileext2=$fileext2
export oggfiledist2=$filedist2
export oggaliascdb1=$aliascdb1
export oggaliaspdb1=$aliaspdb1
export oggaliascdb2=$aliascdb2
export oggaliaspdb2=$aliaspdb2
done < "$input"
}
