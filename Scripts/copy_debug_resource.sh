#!/bin/sh
export LANG=en_US.UTF-8

#$(cd `dirname $0`/..; pwd)
rootPath=${SRCROOT}
linkProjects=()

# 检查.xcworkspace文件夹是否存在
function checkXcworkspaceDirectoryValid (){
    rootPath=$1
    if [[ ! -d ${rootPath}/PBAPortal.xcworkspace ]]; then
        #未找到.xcworkspace文件，停止执行
        exit 
    fi
}

# 创建临时目录
function createTempDir() {
    tempdir=`mktemp -d ${rootPath}/tmpd.XXXXXX`
    trap "rm -rf $tempdir" EXIT
}

#获取关联debug项目
function getLinkProjects() {
    contentsPath="${rootPath}/PBAPortal.xcworkspace/contents.xcworkspacedata"
    projects=`cat  ${contentsPath}|grep "location"|awk -F ':' '{print $2}'|awk -F '"' '{print $1}'`
    index=0 
    for project in ${projects[@]}; do
        if [[ "${project}" != "PBAPortal.xcodeproj" &&
         "${project}" != "Pods/Pods.xcodeproj" ]]; then
            linkProjects[index]=$(dirname ${project})
            index=$index+1
        fi
    done
    # echo ${linkProjects[@]}
}

#拷贝资源
function copyConfigAndResource() {
    echo "copy $1 bundle resource to PBAPortal!!!"
    project=$1
    #copy page config
    echo "tempdir is:${tempdir}"
    if [[ -d "${project}/Res/Page/Page.bundle" ]]; then
        cp -rf "${project}/Res/Page/Page.bundle" "${tempdir}"  1>/dev/null
    fi
    if [[ -d "${tempdir}/Page.bundle" ]]; then
        echo "${tempdir}/Page.bundle" >> "$resourceToCopy"
    fi
    
    #copy service config
    if [[ -d "${project}/Res/Service/Service.bundle" ]]; then
        cp -rf "${project}/Res/Service/Service.bundle" "${tempdir}"  1>/dev/null
    fi
    if [[ -d "${tempdir}/Service.bundle" ]]; then
        echo "${tempdir}/Service.bundle" >> "$resourceToCopy"
    fi
    
    #copy resource
    if [[ -d "${project}/Res/Resource.bundle" ]]; then
        cp -rf "${project}/Res/Resource.bundle" "${tempdir}"  1>/dev/null
    fi
    if [[ -d "${tempdir}/Resource.bundle" ]]; then
        echo "${tempdir}/Resource.bundle" >> "$resourceToCopy"
    fi
}

# 从编译完的.framework中，拷贝静态资源：.nib|.png|.jpg
function copyOtherResource() {
    for projectPath in ${linkProjects[@]}; do
        project=`basename $projectPath`
#        echo "copy ${project} other resource!!!!"
        projectFramework="${TARGET_BUILD_DIR}/${project}.framework"
        for file in `ls ${projectFramework} | grep -E '.nib|.png|.jpg'`; do
#            echo "copy other file:${file}"
            cp -rf "${projectFramework}/${file}" "${tempdir}"  1>/dev/null
            echo "${tempdir}/${file}" >> "$resourceToCopy"
        done
    done
}

function doResourceCopy(){
    #1: 拷贝config&Resource
    for project in ${linkProjects[@]}; do
        copyConfigAndResource ${project}
    done
    
    #2: 拷贝其它资源
    copyOtherResource
}

function main() {
    #1：检查.xcworkspace文件夹是否存在
    checkXcworkspaceDirectoryValid ${rootPath}
    
    #2: 获取link工程
    getLinkProjects
    if [[ ${#linkProjects[@]} == 0 ]]; then
        #无关联项时不做拷贝操作
        exit
    fi

    #3: 创建临时文件
    createTempDir
    resourceToCopy=${tempdir}/resources-to-copy-${TARGETNAME}.txt
    doResourceCopy

    #4：从temp文件夹中把资源转移到PBAPortal
    if [[ -f "$resourceToCopy" ]]; then
        rsync -avr --copy-links --no-relative --exclude '*/.svn/*' --files-from="$resourceToCopy" / "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
    fi
}

main
