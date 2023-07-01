#!/bin/bash


student_group_id=68990640


fix() {

  getSubgroupList $1

  for groupId in $group_list
  do
    echo $groupId
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
    mkdir  "$directory"
#    echo "Creating Gitlab group under $classGroup"
#    createGroup $line $classGroup
    echo "Inviting ${line}@auburn.edu to $createdGroupId "
    inviteUserToGroup $line $createdGroupId
  done

}


cycleSonarProject() {

  projectName=$1
  studentFile=$2
  qualityGate=$3

  IFS=$'\n'
  read -d '' -r -a students < $studentFile

  echo "Adding students..."

  for student in ${students[@]}
  do
    echo "Add Project for ${student}"
    addSonarProjectForUser $projectName $student
  done
}
#
# Setup SonarQube
#
addSonarProjectForUser() {

    echo "Adding SonarQube project ${1} for ${2} quality gate ${3}"
    curlString="curl -s --request POST --url \"https://au-csse-cpsc4970.com/api/projects/create\" --header \"Authorization: Bearer squ_fc0bf0abd5dccc1f812aa79aaf8a2c05ce97b3d9\" --data \"project=${1}-${2}&name=${1}-${2}&visibility=private\""
    eval $curlString
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
    curlString="curl -s --request POST --url \"https://au-csse-cpsc4970.com/api/qualitygates/select\" --header \"Authorization: Bearer squ_fc0bf0abd5dccc1f812aa79aaf8a2c05ce97b3d9\" --data \"projectKey=${1}-${2}&gateName=${3}\""
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
  createdGroupId=`curl -s --request POST --url "https://gitlab.com/api/v4/groups" --data "{ \"name\": \"${1}\", \"path\": \"${1}\", \"parent_id\": \"${2}\" }" --header "PRIVATE-TOKEN: glpat-t8H-qytSodB5BCcT2oyH" --header "Content-Type: application/json" | jq -rj '.id'`
  echo "Created group $createdGroupId"

}
#
# Delete Group
#
deleteGroup() {

  echo "Deleting group $1 $2"
  curl --request DELETE --url "https://gitlab.com/api/v4/groups/${1}" --header "PRIVATE-TOKEN: glpat-t8H-qytSodB5BCcT2oyH"
  curl --request DELETE --url "https://gitlab.com/api/v4/groups/${1}" --data "permanently_remove=true&full_path=${2}" --header "PRIVATE-TOKEN: glpat-t8H-qytSodB5BCcT2oyH"
  echo "Done"

}

#
# Invite User
#
inviteUserToGroup() {

echo "Inviting $1 to group $2"
curl --request POST --url "https://gitlab.com/api/v4/groups/${2}/invitations" \
     --data "email=${1}@auburn.edu&access_level=40" \
    --header "PRIVATE-TOKEN: glpat-t8H-qytSodB5BCcT2oyH"
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
  commandString="curl -s --request POST --url \"https://gitlab.com/api/v4/projects/remote-import-s3\" --header \"PRIVATE-TOKEN: glpat-t8H-qytSodB5BCcT2oyH\" --header 'Content-Type: application/json' --data  '{\"name\": \"${projectName}\",\"path\": \"${projectSlug}\",\"namespace\": \"${groupId}\",\"region\": \"us-east-2\", \"bucket_name\": \"cpsc4970-assignments\",\"file_key\": \"${filename}\",\"access_key_id\": \"AKIAR7BGN267JKVFTFPU\", \"secret_access_key\": \"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\"}'"
  # echo $commandString
  result=`eval $commandString`
  message=`echo ${result} | jq -rj '.message'`
  if [ $message == "null" ] ; then
    id=`echo ${result} | jq -rj '.id | tostring'`
    echo "Id: ${id}"
    adjustProjectPermissions $id
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
  --header "PRIVATE-TOKEN: glpat-t8H-qytSodB5BCcT2oyH" \
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
  --header "PRIVATE-TOKEN: glpat-t8H-qytSodB5BCcT2oyH"
sleep 5
curl --request GET \
  --url "https://gitlab.com/api/v4/projects/$1/export/download" \
  --header "PRIVATE-TOKEN: glpat-t8H-qytSodB5BCcT2oyH" \
  --output "assign2b.tar.gz"
}


