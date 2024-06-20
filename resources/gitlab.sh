#!/bin/bash


student_group_id=68990640
projectId=0
projectName="None"
groupName=""

# Token: glpat-H_JYihq-5x31-yWxtDmk


fix() {

  getSubgroupList $1

  for groupId in $group_list
  do
    echo $groupId
  done

}

createSonarQubeProjects() {

  projectName=$1
  studentFile=$2
  qualityGate=$3

  IFS=$'\n'
  read -d '' -r -a students < $studentFile

  echo "Cycling through students..."

  for student in ${students[@]}
  do
    echo "Add Project for ${student}"
    addSonarProjectForUser $projectName $student $qualityGate
    sleep 1
  done
}
#
# Setup SonarQube
#
addSonarProjectForUser() {

    echo "Adding SonarQube project ${1} for ${2} quality gate ${3}"
    curlString="curl -s --request POST --url \"https://au-csse-cpsc4970.com/api/projects/create\" --header \"Authorization: Bearer squ_fc0bf0abd5dccc1f812aa79aaf8a2c05ce97b3d9\" --data \"project=${1}-${2}&name=${1}-${2}&visibility=private\""
    eval $curlString
    echo "Adding permissions..."
    curlString="curl -s --request POST --url \"https://au-csse-cpsc4970.com/api/permissions/add_user\" --header \"Authorization: Bearer squ_fc0bf0abd5dccc1f812aa79aaf8a2c05ce97b3d9\" --data \"projectKey=${1}-${2}&login=${2}&permission=securityhotspotadmin\""
    eval $curlString
    curlString="curl -s --request POST --url \"https://au-csse-cpsc4970.com/api/permissions/add_user\" --header \"Authorization: Bearer squ_fc0bf0abd5dccc1f812aa79aaf8a2c05ce97b3d9\" --data \"projectKey=${1}-${2}&login=${2}&permission=user\""
    eval $curlString
    curlString="curl -s --request POST --url \"https://au-csse-cpsc4970.com/api/permissions/add_user\" --header \"Authorization: Bearer squ_fc0bf0abd5dccc1f812aa79aaf8a2c05ce97b3d9\" --data \"projectKey=${1}-${2}&login=${2}&permission=scan\""
    eval $curlString
    curlString="curl -s --request POST --url \"https://au-csse-cpsc4970.com/api/permissions/add_user\" --header \"Authorization: Bearer squ_fc0bf0abd5dccc1f812aa79aaf8a2c05ce97b3d9\" --data \"projectKey=${1}-${2}&login=${2}&permission=codeviewer\""
    eval $curlString
    curlString="curl -s --request POST --url \"https://au-csse-cpsc4970.com/api/permissions/add_user\" --header \"Authorization: Bearer squ_fc0bf0abd5dccc1f812aa79aaf8a2c05ce97b3d9\" --data \"projectKey=${1}-${2}&login=${2}&permission=issueadmin\""
    eval $curlString
    echo "Adding quality gate..."
    curlString="curl -s --request POST --url \"https://au-csse-cpsc4970.com/api/qualitygates/select\" --header \"Authorization: Bearer squ_fc0bf0abd5dccc1f812aa79aaf8a2c05ce97b3d9\" --data \"projectKey=${1}-${2}&gateName=${3}\""
    eval $curlString
    echo "Adding quality profile..."
    curlString="curl -s --request POST --url \"https://au-csse-cpsc4970.com/api/qualityprofiles/add_project\" --header \"Authorization: Bearer squ_fc0bf0abd5dccc1f812aa79aaf8a2c05ce97b3d9\" --data \"project=${1}-${2}&language=java&qualityProfile=au_profile\""
    eval $curlString

}

deleteSonarQubeProjects() {

  projectName=$1
  studentFile=$2
  qualityGate=$3

  IFS=$'\n'
  read -d '' -r -a students < $studentFile

  echo "Cycling through students..."

  for student in ${students[@]}
  do
    echo "Add Project for ${student}"
    deleteSonarProjectForUser $projectName $student $qualityGate
    sleep 1
  done
}
#
# Setup SonarQube
#
deleteSonarProjectForUser() {

    echo "Deleting SonarQube project ${1} for ${2} quality gate ${3}"
    curlString="curl -s --request POST --url \"https://au-csse-cpsc4970.com/api/projects/delete\" --header \"Authorization: Bearer squ_fc0bf0abd5dccc1f812aa79aaf8a2c05ce97b3d9\" --data \"project=${1}-${2}\""
    eval $curlString

}

