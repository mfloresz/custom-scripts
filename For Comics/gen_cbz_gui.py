import sys
import os
import subprocess
from PyQt5.QtWidgets import (QApplication, QMainWindow, QWidget, QVBoxLayout,
                            QHBoxLayout, QLabel, QLineEdit, QComboBox, QPushButton,
                            QListWidget, QTextEdit, QButtonGroup, QRadioButton)
from PyQt5.QtGui import QPixmap
from PyQt5.QtCore import Qt, QThread, pyqtSignal

class ScriptWorker(QThread):
    output_received = pyqtSignal(str)

    def __init__(self, params):
        super().__init__()
        self.params = params

    def run(self):
        process = subprocess.Popen(
            ['bash', 'gen_cbz.sh'],
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True
        )

        for response in self.params:
            process.stdin.write(f"{response}\n")
            process.stdin.flush()

        while True:
            output = process.stdout.readline()
            if output == '' and process.poll() is not None:
                break
            if output:
                self.output_received.emit(output.strip())

class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Comic Chapter Generator")
        self.setMinimumSize(1200, 600)

        main_widget = QWidget()
        self.setCentralWidget(main_widget)
        layout = QHBoxLayout(main_widget)

        # Panel izquierdo (lista de carpetas)
        left_panel = QWidget()
        left_layout = QVBoxLayout(left_panel)
        self.folder_list = QListWidget()
        self.update_folder_list()
        left_layout.addWidget(QLabel("Folders:"))
        left_layout.addWidget(self.folder_list)

        # Añadir botón de KRename
        self.krename_button = QPushButton("Open KRename")
        self.krename_button.clicked.connect(self.open_krename)
        left_layout.addWidget(self.krename_button)

        left_panel.setMaximumWidth(200)

        # Panel central
        center_panel = QWidget()
        center_layout = QVBoxLayout(center_panel)

        # Preview de la imagen
        self.preview_label = QLabel()
        pixmap = QPixmap("chapter.webp")
        width = 150
        aspect_ratio = pixmap.height() / pixmap.width()
        height = int(width * aspect_ratio)
        scaled_pixmap = pixmap.scaled(width, height, Qt.KeepAspectRatio, Qt.SmoothTransformation)
        self.preview_label.setPixmap(scaled_pixmap)
        center_layout.addWidget(self.preview_label, alignment=Qt.AlignCenter)

        # Controles
        controls_widget = QWidget()
        controls_layout = QVBoxLayout(controls_widget)

        # Campos de texto
        self.start_num = QLineEdit()
        self.end_num = QLineEdit()
        self.digits_combo = QComboBox()
        self.digits_combo.addItems(["1", "2", "3", "4"])

        # Botones de posición
        position_group = QWidget()
        position_layout = QHBoxLayout(position_group)
        self.position_group = QButtonGroup()

        positions = ["Upper", "Middle", "Lower"]
        for i, pos in enumerate(positions):
            radio = QRadioButton(pos)
            self.position_group.addButton(radio, i + 1)
            position_layout.addWidget(radio)
        self.position_group.buttons()[0].setChecked(True)

        # Botones de color
        color_group = QWidget()
        color_layout = QHBoxLayout(color_group)
        self.color_group = QButtonGroup()

        colors = ["White", "Gray"]
        for i, color in enumerate(colors):
            radio = QRadioButton(color)
            self.color_group.addButton(radio, i + 1)
            color_layout.addWidget(radio)
        self.color_group.buttons()[0].setChecked(True)

        # Añadir controles al layout
        controls_layout.addWidget(QLabel("Start Number:"))
        controls_layout.addWidget(self.start_num)
        controls_layout.addWidget(QLabel("End Number:"))
        controls_layout.addWidget(self.end_num)
        controls_layout.addWidget(QLabel("Position:"))
        controls_layout.addWidget(position_group)
        controls_layout.addWidget(QLabel("Color:"))
        controls_layout.addWidget(color_group)
        controls_layout.addWidget(QLabel("Digits:"))
        controls_layout.addWidget(self.digits_combo)

        controls_widget.setMaximumWidth(300)  # Aumentado para acomodar los botones
        center_layout.addWidget(controls_widget, alignment=Qt.AlignCenter)

        # Botón de inicio
        self.start_button = QPushButton("Start Processing")
        self.start_button.clicked.connect(self.start_processing)
        self.start_button.setMaximumWidth(200)
        center_layout.addWidget(self.start_button, alignment=Qt.AlignCenter)

        # Panel derecho (log)
        right_panel = QWidget()
        right_layout = QVBoxLayout(right_panel)
        self.log_text = QTextEdit()
        self.log_text.setReadOnly(True)
        right_layout.addWidget(QLabel("Log:"))
        right_layout.addWidget(self.log_text)
        right_panel.setMinimumWidth(400)

        # Establecer proporciones del layout principal
        layout.addWidget(left_panel, 1)
        layout.addWidget(center_panel, 2)
        layout.addWidget(right_panel, 3)

    def update_folder_list(self):
        folders = [f for f in os.listdir('.') if os.path.isdir(f)]
        self.folder_list.clear()
        self.folder_list.addItems(folders)


    def open_krename(self):
        try:
            # Obtener la lista de carpetas
            folders = [f for f in os.listdir('.') if os.path.isdir(f)]

            # Crear un archivo temporal con la lista de carpetas
            with open('/tmp/folder_list.txt', 'w') as f:
                for folder in folders:
                    f.write(folder + '\n')

            # Abrir KRename con la lista de carpetas
            process = subprocess.Popen(['krename', '--files-from', '/tmp/folder_list.txt'])

            # Esperar a que KRename se cierre
            process.wait()

            # Actualizar la lista de carpetas
            self.update_folder_list()

            # Eliminar el archivo temporal
            os.remove('/tmp/folder_list.txt')

        except Exception as e:
            self.log_text.append(f"Error opening KRename: {str(e)}")





    def start_processing(self):
        params = [
            'y',
            self.start_num.text(),
            self.end_num.text(),
            str(self.position_group.checkedId()),
            str(self.color_group.checkedId()),
            self.digits_combo.currentText()
        ]

        self.worker = ScriptWorker(params)
        self.worker.output_received.connect(self.update_log)
        self.worker.finished.connect(self.on_process_finished)
        self.worker.start()
        self.start_button.setEnabled(False)

    def update_log(self, text):
        self.log_text.append(text)

    def on_process_finished(self):
        self.start_button.setEnabled(True)
        self.update_folder_list()

if __name__ == '__main__':
    app = QApplication(sys.argv)
    window = MainWindow()
    window.show()
    sys.exit(app.exec_())
