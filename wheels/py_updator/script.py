from PyQt5.QtWidgets import QMainWindow,QPushButton

class MainWindow(QMainWindow):
    def __init__(self, ) -> None:
        super(MainWindow, self).__init__()
        self.initUI()

    def initUI(self):
        self.selectButton = QPushButton("选择文件夹",self)