#
# Add SonarQube Users
#
addSonarqubeUsers() {

  studentFile=$1

  echo "Setting up class from student file $studentFile"

  IFS=$'\n'
  read -d '' -r -a students < $1

  echo "Adding students..."

  for student in ${students[@]}
  do
    IFS=','
    read -d '' -ra aStudent <<< "$student"
    echo "Adding student X${aStudent[0]}X"
    echo "Adding student X${aStudent[1]}X"
    echo "Adding student X${aStudent[2]}X"
    #curlString="curl -s --request POST --url \"https://au-csse-cpsc4970.com/api/users/create\" --header \"Authorization: Bearer squ_fc0bf0abd5dccc1f812aa79aaf8a2c05ce97b3d9\" --data \"login=${aStudent[0]}&name=test&password=aubie&email=${aStudent[1]}\""
    curlString="curl -s --request POST --url \"https://au-csse-cpsc4970.com/api/users/update\" --header \"Authorization: Bearer squ_fc0bf0abd5dccc1f812aa79aaf8a2c05ce97b3d9\" --data \"login=${aStudent[0]}&name=${aStudent[2]}\""
    eval $curlString
#    curlString=`curl -s --request POST --url "https://au-csse-cpsc4970.com/api/users/create" --header "Authorization: Bearer squ_fc0bf0abd5dccc1f812aa79aaf8a2c05ce97b3d9" --data "login=${aStudent[0]}&name=test&password=aubie&email=${aStudent[1]}"`
#    echo $createUser
  done

}

#
# Create Group
#
createGroup() {

  echo "Creating group $1 under parent id $2"
  createdGroupId=`curl -s --request POST --url "https://gitlab.com/api/v4/groups" --data "{ \"name\": \"${1}\", \"path\": \"${1}\", \"parent_id\": \"${2}\" }" --header "PRIVATE-TOKEN: glpat-H_JYihq-5x31-yWxtDmk" --header "Content-Type: application/json" | jq -rj '.id'`
  echo "Created group $createdGroupId"

}
#
# Delete Group
#
deleteGroup() {

  echo "Deleting group $1 $2"
  curl --request DELETE --url "https://gitlab.com/api/v4/groups/${1}" --header "PRIVATE-TOKEN: glpat-H_JYihq-5x31-yWxtDmk"
  curl --request DELETE --url "https://gitlab.com/api/v4/groups/${1}" --data "permanently_remove=true&full_path=${2}" --header "PRIVATE-TOKEN: glpat-H_JYihq-5x31-yWxtDmk"
  echo "Done"

}

#
# Import Project
#
importProject() {
  echo "2-- $2"
  groupId=$1
  projectName=$2
  projectSlug=$3
  filename=$4
  getGroupName $groupId
  echo "================================================="
  echo "Adding Project to Group: $groupid - $groupName $projectName $projectSlug $filename"
  paramString="{\"name\": \"${projectName}\",\"path\": \"${projectSlug}\",\"namespace\": \"${groupId}\",\"region\": \"us-east-2\", \"bucket_name\": \"cpsc4970-assignments\",\"file_key\": \"${filename}\",\"access_key_id\": \"AKIAR7BGN267JKVFTFPU\", \"secret_access_key\": \"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\"}"
  commandString="curl -s --request POST --url \"https://gitlab.com/api/v4/projects/remote-import-s3\" --header \"PRIVATE-TOKEN: glpat-H_JYihq-5x31-yWxtDmk\" --header 'Content-Type: application/json' --data  '{\"name\": \"${projectName}\",\"path\": \"${projectSlug}\",\"namespace\": \"${groupId}\",\"region\": \"us-east-2\", \"bucket_name\": \"cpsc4970-assignments\",\"file_key\": \"${filename}\",\"access_key_id\": \"AKIAR7BGN267JKVFTFPU\", \"secret_access_key\": \"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\"}'"
  # echo $commandString
  result=`eval $commandString`
  message=`echo ${result} | jq -rj '.message'`
  if [ $message == "null" ] ; then
    projectId=`echo ${result} | jq -rj '.id | tostring'`
    echo "Id: ${id}"
    adjustProjectPermissions
    adjustBranchPermissions
  else
    echo "Message: ${message}"
  fi
}

