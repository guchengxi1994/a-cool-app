'''
Descripttion: 
version: 
Author: xiaoshuyui
email: guchengxi1994@qq.com
Date: 2022-04-10 12:20:32
LastEditors: xiaoshuyui
LastEditTime: 2022-04-10 12:53:18
'''
import uvicorn
from fastapi import FastAPI

from common import __backend_version__, __frontend_version__

app = FastAPI()


@app.get("/{where}")
async def root(where):
    return {"message": "XiaoShuYuI, the best engineer of {}".format(where)}


if __name__ == "__main__":
    uvicorn.run("app:app", host="0.0.0.0", port=52341, log_level="info")
