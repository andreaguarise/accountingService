rails generate scaffold TorqueExecuteRecord \
uniqueId:string \
recordDate:datetime \
lrmsId:string \
user:string \
group:string \
jobName:string \
queue:string \
ctime:integer \
qtime:integer \
etime:integer \
start:integer \
execHost:string \
resourceList_nodect:integer \
resourceList_nodes:integer \
resourceList.walltime:integer \
session:integer \
end:integer \
exitStatus:integer \
resourceUsed_cput:integer \
resourceUsed_mem:integer \
resourceUsed_vmem:integer \
resourceUsed_walltime:integer
 