#
# Create Project
#
createProject() {
curl --request POST \
  --url "https://gitlab.com/api/v4/projects/remote-import-s3" \
  --header "PRIVATE-TOKEN: glpat-H_JYihq-5x31-yWxtDmk" \
  --header 'Content-Type: application/json' \
  --data '{
  "name": "Assignment1aa",
  "namespace": "55903635",
  "path": "assign-1a",
  "region": "us-east-2",
  "bucket_name": "cpsc4970-assignments",
  "file_key": "cpsc4970-sum-a-assignment-2a.tar.gz",
  "access_key_id": "AKIAR7BGN267JKVFTFPU",
  "secret_access_key": "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"
}'
}

# Export a project, check status, download
exportProject() {
echo "Exporting project $1"
curl --request POST \
  --url "https://gitlab.com/api/v4/projects/$1/export" \
  --header "PRIVATE-TOKEN: glpat-Qf2TyowiGQgnnyb5dDhR"
sleep 10
curl --request GET \
  --url "https://gitlab.com/api/v4/projects/$1/export/download" \
  --header "PRIVATE-TOKEN: glpat-Qf2TyowiGQgnnyb5dDhR" \
  --output "proj_export.tar.gz"
}


getGroupInfo () {
#   echo "Getting Group name $1"
   groupName=`curl -s --request GET --header "PRIVATE-TOKEN: glpat-H_JYihq-5x31-yWxtDmk" --url https://gitlab.com/api/v4/groups/$1 | jq`
   echo "Group: $groupName"
}


getGroupName () {
#   echo "Getting Group name $1"
   curlString="curl -s --request GET --header \"PRIVATE-TOKEN: glpat-H_JYihq-5x31-yWxtDmk\" --url https://gitlab.com/api/v4/groups/${gid} | jq -rj '.name'"
   groupName=`eval $curlString`
   echo "Name: $groupName"
}

getProjectName () {
#   echo "Getting Project name $1"
   projectName=`curl -s --request GET --header "PRIVATE-TOKEN: glpat-H_JYihq-5x31-yWxtDmk" --url https://gitlab.com/api/v4/projects/$1 | jq -rj '.name'`
}

getSubgroupList () {
   echo "Getting subgroups for $1"
   group_list=`curl -s --request GET --header "PRIVATE-TOKEN: glpat-H_JYihq-5x31-yWxtDmk" --url https://gitlab.com/api/v4/groups/$1/subgroups?per_page=100 | jq -rj '.[].id | tostring + " "'`
   echo "$group_list"
}

turnOffProjectFeatures() {
   project_url="https://gitlab.com/api/v4/projects/$projectId"
   echo "Adjust Project Features $project_url"

   permString="service_desk_enabled=false&"
   permString+="issues_enabled=false&"
   permString+="requirements_access_level=disabled&"
   permString+="pages_access_level=disabled&"
   permString+="environments_access_level=disabled&"
   permString+="infrastructure_access_level=disabled&"
   permString+="analytics_access_level=disabled&"
   permString+="releases_access_level=disabled&"
   permString+="feature_flags_access_level=disabled&"
   permString+="monitor_access_level=disabled&"
   permString+="pages_enabled=false&"
   permString+="packages_enabled=false&"
   permString+="service_desk_enabled=false&"
   curl -s --request PUT --header "PRIVATE-TOKEN: glpat-H_JYihq-5x31-yWxtDmk" --url ${project_url} --data ${permString} | jq

}
adjustProjectPermissions1() {
  project_url="https://gitlab.com/api/v4/projects/$projectId"
  echo "Adjust Project Permissions $project_url"
  permString="jobs_enabled=true&"
  echo $permString
  curl -s --request PUT --header "PRIVATE-TOKEN: glpat-H_JYihq-5x31-yWxtDmk" --url ${project_url} --data ${permString} | jq
}

