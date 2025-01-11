import sys
import os
import subprocess
sys.path.append(os.path.expanduser('~/.local/bin'))
import gen_cbz
from PyQt5.QtWidgets import (QApplication, QMainWindow, QWidget, QVBoxLayout,
                            QHBoxLayout, QLabel, QLineEdit, QComboBox, QPushButton,
                            QListWidget, QTextEdit, QButtonGroup, QRadioButton,
                            QFileDialog)
from PyQt5.QtGui import QPixmap
from PyQt5.QtCore import Qt, QThread, pyqtSignal

class ConvertWorker(QThread):
    output_received = pyqtSignal(str)

    def __init__(self, work_dir):
        super().__init__()
        self.work_dir = work_dir

    def run(self):
        try:
            # Importar la función de conversión
            from convert_img import convert_images_to_webp

            # Crear una función de callback para los mensajes
            def log_callback(message):
                self.output_received.emit(message)

            # Ejecutar la conversión
            convert_images_to_webp(self.work_dir, log_callback)
        except Exception as e:
            self.output_received.emit(f"Error during conversion: {str(e)}")
class ScriptWorker(QThread):
    output_received = pyqtSignal(str)

    def __init__(self, params, work_dir):
        super().__init__()
        self.params = params
        self.work_dir = work_dir

    def run(self):
        try:
            # Parse parameters
            start = self.params[0]
            end = self.params[1]
            position = int(self.params[2])
            color = int(self.params[3])
            digits = int(self.params[4])

            # Función de callback para enviar logs a la GUI
            def log_callback(message):
                self.output_received.emit(message)

            # Procesar capítulos
            gen_cbz.process_chapters(self.work_dir, start, end, position, color, digits, log_callback)

        except Exception as e:
            self.output_received.emit(f"Error: {str(e)}")

