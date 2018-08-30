#!/bin/sh

#如果没有修改podspec文件,则直接执行./install.sh命令
#如果修改了podspec文件,则必须先执行./install.sh命令,在执行pod update命令

rm -rf ~/Library/Caches/CocoaPods/Pods/Release/PB*
rm -rf Pods/PB*
pod install