adjustProjectPermissions() {
  project_url="https://gitlab.com/api/v4/projects/$projectId"
  echo "Adjust Project Permissions $project_url"
  permString="security_and_compliance_access_level=enabled&"
  permString+="container_registry_enabled=true&"
  permString+="service_desk_enabled=false&"
  permString+="request_access_enabled=false&"
  permString+="releases_access_level=disabled&"
  permString+="issues_enabled=false&"
  permString+="feature_flags_access_level=disabled&"
  permString+="infrastructure_access_level=disabled&"
  permString+="remove_source_branch_after_merge=false&"
  permString+="monitor_access_level=disabled&"
  permString+="jobs_enabled=true&"
  permString+="wiki_enabled=false&"
  permString+="snippets_enabled=false&"
  permString+="analytics_access_level=disabled&"
  permString+="security_and_compliance_enabled=true&"
  permString+="requirements_access_level=disabled&"
  permString+="pages_access_level=disabled&"
  permString+="environments_access_level=disabled&"
  permString+="operations_access_level=disabled&"
  permString+="pages_enabled=false&"
  permString+="packages_enabled=true&"
  permString+="builds_access_level=private"
  echo "Perm String: $permString"
  curlString="curl -s --request PUT --header \"PRIVATE-TOKEN: glpat-H_JYihq-5x31-yWxtDmk\" --url ${project_url} --data \"${permString}\" | jq "
  echo $curlString
  result=`eval $curlString`
  echo $result
}

setProjectPermissions() {
  project_url="https://gitlab.com/api/v4/projects/$1"
  echo "Setting Project Permissions $project_url: $2=$3"
  curl -s --request PUT --header "PRIVATE-TOKEN: glpat-H_JYihq-5x31-yWxtDmk" --url $project_url --data "$2=$3" | jq
}


getProjectBranches() {
  project_url="https://gitlab.com/api/v4/projects/$1/repository/branches"
  getProjectName $1
#  echo "Getting branches for $project_url: "
  curl -s --request GET --header "PRIVATE-TOKEN: glpat-H_JYihq-5x31-yWxtDmk" --url $project_url | jq '.[].name'
}

getProjectPermission() {
  echo "Getting project permission $permId for $projectName - $projectId"
  project_url="https://gitlab.com/api/v4/projects/$projectId"
  jq_filter="'.${permId}'"
  curlString="curl -s --request GET --header \"PRIVATE-TOKEN: glpat-H_JYihq-5x31-yWxtDmk\" --url $project_url | jq $jq_filter"
  permValue=`eval $curlString`
  echo "Project: $groupName $permId=$permValue"
}

adjustBranchPermissions() {

  echo "Adjusting Branch Permissions merge=$mergeAccessLevel push=$pushAccessLevel unprotect=$unprotectAccessLevel"
  project_url="https://gitlab.com/api/v4/projects/$projectId/protected_branches"
  echo "\tDeleting existing main protection: $project_url"
  curlString="curl -s --request DELETE --header \"PRIVATE-TOKEN: glpat-H_JYihq-5x31-yWxtDmk\" $project_url/main"
  result=`eval $curlString`
  echo $result
  echo "\tAdd Protection"
#  curl -s --request POST --header "PRIVATE-TOKEN: glpat-H_JYihq-5x31-yWxtDmk" --url "$project_url?name=main&push_access_level=0&merge_access_level=30&unprotect_access_level=40" | jq
  curlString="curl -s --request POST --header \"PRIVATE-TOKEN: glpat-H_JYihq-5x31-yWxtDmk\" --url \"$project_url?name=main&push_access_level=$pushAccessLevel&merge_access_level=$mergeAccessLevel&unprotect_access_level=$unprotectAccessLevel\" | jq"
  result=`eval $curlString`
  echo $curlString
  echo $result | jq

}

getProjectsForGroups () {
  project_list=""
  project_url="https://gitlab.com/api/v4/groups/$1/projects"
  filter="select( .name | contains(\"${projectFilter}\"))"
  echo "Using filter $filter for find projects in group $project_url"
  curlString="curl -s --request GET --header \"PRIVATE-TOKEN: glpat-H_JYihq-5x31-yWxtDmk\" --url ${project_url} | jq -rj '.[] | select( .name | contains(\"${projectFilter}\")) | .id'"
#  echo $curlString
  project_list=`eval $curlString`
  echo "Project list: $project_list"
}

getProjectInfo () {
    project_url="https://gitlab.com/api/v4/projects/$1"
    echo "Retrieving Info for $project_url"
    curl -s --request GET --header "PRIVATE-TOKEN: glpat-H_JYihq-5x31-yWxtDmk" --url $project_url | jq

}

loadProjectIntoGroups()
{
  echo "1-- $2"
  getSubgroupList $1
  for gid in $group_list
  do
      importProject $gid "$2" $3 $4
      sleep 20
    # fi
  done
}