getGroupInfo () {
#   echo "Getting Group name $1"
   groupName=`curl -s --request GET --header "PRIVATE-TOKEN: glpat-t8H-qytSodB5BCcT2oyH" --url https://gitlab.com/api/v4/groups/$1 | jq`
   echo "Name: $groupName"
}


getGroupName () {
#   echo "Getting Group name $1"
   groupName=`curl -s --request GET --header "PRIVATE-TOKEN: glpat-t8H-qytSodB5BCcT2oyH" --url https://gitlab.com/api/v4/groups/$1 | jq -rj '.name'`
   echo "Name: $groupName"
}

getProjectName () {
#   echo "Getting Project name $1"
   projectName=`curl -s --request GET --header "PRIVATE-TOKEN: glpat-t8H-qytSodB5BCcT2oyH" --url https://gitlab.com/api/v4/projects/$1 | jq -rj '.name'`
   echo "Name: $projectName"
}

getSubgroupList () {
   echo "Getting subgroups for $1"
   group_list=`curl -s --request GET --header "PRIVATE-TOKEN: glpat-t8H-qytSodB5BCcT2oyH" --url https://gitlab.com/api/v4/groups/$1/subgroups?per_page=100 | jq -rj '.[].id | tostring + " "'`
}

adjustProjectPermissions() {
  project_url="https://gitlab.com/api/v4/projects/$1"
  echo "Adjust Project Permissions $project_url"
  permString="security_and_compliance_access_level=enabled&"
  permString+="releases_access_level=enabled&"
  permString+="security_and_compliance_access_level=disabled"
  permString+="feature_flags_access_level=disabled&"
  permString+="infrastructure_access_level=disabled&"
  permString+="monitor_access_level=disabled&"
  permString+="jobs_enabled=false&"
  permString+="remove_source_branch_after_merge=false&"
  permString+="wiki_enabled=false&"
  permString+="snippets_enabled=false&"
  permString+="analytics_access_level=disabled&"
  permString+="issues_enabled=false&"
  permString+="security_and_compliance_access_level=disabled&"
  permString+="requirements_enabled=false&"
  permString+="pages_access_level=disabled&"
  permString+="operations_access_level=disabled&"
  permString+="packages_enabled=false&"
  permString+="service_desk_enabled=false&"
  permString+="container_registry_enabled=false&"
  permString+="builds_access_level=disabled&"
  permString+="emails_disabled=true"
  echo $permString
  curl -s --request PUT --header "PRIVATE-TOKEN: glpat-t8H-qytSodB5BCcT2oyH" --url ${project_url} --data ${permString} | jq
}

setProjectPermissions() {
  project_url="https://gitlab.com/api/v4/projects/$1"
  echo "Setting Project Permissions $project_url: $2=$3"
  curl -s --request PUT --header "PRIVATE-TOKEN: glpat-t8H-qytSodB5BCcT2oyH" --url $project_url --data "$2=$3" | jq
}


getProjectBranches() {
  project_url="https://gitlab.com/api/v4/projects/$1/repository/branches"
  getProjectName $1
#  echo "Getting branches for $project_url: "
  curl -s --request GET --header "PRIVATE-TOKEN: glpat-t8H-qytSodB5BCcT2oyH" --url $project_url | jq '.[].name'
}

getProjectPermission() {
  project_url="https://gitlab.com/api/v4/projects/$1"
  echo "Getting Project Permissions $project_url: $2"
  jq_filter="'.$2'"
  echo $jq_filter
  curl -s --request GET --header "PRIVATE-TOKEN: glpat-t8H-qytSodB5BCcT2oyH" --url $project_url | jq
}

adjustBranchPermissions() {
  project_url="https://gitlab.com/api/v4/projects/$1/protected_branches"
  echo "\tDeleting existing main protection: $project_url"
  curl -s --request DELETE --header "PRIVATE-TOKEN: glpat-t8H-qytSodB5BCcT2oyH" $project_url/main
  echo "\tAdd Protection $project_url"
  curl -s --request POST --header "PRIVATE-TOKEN: glpat-t8H-qytSodB5BCcT2oyH" --url "$project_url?name=main&push_access_level=30&merge_access_level=30&unprotect_access_level=40" | jq
  echo $result
}

