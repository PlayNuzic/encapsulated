import os
import shutil

# Define list of HTML files at the root
html_files = [
    "AcMod y transformaciones.html",
    "Aleatorizador de Elementos 2.html",
    "Formula Temporal.html",
    "Fracciones rítmicas.html",
    "Matriz Rangos Variables.html",
    "Modulacion Escalas_.html",
    "Sucesion entre Escalas Madre.html"
]

# Create folders and move/rename files
for file in html_files:
    folder_name = file.replace(".html", "").replace(" ", "_")
    os.makedirs(folder_name, exist_ok=True)
    if os.path.exists(file):
        shutil.move(file, f"{folder_name}/index.html")

# Create the main index.html
with open("index.html", "w", encoding="utf-8") as f:
    f.write("<!DOCTYPE html>\n<html lang='ca'>\n<head>\n")
    f.write("  <meta charset='UTF-8'>\n  <title>Apps Nuzic</title>\n</head>\n<body>\n")
    f.write("  <h1>Aplicacions Nuzic</h1>\n  <ul>\n")
    for file in html_files:
        folder_name = file.replace(".html", "").replace(" ", "_")
        display_name = file.replace(".html", "")
        f.write(f"    <li><a href='{folder_name}/'>{display_name}</a></li>\n")
    f.write("  </ul>\n</body>\n</html>")