cycleThroughProjectsSetPerms () {

  echo "Cycling Temp"
  echo "=========================="
  echo "=========================="
  getSubgroupList $groupId
  echo "Found Subgroups: $group_list"
  for gid in $group_list
  do
    getGroupName $gid
    echo "================================================="
    echo "Group for $gid - $groupName"
    getProjectsForGroups $gid
    for projectId in $project_list
    do
      getProjectName $projectId
      adjustProjectPermissions $projectId
      mergeAccessLevel=30
      pushAccessLevel=0
      unprotectAccessLevel=40
#      adjustBranchPermissions $projectId
    done
  done
}

cycleThroughProjects () {

  getSubgroupList $1
  echo "Subgroups: $group_list"
  for gid in $group_list
  do
    getGroupName $gid
    echo "================================================="
    echo "Group for $pid - $groupName"
    getProjectsForGroups $gid
    for pid in $project_list
    do
      getProjectName $pid
      echo "   Adjust Perms for $pid - $projectName"
      adjustProjectPermissions $pid
      adjustBranchPermissions $pid
    done
  done
}


updateProjectFile () {

  getSubgroupList $studentGroup
  echo "Subgroups: $group_list"
  for gid in $group_list
  do
    getGroupName $gid
    echo "================================================="
    echo "Group for $pid - $groupName"
    getProjectsForGroups $gid
    for pid in $project_list
    do
      getProjectName $pid
      projectId=$pid
      pushAccessLevel=30
      mergeAccessLevel=30
      unprotectAccessLevel=40
      adjustBranchPermissions
      echo "   UpdateFile $fileName for $pid - $projectName"
      curlString="curl -s --request PUT --header \"PRIVATE-TOKEN: glpat-H_JYihq-5x31-yWxtDmk\""
      curlString+=" -F \"branch=main\""
      curlString+=" -F \"author_email=pwb0016@auburn.edu\""
      curlString+=" -F \"author_name=Peter Baljet\""
      curlString+=" -F \"content=<$fileName\""
      curlString+=" -F \"commit_message=Remove -app from url\""
      curlString+=" https://gitlab.com/api/v4/projects/$pid/repository/files/$repositoryPath"
      echo $curlString
      result=`eval $curlString`
      echo $result
      pushAccessLevel=0
      adjustBranchPermissions
      echo "Pausing for 5 seconds"
      sleep 5
    done
  done
}

#
# Setup Class
#
setupClass() {

  studentFile=$1
  dirLocation=$2
  classGroup=$3

  echo "Setting up class from student file $studentFile"

  IFS=$'\n'
  read -d '' -r -a students < $1

  echo "Creating student directory"
  mkdir ${dirLocation}/students

  echo "Creating directory for each student"

  for student in ${students[@]}
  do
    directory="students/${student}"
    echo "Creating directory for $directory"
    mkdir  "${dirLocation}/students/${student}"
    echo "Creating Gitlab group $student under $classGroup"
    createGroup $student $classGroup
    echo "Inviting ${student}@auburn.edu to $createdGroupId "
    inviteUserToGroup $student $createdGroupId
  done

}

#
# Invite User
#
inviteUserToGroup() {

echo "Inviting $1 to group $2"
curl --request POST --url "https://gitlab.com/api/v4/groups/${2}/invitations" \
     --data "email=${1}@auburn.edu&access_level=40" \
     --header "PRIVATE-TOKEN: glpat-H_JYihq-5x31-yWxtDmk"
}

usage (){
  echo "gitlab <command> <parameters>"
  echo ""
  echo "Commands: "
  echo "   setup-class <student file> <directory> <group id> "
  echo "   invite-user <student> <group id> "
  echo "   proj-info <project id>"
  echo "   proj-adjust-perms <project id>"
  echo "   set-proj-perm <project id> <permission> <value>"
  echo "   get-proj-perm <project id> <permission>"
  echo "   get-group-projects <group id>"
  echo "   get-group-name <group id>"
  echo "   branch-adjust-perms <project id> <push perm> <merge perm > <unprotect perm>"
  echo "   proj-cycle <group id>"
  echo "   proj-cycle-set-perms <group id> <filter>"
  echo "   proj-update-file <group id> <project name> <local file> <repository path>"
  echo "   load-proj <group id> <project name> <path name> <import file>"
  echo "   export-proj <project id>"
  echo "   create_proj <group id> <file_name>"
  echo "   create-group <group name> <parent group id>"
  echo "   delete-group <project id> <full text path>"
  echo "   get-group-info <group id>"
  echo "   branch-adjust-perms <project id> <push perm> <merge perm> <unprotect perm>"
  echo "   create-sq-users <student file>"
  echo "   create-sq-projects <project name> <student file> <quality gate>"
  echo "   create-sq-proj-user <project name> <student>"
  echo ""

}

