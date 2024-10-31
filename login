from flask import Flask, render_template, request, redirect, url_for, jsonify, flash
from werkzeug.security import generate_password_hash
from pymongo import MongoClient
from bson import ObjectId

app = Flask(__name__)
app.secret_key = 'your_secret_key'

# MongoDB setup
client = MongoClient('mongodb://localhost:27017/')  # Update with your MongoDB connection
db = client['your_database_name']  # Replace with your database name
users_collection = db['users']

# Route to display users
@app.route('/')
def admin_dashboard():
    users = list(users_collection.find())
    return render_template('index.html', users=users)

# Route to add a new user
@app.route('/add_user', methods=['GET', 'POST'])
def add_user():
    if request.method == 'POST':
        username = request.form.get('username')
        password = request.form.get('password')
        status = bool(request.form.get('status'))
        show_qr = bool(request.form.get('qr'))

        if not username or not password:
            flash("Username and password are required!", "error")
            return redirect(url_for('add_user'))

        hashed_password = generate_password_hash(password)

        new_user = {
            'username': username,
            'password': hashed_password,
            'two_fa_secret': '',  # Set up if required
            'meeturl': '',
            'show_qr': show_qr,
            'status': status
        }
        users_collection.insert_one(new_user)
        flash("User added successfully!", "success")
        return redirect(url_for('admin_dashboard'))

    return render_template('add_user.html')

# Route to edit an existing user
@app.route('/edit_user/<user_id>', methods=['GET', 'POST'])
def edit_user(user_id):
    user = users_collection.find_one({'_id': ObjectId(user_id)})

    if request.method == 'POST':
        username = request.form.get('username')
        password = request.form.get('password')
        status = bool(request.form.get('status'))
        show_qr = bool(request.form.get('qr'))

        update_data = {
            'username': username,
            'status': status,
            'show_qr': show_qr
        }
        if password:
            update_data['password'] = generate_password_hash(password)

        users_collection.update_one({'_id': ObjectId(user_id)}, {'$set': update_data})
        flash("User updated successfully!", "success")
        return redirect(url_for('admin_dashboard'))

    return render_template('edit_user.html', user=user)

# Route to delete a user
@app.route('/delete_user/<user_id>', methods=['POST'])
def delete_user(user_id):
    users_collection.delete_one({'_id': ObjectId(user_id)})
    flash("User deleted successfully!", "success")
    return redirect(url_for('admin_dashboard'))

# Route to toggle user status
@app.route('/toggle_status/<user_id>', methods=['POST'])
def toggle_status(user_id):
    user = users_collection.find_one({'_id': ObjectId(user_id)})
    new_status = not user.get('status', False)
    users_collection.update_one({'_id': ObjectId(user_id)}, {'$set': {'status': new_status}})
    return jsonify({'status': 'success', 'new_status': new_status})

# Route to toggle QR code display
@app.route('/toggle_qr/<user_id>', methods=['POST'])
def toggle_qr(user_id):
    user = users_collection.find_one({'_id': ObjectId(user_id)})
    new_qr_status = not user.get('show_qr', False)
    users_collection.update_one({'_id': ObjectId(user_id)}, {'$set': {'show_qr': new_qr_status}})
    return jsonify({'status': 'success', 'new_qr_status': new_qr_status})

if __name__ == '__main__':
    app.run(debug=True)
