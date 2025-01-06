import sys
import os
import subprocess
from PyQt5.QtWidgets import (QApplication, QMainWindow, QWidget, QVBoxLayout,
                            QHBoxLayout, QLabel, QSpinBox, QPushButton,
                            QMessageBox, QButtonGroup)
from PyQt5.QtGui import QPixmap
from PyQt5.QtCore import Qt

class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Comic Chapter Generator")
        self.setMinimumWidth(800)

        # Create main widget and layout
        main_widget = QWidget()
        self.setCentralWidget(main_widget)
        main_layout = QHBoxLayout(main_widget)

        # Left side controls
        left_layout = QVBoxLayout()

        # Input fields
        # Start and End numbers
        numbers_layout = QHBoxLayout()
        start_layout = QVBoxLayout()
        start_label = QLabel("Start Number:")
        self.start_spin = QSpinBox()
        self.start_spin.setRange(0, 9999)
        start_layout.addWidget(start_label)
        start_layout.addWidget(self.start_spin)

        end_layout = QVBoxLayout()
        end_label = QLabel("End Number:")
        self.end_spin = QSpinBox()
        self.end_spin.setRange(0, 9999)
        end_layout.addWidget(end_label)
        end_layout.addWidget(self.end_spin)

        numbers_layout.addLayout(start_layout)
        numbers_layout.addLayout(end_layout)
        left_layout.addLayout(numbers_layout)

        # Text position buttons
        position_label = QLabel("Text Position:")
        left_layout.addWidget(position_label)

        self.position_group = QButtonGroup()
        position_buttons_layout = QHBoxLayout()

        positions = ["Upper", "Middle", "Lower"]
        for i, pos in enumerate(positions):
            btn = QPushButton(pos)
            btn.setCheckable(True)
            self.position_group.addButton(btn, i)
            position_buttons_layout.addWidget(btn)

        self.position_group.buttons()[0].setChecked(True)
        left_layout.addLayout(position_buttons_layout)

        # Text color buttons
        color_label = QLabel("Text Color:")
        left_layout.addWidget(color_label)

        self.color_group = QButtonGroup()
        color_buttons_layout = QHBoxLayout()

        colors = ["White", "Gray"]
        for i, color in enumerate(colors):
            btn = QPushButton(color)
            btn.setCheckable(True)
            self.color_group.addButton(btn, i)
            color_buttons_layout.addWidget(btn)

        self.color_group.buttons()[0].setChecked(True)
        left_layout.addLayout(color_buttons_layout)

        # Number of digits
        digits_layout = QVBoxLayout()
        digits_label = QLabel("Number of Digits:")
        self.digits_spin = QSpinBox()
        self.digits_spin.setRange(1, 4)
        digits_layout.addWidget(digits_label)
        digits_layout.addWidget(self.digits_spin)
        left_layout.addLayout(digits_layout)

        # Generate button
        generate_button = QPushButton("Generate")
        generate_button.clicked.connect(self.generate_chapters)
        left_layout.addWidget(generate_button)

        # Add stretch to push everything to the top
        left_layout.addStretch()

        # Add left layout to main layout
        main_layout.addLayout(left_layout)

        # Right side preview
        preview_label = QLabel()
        if os.path.exists("chapter.webp"):
            pixmap = QPixmap("chapter.webp")
            scaled_pixmap = pixmap.scaled(400, 400, Qt.KeepAspectRatio)
            preview_label.setPixmap(scaled_pixmap)
        else:
            preview_label.setText("Preview image not found")
        preview_label.setAlignment(Qt.AlignCenter)
        main_layout.addWidget(preview_label)

        # Make script executable
        if os.path.exists("gen_cbz.sh"):
            os.chmod("gen_cbz.sh", 0o755)

    def generate_chapters(self):
        reply = QMessageBox.question(self, 'Confirmation',
                                   "Warning: This action will perform several operations.\n"
                                   "Ensure that the image 'chapter.webp' exists.\n"
                                   "Check the color and position of the text.\n"
                                   "Take into account how many digits the series is.\n"
                                   "Please take into account chapters #.5 (only).\n"
                                   "Do you want to continue?",
                                   QMessageBox.Yes | QMessageBox.No)

        if reply == QMessageBox.Yes:
            command = f'./gen_cbz.sh << EOL\ny\n{self.start_spin.value()}\n{self.end_spin.value()}\n'
            command += f'{self.position_group.checkedId() + 1}\n'
            command += f'{self.color_group.checkedId() + 1}\n'
            command += f'{self.digits_spin.value()}\nEOL'

            try:
                process = subprocess.Popen(command, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
                stdout, stderr = process.communicate()

                if process.returncode == 0:
                    QMessageBox.information(self, "Success", "Chapters generated successfully!")
                else:
                    QMessageBox.critical(self, "Error", f"Error generating chapters:\n{stderr.decode()}")
            except Exception as e:
                QMessageBox.critical(self, "Error", f"Error executing script: {str(e)}")

if __name__ == '__main__':
    app = QApplication(sys.argv)
    window = MainWindow()
    window.show()
    sys.exit(app.exec_())