class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Comic Chapter Generator")
        self.setFixedSize(1000, 680)
        self.current_path = ""

        main_widget = QWidget()
        self.setCentralWidget(main_widget)
        main_layout = QVBoxLayout(main_widget)

        # Top bar with path and buttons
        top_bar = QWidget()
        top_layout = QHBoxLayout(top_bar)

        # Current comic label
        self.comic_label = QLabel("No comic selected")
        self.comic_label.setStyleSheet("font-weight: bold; color: #2c3e50;")

        self.browse_button = QPushButton("Browse")
        self.browse_button.clicked.connect(self.browse_directory)
        self.krename_button = QPushButton("Open KRename")
        self.krename_button.clicked.connect(self.open_krename)
        self.convert_button = QPushButton("Convert Images")
        self.convert_button.clicked.connect(self.start_conversion)

        top_layout.addWidget(self.comic_label)
        top_layout.addStretch()
        top_layout.addWidget(self.browse_button)
        top_layout.addWidget(self.krename_button)
        top_layout.addWidget(self.convert_button)

        main_layout.addWidget(top_bar)

        # Content area
        content_widget = QWidget()
        content_layout = QHBoxLayout(content_widget)

        # Left panel (Chapters)
        left_panel = QWidget()
        left_layout = QVBoxLayout(left_panel)
        left_layout.addWidget(QLabel("Chapters:"))
        self.folder_list = QListWidget()
        left_layout.addWidget(self.folder_list)

        # Center panel
        center_panel = QWidget()
        center_layout = QVBoxLayout(center_panel)
        center_panel.setFixedWidth(250)

        # Preview
        self.preview_label = QLabel()
        self.preview_label.setFixedSize(150, 200)
        self.update_preview()
        center_layout.addWidget(self.preview_label, alignment=Qt.AlignCenter)

        # Controls
        controls_widget = QWidget()
        controls_layout = QVBoxLayout(controls_widget)
        controls_layout.setContentsMargins(20, 0, 20, 0)

        # Input fields
        controls_layout.addWidget(QLabel("Start Number:"))
        self.start_num = QLineEdit()
        self.start_num.setFixedWidth(160)
        controls_layout.addWidget(self.start_num, alignment=Qt.AlignCenter)

        controls_layout.addWidget(QLabel("End Number:"))
        self.end_num = QLineEdit()
        self.end_num.setFixedWidth(160)
        controls_layout.addWidget(self.end_num, alignment=Qt.AlignCenter)

        # Position radio buttons
        controls_layout.addWidget(QLabel("Position:"))
        position_group = QWidget()
        position_layout = QHBoxLayout(position_group)
        position_group.setFixedWidth(220)
        self.position_group = QButtonGroup()

        positions = ["Upper", "Middle", "Lower"]
        for i, pos in enumerate(positions):
            radio = QRadioButton(pos)
            self.position_group.addButton(radio, i + 1)
            position_layout.addWidget(radio)
        self.position_group.buttons()[0].setChecked(True)
        controls_layout.addWidget(position_group, alignment=Qt.AlignCenter)

        # Color radio buttons
        controls_layout.addWidget(QLabel("Color:"))
        color_group = QWidget()
        color_layout = QHBoxLayout(color_group)
        color_group.setFixedWidth(160)
        self.color_group = QButtonGroup()

        colors = ["White", "Gray"]
        for i, color in enumerate(colors):
            radio = QRadioButton(color)
            self.color_group.addButton(radio, i + 1)
            color_layout.addWidget(radio)
        self.color_group.buttons()[0].setChecked(True)
        controls_layout.addWidget(color_group, alignment=Qt.AlignCenter)

        # Digits radio buttons
        controls_layout.addWidget(QLabel("Digits:"))
        digits_group = QWidget()
        digits_layout = QHBoxLayout(digits_group)
        digits_group.setFixedWidth(160)
        self.digits_group = QButtonGroup()

        digits = ["1", "2", "3", "4"]
        for i, digit in enumerate(digits):
            radio = QRadioButton(digit)
            self.digits_group.addButton(radio, i + 1)
            digits_layout.addWidget(radio)
        self.digits_group.buttons()[0].setChecked(True)
        controls_layout.addWidget(digits_group, alignment=Qt.AlignCenter)

        # Start button
        self.start_button = QPushButton("Start Processing")
        self.start_button.setFixedWidth(160)
        self.start_button.clicked.connect(self.start_processing)
        controls_layout.addWidget(self.start_button, alignment=Qt.AlignCenter)

        center_layout.addWidget(controls_widget)

        # Right panel (Logs)
        right_panel = QWidget()
        right_layout = QVBoxLayout(right_panel)
        right_layout.addWidget(QLabel("Logs:"))
        self.log_text = QTextEdit()
        self.log_text.setReadOnly(True)
        right_layout.addWidget(self.log_text)

        # Add panels to content layout
        content_layout.addWidget(left_panel, 1)
        content_layout.addWidget(center_panel, 2)
        content_layout.addWidget(right_panel, 2)

        main_layout.addWidget(content_widget)

    def browse_directory(self):
        directory = QFileDialog.getExistingDirectory(self, "Select Working Directory")
        if directory:
            self.current_path = directory
            comic_name = os.path.basename(directory)
            self.comic_label.setText(f"Current Comic: {comic_name}")
            os.chdir(directory)
            self.update_preview()
            self.update_folder_list()

    def update_preview(self):
        self.preview_label.clear()
        try:
            image_path = os.path.join(self.current_path, "chapter.webp")
            pixmap = QPixmap(image_path)
            if pixmap.isNull():
                pixmap = QPixmap(150, 200)
                pixmap.fill(Qt.lightGray)
                self.preview_label.setText("No image found\nExpected: chapter.webp")
                self.preview_label.setAlignment(Qt.AlignCenter)
            else:
                scaled_pixmap = pixmap.scaled(150, 200, Qt.KeepAspectRatio, Qt.SmoothTransformation)
                self.preview_label.setPixmap(scaled_pixmap)
        except Exception as e:
            self.preview_label.setText("Error loading image\nExpected: chapter.webp")
            self.preview_label.setAlignment(Qt.AlignCenter)

    def update_folder_list(self):
        if self.current_path:
            folders = [f for f in os.listdir(self.current_path) if os.path.isdir(os.path.join(self.current_path, f))]
            self.folder_list.clear()
            self.folder_list.addItems(sorted(folders))

    def open_krename(self):
        if not self.current_path:
            self.log_text.append("Please select a working directory first")
            return

        try:
            # Copiar la ruta al portapapeles
            clipboard = QApplication.clipboard()
            clipboard.setText(self.current_path)

            # Abrir KRename
            subprocess.Popen(['krename'])
        except Exception as e:
            self.log_text.append(f"Error opening KRename: {str(e)}")

    def start_processing(self):
        if not self.current_path:
            self.log_text.append("Please select a working directory first")
            return

        params = [
            self.start_num.text(),
            self.end_num.text(),
            str(self.position_group.checkedId()),
            str(self.color_group.checkedId()),
            str(self.digits_group.checkedId())
        ]

        self.worker = ScriptWorker(params, self.current_path)
        self.worker.output_received.connect(self.update_log)
        self.worker.finished.connect(self.on_process_finished)
        self.worker.start()
        self.start_button.setEnabled(False)

    def start_conversion(self):
        if not self.current_path:
            self.log_text.append("Please select a working directory first")
            return

        self.convert_worker = ConvertWorker(self.current_path)
        self.convert_worker.output_received.connect(self.update_log)
        self.convert_worker.finished.connect(self.on_conversion_finished)
        self.convert_worker.start()
        self.convert_button.setEnabled(False)

    def update_log(self, text):
        self.log_text.append(text)

    def on_process_finished(self):
        self.start_button.setEnabled(True)
        self.update_folder_list()

    def on_conversion_finished(self):
        self.convert_button.setEnabled(True)
        self.update_folder_list()

if __name__ == '__main__':
    app = QApplication(sys.argv)
    window = MainWindow()
    window.show()
    sys.exit(app.exec_())
