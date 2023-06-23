#!/bin/bash

#
# Setup Class
#
setupClass() {

  studentFile=$1
  classGroup=$2

  echo "Setting up class from student file $studentFile"

  IFS=$'\n'
  read -d '' -r -a lines < $1

  echo "Creating student directory"
  mkdir students

  echo "Creating directory for each student"

  for line in ${lines[@]}
  do
    directory="students/${line}"
    echo "Creating directory for $directory"
    mkdir  "$directory"
    echo "Creating Gitlab group under $classGroup"
    createGroup $line $classGroup
    echo "Inviting ${line}@auburn.edu to $createdGroupId "
    inviteUserToGroup $line $createdGroupId
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
     --data "email=${1}@gmail.com&access_level=40" \
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
   group_list=`curl -s --request GET --header "PRIVATE-TOKEN: glpat-t8H-qytSodB5BCcT2oyH" --url https://gitlab.com/api/v4/groups/$1/subgroups | jq -rj '.[].id | tostring + " "'`
}

adjustProjectPermissions() {
  project_url="https://gitlab.com/api/v4/projects/$1"
  echo "Adjust Project Permissions $project_url"
  curl -s --request PUT --header "PRIVATE-TOKEN: glpat-t8H-qytSodB5BCcT2oyH" --url $project_url --data "jobs_enabled=true&remove_source_branch_after_merge=false&wiki_enabled=false&snippets_enabled=false&analytics_access_level=disabled&issues_enabled=false&security_and_compliance_access_level=enabled&requirements_enabled=false&pages_access_level=disabled&=operations_access_leveldisabled&packages_enabled=true&service_desk_enabled=false&container_registry_enabled=false&builds_access_level=disabled&operations_access_level=disabled&emails_disabled=true"  | jq
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
  curl -s --request GET --header "PRIVATE-TOKEN: glpat-zsFLW8a6faLu7pv3dGbk" --url $project_url | jq
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
  filter="select( .name | contains(\"Final Exam\"))"
  echo $filter
  echo "Retrieving $project_url"
#  project_list=`curl -s --request GET --header "PRIVATE-TOKEN: glpat-t8H-qytSodB5BCcT2oyH" --url $project_url | jq -rj '.[].id | tostring + " "'`
  project_list=`curl -s --request GET --header "PRIVATE-TOKEN: glpat-t8H-qytSodB5BCcT2oyH" --url $project_url | jq -rj '.[] | select( .name | contains("Final Exam")) | .id'`
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
  echo "commands: "
  echo "setup-class <student file> <Group ID> "
  echo "proj-info <project id>"
  echo "adjust-proj-perm <project id>"
  echo "set-proj-perm <project id> <permission> <value>"
  echo "get-proj-perm <project id> <permission>"
  echo "get-group-projects <group id>"
  echo "get-group-name <group id>"
  echo "proj-cycle <group id>"
  echo "export-proj <project id>"
  echo "create_proj <group id> <file_name>"
  echo "create-group <group name> <parent group id>"
  echo "delete-group <project id> <full text path>"
  echo "get-group-info <group id>"


}

echo "Parameters: $1"

case $1 in

  "setup-class")
    if [ -z $2 ]; then echo "No student file specified: setup-class <student file> <group id>"; exit; fi
    if [ -z $3 ]; then echo "No group id specified: setup-class <student file> <group id>"; exit; fi
    setupClass $2 $3
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

  "adjust-proj-perm")
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

  "proj-cycle")
    if [ -z $2 ]; then echo "No group specified"; exit; fi
    cycleThroughProjects $2
    ;;

  "export-proj")
    if [ -z $2 ]; then echo "No proejct id specified"; exit; fi
    exportProject $2
    ;;

  "load-project")
    if [ -z $2 ]; then echo "No group specified: create-project <group id> <project name> <path name> <import file>"; exit; fi
    if [ -z "$3" ]; then echo "No Project Name specified: create-project <group id> <project name> <path name> <import file>"; exit; fi
    if [ -z $4 ]; then echo "No Path specified: create-project <group id> <project name> <path name> <import file>"; exit; fi
    if [ -z $5 ]; then echo "No import file specified: create-project <group id> <project name> <path name> <import file>"; exit; fi
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

  *)
    echo "Unknown parameter: $1"
    usage
    exit 0
    ;;
esac






