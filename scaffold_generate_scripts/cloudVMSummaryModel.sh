rails generate scaffold CloudViewVMSummary \
date:date \
VMUUID:string \
localVMID:string \
publisher_id:integer \
local_group:string \
local_user:string \
status:string \
diskImage:string \
cloudType:string \
vmCount:integer \
disk:integer \
wallDuration:integer \
cpuDuration:integer \
networkInbound:integer \
networkOutbound:integer \
memory:integer \
cpuCount:integer