getProjectsForGroups () {
  project_list=""
  project_url="https://gitlab.com/api/v4/groups/$1/projects"
  filter="select( .name | contains(\"${projectFilter}\"))"
  echo $filter
  echo "Retrieving $project_url"
  curlString="curl -s --request GET --header \"PRIVATE-TOKEN: glpat-t8H-qytSodB5BCcT2oyH\" --url ${project_url} | jq -rj '.[] | select( .name | contains(\"${projectFilter}\")) | .id'"
#  project_list=`curl -s --request GET --header "PRIVATE-TOKEN: glpat-t8H-qytSodB5BCcT2oyH" --url $project_url | jq -rj '.[].id | tostring + " "'`
#  project_list=`curl -s --request GET --header "PRIVATE-TOKEN: glpat-t8H-qytSodB5BCcT2oyH" --url $project_url | jq -rj '.[] | select( .name | contains("${projectFilter}")) | .id'`
  echo curlString
  project_list=`eval $curlString`
  echo $project_list
}

getProjectInfo () {
    project_url="https://gitlab.com/api/v4/projects/$1"
    echo "Retrieving Info for $project_url"
    curl -s --request GET --header "PRIVATE-TOKEN: glpat-zsFLW8a6faLu7pv3dGbk" --url $project_url | jq

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

usage (){
  echo "gitlab <command> <parameters>"
  echo ""
  echo "Commands: "
  echo "   setup-class <student file> <directory> <group id> "
  echo "   proj-info <project id>"
  echo "   adjust-proj-perm <project id>"
  echo "   set-proj-perm <project id> <permission> <value>"
  echo "   get-proj-perm <project id> <permission>"
  echo "   get-group-projects <group id>"
  echo "   get-group-name <group id>"
  echo "   proj-cycle <group id>"
  echo "   proj-set-perms <project id>"
  echo "   load-proj <group id> <project name> <path name> <import file>"
  echo "   export-proj <project id>"
  echo "   create_proj <group id> <file_name>"
  echo "   create-group <group name> <parent group id>"
  echo "   delete-group <project id> <full text path>"
  echo "   get-group-info <group id>"
  echo "   create-sq-users <student file>"
  echo "   create-sq-proj <project name> <student file>"
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

  "export-proj")
    if [ -z $2 ]; then echo "No proejct id specified"; exit; fi
    exportProject $2
    ;;

  "load-proj")
    if [ -z $2 ]; then echo "No group specified: load-proj <group id> <project name> <path name> <import file>"; exit; fi
    if [ -z "$3" ]; then echo "No Project Name specified: load-proj <group id> <project name> <path name> <import file>"; exit; fi
    if [ -z $4 ]; then echo "No Path specified: load-proj <group id> <project name> <path name> <import file>"; exit; fi
    if [ -z $5 ]; then echo "No import file specified: load-proj <group id> <project name> <path name> <import file>"; exit; fi
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

  "add-sq-proj")
    if [ -z $2 ]; then echo "No project name specified. Usage: add-sq-proj <project name> <student file> <quality gate>"; exit; fi
    if [ -z $3 ]; then echo "No student file specified. Usage: add-sq-proj <project name> <student file> <quality gate>"; exit; fi
    if [ -z $3 ]; then echo "No quality gate specified. Usage: add-sq-proj <project name> <student file> <quality gate>"; exit; fi
    addSonarProj $2 $3 $4
    ;;

  "create-sq-proj-user")
    if [ -z $2 ]; then echo "No project name specified. Usage: create-sq-proj-user <project name> <student> <quality gate>"; exit; fi
    if [ -z $3 ]; then echo "No student  specified. Usage: create-sq-proj-user <project name> <student file> <quality gate>"; exit; fi
    if [ -z $4 ]; then echo "No quality gate  specified. Usage: create-sq-proj-user <project name> <student file> <quality gate>"; exit; fi
    addSonarProjectForUser $2 $3 $4
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






