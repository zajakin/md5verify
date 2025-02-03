#!/usr/bin//usr/bin/Rscript --vanilla
# wd <- "/wd/"
# if(!grepl("/$",wd)) wd<-paste0(wd,"/")
if(file.exists("/wd/md5verify.log")) unlink(("/wd/md5verify.log"))
cat(date(),file="/wd/md5verify.log",append = T)
system(paste0("cd /wd/ && (find /wd/ -name md5sum.txt; find /wd/ -name *.md5) > /wd/md5files.txt 2> /wd/md5verify.log"),intern=TRUE)
files<-readLines(paste0("/wd/md5files.txt"))
files<-files[!grepl("/[@#]",files)]
f<-files[1]
for(i in 1:length(files)){
  f<-files[i]
  cat(paste0("\n",f," ",i,"/",length(files)),file="/wd/md5verify.log",append = T)
  print(paste0(f," ",i,"/",length(files)))
  out<- sub(".md5$","_md5_check_report_NAS.txt",sub(".txt$","_md5_check_report_NAS.txt",f) )
  if(!file.exists(out)){
    cat("   Check...",file="/wd/md5verify.log",append = T)
    print("Check...")
    system(paste0("cd ",dirname(f)," && md5sum -c ",basename(f)," > ",out," 2>&1"),intern=TRUE)
  } else if(sub(" .*","",system(paste("wc -l",f),intern=TRUE)) != sub(" .*","",system(paste("wc -l",out),intern=TRUE))){
    # readLines(out)
    cat("   Recheck...",file="/wd/md5verify.log",append = T)
    print("Recheck...")
    system(paste0("cd ",dirname(f)," && md5sum -c ",basename(f)," > ",out," 2>&1"),intern=TRUE)
  }
}
system(paste0("cd /wd/ && find /wd/ -name *_md5_check_report_NAS.txt -exec grep --with-filename -v ' OK$' {} \\; > /wd/md5errors.txt 2>&1 && sed -i 's!^/wd/!!g' /wd/md5errors.txt"),intern=TRUE)
cat(paste0("\n",date()),file="/wd/md5verify.log",append = T)
print("Done")
