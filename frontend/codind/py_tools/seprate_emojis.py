'''
Descripttion: 
version: 
Author: xiaoshuyui
email: guchengxi1994@qq.com
Date: 2022-02-02 22:10:40
LastEditors: xiaoshuyui
LastEditTime: 2022-02-02 22:20:59
'''
import json

fpath = "D:\\code-find\\frontend\\codind\\assets\\emoji_backup.json"

with open(fpath) as f:
    jsonList:list = json.load(f)
    # print(type(jsonStr))
    res = []
    for i in jsonList:
        if 'FACE' in i['name']:
            res.append(i)
    
    print(json.dumps(res))