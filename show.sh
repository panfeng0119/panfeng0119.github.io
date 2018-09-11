work_path=`pwd`
Date=`date "+%Y-%m-%d %H:%M:%S"`
alias log='echo ${Date} INFO'

log "启动服务."
hugo server --buildDrafts 