echo "Parameters: $1"

case $1 in

  "setup-class")
    if [ -z $2 ]; then echo "No student file specified: setup-class <student file> <directory> <group id>"; exit; fi
    if [ -z $3 ]; then echo "No directory specified : setup-class <student file> <directory> <group id>"; exit; fi
    if [ -z $4 ]; then echo "No group id specified: setup-class <student file> <directory> <group id>"; exit; fi
    setupClass $2 $3 $4
    ;;

  "invite-user")
    if [ -z $2 ]; then echo "No user specified"; exit; fi
    if [ -z $3 ]; then echo "No group specified"; exit; fi
    inviteUserToGroup $2 $3
    ;;

  "proj-info")
    if [ -z $2 ]; then echo "No project specified"; exit; fi
    getProjectInfo $2
    ;;

  "proj-set-perms")
    if [ -z $2 ]; then echo "No project specified"; exit; fi
    adjustProjectPermissions $2
    ;;

  "set-proj-perm")
    if [ -z $2 ]; then echo "No project specified"; exit; fi
    if [ -z $3 ]; then echo "Permission specified"; exit; fi
    if [ -z $4 ]; then echo "Permission value specified"; exit; fi
    setProjectPermissions $2 $3 $4
    ;;

  "get-group-projects")
    if [ -z $2 ]; then echo "No group specified"; exit; fi
    getProjectsForGroups $2
    ;;

  "delete-group")
    if [ -z $2 ]; then echo "No group name specified: delete-group <group id> <full text path>"; exit; fi
    if [ -z $3 ]; then echo "No group full path specified: delete-group <group id> <full text path>"; exit; fi
    deleteGroup $2 $3
    ;;

  "create-group")
    if [ -z $2 ]; then echo "No group name specified: create-group <group name> <parent id>"; exit; fi
    if [ -z $3 ]; then echo "No parent id specified"; exit; fi
    createGroup "$2" $3
    ;;

  "get-group-name")
    if [ -z $2 ]; then echo "No group specified"; exit; fi
    getGroupName $2
    ;;

  "get-group-info")
    if [ -z $2 ]; then echo "No group specified"; exit; fi
    getGroupInfo $2
    ;;

  "get-proj-perm")
    if [ -z $2 ]; then echo "No project specified"; exit; fi
    if [ -z $3 ]; then echo "Permission specified"; exit; fi
    getProjectPermission $2 $3
    ;;

  "proj-adjust-perms")
    if [ -z $2 ]; then echo "No project specified"; exit; fi
    adjustProjectPermissions $2
    ;;

  "proj-cycle")
    if [ -z $2 ]; then echo "No group specified"; exit; fi
    projectFilter=$3
    cycleThroughProjects $2 $3
    ;;

  "proj-cycle-set-perms")
    if [ -z $2 ]; then echo "No group specified"; exit; fi
    if [ -z $3 ]; then echo "No project filter specified"; exit; fi
    projectFilter=$3
    groupId=$2
    cycleThroughProjectsSetPerms
    ;;

  "proj-cycle-temp")
    if [ -z $2 ]; then echo "No group specified"; exit; fi
    if [ -z $3 ]; then echo "No perm specified"; exit; fi
    if [ -z $4 ]; then echo "No project filter specified"; exit; fi
    projectFilter=$4
    permId=$3
    groupId=$2
    cycleThroughProjectsTemp $2 $3
    ;;

  "export-proj")
    if [ -z $2 ]; then echo "No proejct id specified"; exit; fi
    exportProject $2
    ;;

  "load-proj")
    if [ -z $2 ]; then echo "No group specified: load-proj <group id> <project name> <path name> <import file>"; exit; fi
    if [ -z "$3" ]; then echo "No Project Name specified: load-proj <group id> <project name> <path name> <import file>"; exit; fi
    if [ -z $4 ]; then echo "No Path specified: load-proj <group id> <project name> <path name> <import file>"; exit; fi
    if [ -z $5 ]; then echo "No import file specified: load-proj <group id> <project name> <path name> <import file>"; exit; fi
    projectId=$2
    loadProjectIntoGroups $2 "$3" $4 $5
    ;;

  "import-project")
    if [ -z $2 ]; then echo "No group specified: create-project <group id> <project name> <path name> <import file>"; exit; fi
    if [ -z "$3" ]; then echo "No Project Name specified: create-project <group id> <project name> <path name> <import file>"; exit; fi
    if [ -z $4 ]; then echo "No Path specified: create-project <group id> <project name> <path name> <import file>"; exit; fi
    if [ -z $5 ]; then echo "No import file specified: create-project <group id> <project name> <path name> <import file>"; exit; fi
    importProject $2 "$3" $4 $5
    ;;

  "create-project")
    if [ -z $2 ]; then echo "No group specified"; exit; fi
    if [ -z $3 ]; then echo "No file specified"; exit; fi
    createProject $2 $3
    ;;

  "add-sq-users")
    if [ -z $2 ]; then echo "No student file specified. Usage: add-sonarqube-users <student file>"; exit; fi
    addSonarqubeUsers $2
    ;;

  "create-sq-projects")
    if [ -z $2 ]; then echo "No project name specified. Usage: add-sq-proj <project name> <student file> <quality gate>"; exit; fi
    if [ -z $3 ]; then echo "No student file specified. Usage: add-sq-proj <project name> <student file> <quality gate>"; exit; fi
    if [ -z $3 ]; then echo "No quality gate specified. Usage: add-sq-proj <project name> <student file> <quality gate>"; exit; fi
    createSonarQubeProjects $2 $3 $4
    ;;

  "create-sq-proj-user")
    if [ -z $2 ]; then echo "No project name specified. Usage: create-sq-proj-user <project name> <student> <quality gate>"; exit; fi
    if [ -z $3 ]; then echo "No student  specified. Usage: create-sq-proj-user <project name> <student file> <quality gate>"; exit; fi
    if [ -z $4 ]; then echo "No quality gate  specified. Usage: create-sq-proj-user <project name> <student file> <quality gate>"; exit; fi
    addSonarProjectForUser $2 $3 $4
    ;;

  "delete-sq-projects")
    if [ -z $2 ]; then echo "No project name specified. Usage: create-sq-proj-user <project name> <student> <quality gate>"; exit; fi
    if [ -z $3 ]; then echo "No student  specified. Usage: create-sq-proj-user <project name> <student file> <quality gate>"; exit; fi
    if [ -z $4 ]; then echo "No quality gate  specified. Usage: create-sq-proj-user <project name> <student file> <quality gate>"; exit; fi
    deleteSonarQubeProjects $2 $3 $4
    ;;

  "proj-update-file")
    if [ -z $2 ]; then echo "No group specified: proj-update-file <group id> <project name> <local file> <repository path"; exit; fi
    if [ -z "$3" ]; then echo "No group specified: proj-update-file <group id> <project name> <local file> <repository path"; exit; fi
    if [ -z $4 ]; then echo "No group specified: proj-update-file <group id> <project name> <local file> <repository path"; exit; fi
    if [ -z $5 ]; then echo "No group specified: proj-update-file <group id> <project name> <local file> <repository path"; exit; fi
    studentGroup=$2
    projectFilter="$3"
    fileName=$4
    repositoryPath=$5
    updateProjectFile
    ;;

  "branch-adjust-perms")
    if [ -z $2 ]; then echo "No project id specified: branch-adjust-perms <project id> <push perm> <merge perm> <unprotect perm>"; exit; fi
    if [ -z $3 ]; then echo "No push perm specified: branch-adjust-perms <project id> <push perm> <merge perm> <unprotect perm>"; exit; fi
    if [ -z $4 ]; then echo "No merge perm specified: branch-adjust-perms <project id> <push perm> <merge perm> <unprotect perm>"; exit; fi
    if [ -z $5 ]; then echo "No unprotect perm specified: branch-adjust-perms <project id> <push perm> <merge perm> <unprotect perm>"; exit; fi
    projectId=$2
    pushAccessLevel=$3
    mergeAccessLevel=$4
    unprotectAccessLevel=$5
    adjustBranchPermissions
    ;;


  "fix")
    fix $2
    ;;

  "echo")
    echo $student_group_id
    ;;

  *)
    echo "Unknown parameter: $1"
    usage
    exit 0
    ;;
esac






