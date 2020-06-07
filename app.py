import os
from flask import Flask, flash, request
from werkzeug.utils import secure_filename
from flask.helpers import send_file

UPLOAD_FOLDER = ''
ALLOWED_EXTENSIONS = {'html'}

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

@app.route('/convert', methods=['POST'])
def upload_file():
    if request.method == 'POST':
        # check if the post request has the file part
        if 'htmlFile' not in request.files:
            flash('No file part')
            return 400
        file = request.files['htmlFile']
        # if user does not select file, browser also
        # return 400
        if file.filename == '':
            flash('No selected file')
            return 400
        if file and allowed_file(file.filename):
            filename = secure_filename(file.filename)
            file.save(os.path.join(app.config['UPLOAD_FOLDER'], "New" + filename))
            os.system(f"phantomjs rasterize.js New{filename} converted.pdf A4")
            return send_file('converted.pdf', attachment_filename='converted.pdf')

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000,debug=True)