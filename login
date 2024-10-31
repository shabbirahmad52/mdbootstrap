from flask import Flask, render_template, request, redirect, url_for, jsonify, flash
from werkzeug.security import generate_password_hash
from database import db, User  # Assuming you have a database setup with User model

app = Flask(__name__)
app.secret_key = 'your_secret_key'

# Sample User model setup for reference
# class User(db.Model):
#     id = db.Column(db.Integer, primary_key=True)
#     username = db.Column(db.String(80), unique=True, nullable=False)
#     password = db.Column(db.String(200), nullable=False)
#     status = db.Column(db.Boolean, default=False)
#     qr_enabled = db.Column(db.Boolean, default=False)

# Route to display users
@app.route('/')
def admin_dashboard():
    users = User.query.all()
    return render_template('index.html', users=users)

# Route to add a new user
@app.route('/add_user', methods=['GET', 'POST'])
def add_user():
    if request.method == 'POST':
        username = request.form.get('username')
        password = request.form.get('password')
        status = bool(request.form.get('status'))
        qr_enabled = bool(request.form.get('qr'))

        if not username or not password:
            flash("Username and password are required!", "error")
            return redirect(url_for('add_user'))

        hashed_password = generate_password_hash(password)

        new_user = User(username=username, password=hashed_password, status=status, qr_enabled=qr_enabled)
        db.session.add(new_user)
        db.session.commit()
        flash("User added successfully!", "success")
        return redirect(url_for('admin_dashboard'))

    return render_template('add_user.html')

# Route to edit an existing user
@app.route('/edit_user/<int:user_id>', methods=['GET', 'POST'])
def edit_user(user_id):
    user = User.query.get_or_404(user_id)

    if request.method == 'POST':
        user.username = request.form.get('username')
        password = request.form.get('password')
        user.status = bool(request.form.get('status'))
        user.qr_enabled = bool(request.form.get('qr'))

        if password:
            user.password = generate_password_hash(password)

        db.session.commit()
        flash("User updated successfully!", "success")
        return redirect(url_for('admin_dashboard'))

    return render_template('edit_user.html', user=user)

# Route to delete a user
@app.route('/delete_user/<int:user_id>', methods=['POST'])
def delete_user(user_id):
    user = User.query.get_or_404(user_id)
    db.session.delete(user)
    db.session.commit()
    flash("User deleted successfully!", "success")
    return redirect(url_for('admin_dashboard'))

# Route to toggle user status
@app.route('/toggle_status/<int:user_id>', methods=['POST'])
def toggle_status(user_id):
    user = User.query.get_or_404(user_id)
    user.status = not user.status
    db.session.commit()
    return jsonify({'status': 'success', 'new_status': user.status})

# Route to toggle QR code status
@app.route('/toggle_qr/<int:user_id>', methods=['POST'])
def toggle_qr(user_id):
    user = User.query.get_or_404(user_id)
    user.qr_enabled = not user.qr_enabled
    db.session.commit()
    return jsonify({'status': 'success', 'new_qr_status': user.qr_enabled})

if __name__ == '__main__':
    app.run(debug=True)
