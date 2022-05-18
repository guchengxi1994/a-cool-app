# -*- coding: utf-8 -*-
"""
Module implementing Dialog.
"""

from PyQt5.QtCore import QThread, pyqtSignal
from PyQt5.QtWidgets import QDialog
from PyQt5 import QtWidgets
from UI import Ui_download
import os
import sys
import requests


class downloadThread(QThread):

    download_proess_signal = pyqtSignal(int)

    def __init__(self, download_url, filesize, fileobj, buffer):
        super(downloadThread, self).__init__()
        self.download_url = download_url
        self.filesize = filesize
        self.fileobj = fileobj
        self.buffer = buffer

    def run(self):
        try:
            f = requests.get(self.download_url, stream=True)
            offset = 0
            for chunk in f.iter_content(chunk_size=self.buffer):
                if not chunk:
                    break
                self.fileobj.seek(offset)
                self.fileobj.write(chunk)
                offset = offset + len(chunk)
                proess = offset / int(self.filesize) * 100
                self.download_proess_signal.emit(int(proess))
            self.fileobj.close()
            self.exit(0)
        except Exception as e:
            print(e)


class download(QDialog, Ui_download):
    """
    下载类实现
    """
    def __init__(self, download_url, auto_close=True, parent=None):
        """
        Constructor
        
        @download_url:下载地址
        @auto_close:下载完成后时候是否需要自动关闭
        """
        super(download, self).__init__(parent)
        self.setupUi(self)
        self.progressBar.setValue(0)
        self.downloadThread = None
        self.download_url = download_url
        self.filesize = None
        self.fileobj = None
        self.auto_close = auto_close
        self.download()

    def download(self):
        self.filesize = requests.get(self.download_url,
                                     stream=True).headers['Content-Length']
        path = os.path.join("update", os.path.basename(self.download_url))
        self.fileobj = open(path, 'wb')
        self.downloadThread = downloadThread(self.download_url,
                                             self.filesize,
                                             self.fileobj,
                                             buffer=10240)
        self.downloadThread.download_proess_signal.connect(
            self.change_progressbar_value)
        self.downloadThread.start()

    def change_progressbar_value(self, value):
        self.progressBar.setValue(value)
        if self.auto_close and value == 100:
            self.close()


if __name__ == '__main__':
    app = QtWidgets.QApplication(sys.argv)
    # for test
    ui = download(
        "https://download.pytorch.org/whl/cu111/torchvision-0.11.3%2Bcu111-cp38-cp38-linux_x86_64.whl"
    )
    ui.show()
    sys.exit(app.exec_())