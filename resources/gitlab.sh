#!/bin/bash

#
# Gitlab private token to use
#

getGroupName () {
#   echo "Getting Group name $1"
   groupName=`curl -s --request GET --header "PRIVATE-TOKEN: glpat-RXNsASK2eK1zdN-UL3yd" --url https://gitlab.com/api/v4/groups/$1 | jq -rj '.name'`
   echo "Name: $groupName"
}

getProjectName () {
#   echo "Getting Project name $1"
   projectName=`curl -s --request GET --header "PRIVATE-TOKEN: glpat-RXNsASK2eK1zdN-UL3yd" --url https://gitlab.com/api/v4/projects/$1 | jq -rj '.name'`
   echo "Name: $projectName"
}

getSubgroupList () {
   echo "Getting subgroups for $1"
   group_list=`curl -s --request GET --header "PRIVATE-TOKEN: glpat-RXNsASK2eK1zdN-UL3yd" --url https://gitlab.com/api/v4/groups/$1/subgroups | jq -rj '.[].id | tostring + " "'`
}

adjustProjectPermissions() {
  project_url="https://gitlab.com/api/v4/projects/$1"
  echo "Adjust Project Permissions $project_url"
  curl -s --request PUT --header "PRIVATE-TOKEN: glpat-RXNsASK2eK1zdN-UL3yd" --url $project_url --data "jobs_enabled=true&remove_source_branch_after_merge=false&wiki_enabled=false&snippets_enabled=false&analytics_access_level=disabled&issues_enabled=false&security_and_compliance_access_level=disabled&requirements_enabled=false&pages_access_level=disabled&=operations_access_leveldisabled&packages_enabled=false&service_desk_enabled=false&container_registry_enabled=false&builds_access_level=disabled&operations_access_level=disabled&container_registry_access_level=disabled&emails_disabled=true"  | jq
}

setProjectPermissions() {
  project_url="https://gitlab.com/api/v4/projects/$1"
  echo "Setting Project Permissions $project_url: $2=$3"
  curl -s --request PUT --header "PRIVATE-TOKEN: glpat-RXNsASK2eK1zdN-UL3yd" --url $project_url --data "$2=$3" | jq
}


getProjectBranches() {
  project_url="https://gitlab.com/api/v4/projects/$1/repository/branches"
  getProjectName $1
#  echo "Getting branches for $project_url: "
  curl -s --request GET --header "PRIVATE-TOKEN: glpat-RXNsASK2eK1zdN-UL3yd" --url $project_url | jq '.[].name'
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
  curl -s --request DELETE --header "PRIVATE-TOKEN: glpat-RXNsASK2eK1zdN-UL3yd" $project_url/main
  echo "\tAdd Protection $project_url"
  curl -s --request POST --header "PRIVATE-TOKEN: glpat-RXNsASK2eK1zdN-UL3yd" --url "$project_url?name=main&push_access_level=30&merge_access_level=30&unprotect_access_level=40" | jq
  echo $result
}

getProjectsForGroups () {
  project_list=""
  project_url="https://gitlab.com/api/v4/groups/$1/projects"
  filter="select( .name | contains(\"2a\"))"
  echo $filter
  echo "Retrieving $project_url"
#  project_list=`curl -s --request GET --header "PRIVATE-TOKEN: glpat-RXNsASK2eK1zdN-UL3yd" --url $project_url | jq -rj '.[].id | tostring + " "'`
  project_list=`curl -s --request GET --header "PRIVATE-TOKEN: glpat-RXNsASK2eK1zdN-UL3yd" --url $project_url | jq -rj '.[] | select( .name | contains("2a")) | .id'`
  echo $project_list
}

getProjectInfo () {
    project_url="https://gitlab.com/api/v4/projects/$1"
    echo "Retrieving Info for $project_url"
    curl -s --request GET --header "PRIVATE-TOKEN: glpat-zsFLW8a6faLu7pv3dGbk" --url $project_url | jq

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
    done
  done
}

echo "Parameters: $1"

case $1 in

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

  "get-group-name")
    if [ -z $2 ]; then echo "No group specified"; exit; fi
    getGroupName $2
    ;;

  "get-proj-perm")
    if [ -z $2 ]; then echo "No project specified"; exit; fi
    if [ -z $3 ]; then echo "Permission specified"; exit; fi
    getProjectPermission $2 $3
    ;;

  "proj-cycle")
    if [ -z $2 ]; then echo "No group specified"; exit; fi
    cycleThroughProjects 51696684
    ;;

  *)
    echo "Unknown parameter: $1"
    exit 0
    ;;
esac






