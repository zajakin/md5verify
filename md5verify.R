#!/usr/bin//usr/bin/Rscript --vanilla
# wd <- "/wd/"
# if(!grepl("/$",wd)) wd<-paste0(wd,"/")
system(paste0("cd /wd/ && (find /wd/ -name md5sum.txt; find /wd/ -name *.md5) > /wd/md5files.txt"),intern=TRUE)
files<-readLines(paste0("/wd/md5files.txt"))
files<-files[!grepl("/[@#]",files)]

for(f in files){
  print(f)
  out<- sub(".md5$","_md5_check_report_NAS.txt",sub(".txt$","_md5_check_report_NAS.txt",basename(f)) )
  if(!file.exists(out)) system(paste0("cd ",dirname(f)," && md5sum -c ",basename(f)," > ",out ),intern=TRUE)
}
print("Done")
