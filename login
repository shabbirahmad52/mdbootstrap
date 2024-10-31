admin_dashboard

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <!-- MDBootstrap CSS -->
    <link href="../static/mdb/css/mdb.min.css" rel="stylesheet">
    <style>
        /* Custom sidebar and layout styling */
        .sidebar { width: 250px; min-height: 100vh; background-color: #343a40; color: #fff; }
        .sidebar .nav-link { color: #adb5bd; font-size: 1.1rem; }
        .sidebar .nav-link:hover, .sidebar .active { background-color: #495057; color: #fff; }
        .content { padding: 30px; }
    </style>
</head>
<body class="bg-light">
    <div class="d-flex">
        <!-- Sidebar -->
        <div class="sidebar p-3">
            <h4 class="text-white mb-4">Admin Panel</h4>
            <ul class="nav flex-column">
                <li class="nav-item mb-2"><a href="#" class="nav-link active"><i class="fas fa-tachometer-alt"></i> Dashboard</a></li>
                <li class="nav-item mb-2"><a href="#" class="nav-link"><i class="fas fa-users"></i> Manage Users</a></li>
                <li class="nav-item mb-2"><a href="#" class="nav-link"><i class="fas fa-cogs"></i> Settings</a></li>
                <li class="nav-item mb-2"><a href="#" class="nav-link"><i class="fas fa-sign-out-alt"></i> Logout</a></li>
            </ul>
        </div>

        <!-- Main Content -->
        <div class="container my-5 flex-grow-1 content">
            <h2 class="text-center mb-4">Admin Dashboard</h2>
            <div class="text-end mb-3">
                <a href="/add_user" class="btn btn-success">Add New User</a>
            </div>
            <div class="card">
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>Username</th>
                                    <th>Status</th>
                                    <th>QR Code</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                {% for user in users %}
                                <tr>
                                    <td>{{ user[1] }}</td>
                                    <td>
                                        <div class="form-check form-switch">
                                            <input type="checkbox" class="form-check-input user-status-switch"
                                                   id="status-switch-{{ user[0] }}" data-user-id="{{ user[0] }}"
                                                   {% if user[2] %}checked{% endif %}>
                                            <label class="form-check-label" for="status-switch-{{ user[0] }}">
                                                {{ "Enabled" if user[2] else "Disabled" }}
                                            </label>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="form-check form-switch">
                                            <input type="checkbox" class="form-check-input user-qr-switch"
                                                   id="qr-switch-{{ user[0] }}" data-user-id="{{ user[0] }}"
                                                   {% if user[3] %}checked{% endif %}>
                                            <label class="form-check-label" for="qr-switch-{{ user[0] }}">
                                                {{ "QR Enabled" if user[3] else "QR Disabled" }}
                                            </label>
                                        </div>
                                    </td>
                                    <td>
                                        <a href="/edit_user/{{ user[0] }}" class="btn btn-primary btn-sm">
                                            <i class="fas fa-edit"></i> Edit
                                        </a>
                                        <button class="btn btn-danger btn-sm delete-user" data-user-id="{{ user[0] }}">
                                            <i class="fas fa-trash-alt"></i> Delete
                                        </button>
                                    </td>
                                </tr>
                                {% endfor %}
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- MDBootstrap JS -->
    <script src="../static/mdb/js/mdb.min.js"></script>

    <script>
        // Enable status and QR code toggle logic
        // Similar to the previous JavaScript code for handling these actions
    </script>
</body>
</html>


Add User: 


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add User</title>
    <link href="../static/mdb/css/mdb.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container my-5">
        <h2 class="text-center mb-4">Add New User</h2>
        <div class="card">
            <div class="card-body">
                <form action="/add_user" method="POST">
                    <div class="mb-3">
                        <label for="username" class="form-label">Username</label>
                        <input type="text" class="form-control" id="username" name="username" required>
                    </div>
                    <div class="mb-3">
                        <label for="password" class="form-label">Password</label>
                        <input type="password" class="form-control" id="password" name="password" required>
                    </div>
                    <div class="mb-3 form-check form-switch">
                        <input type="checkbox" class="form-check-input" id="status" name="status">
                        <label class="form-check-label" for="status">Enable User</label>
                    </div>
                    <div class="mb-3 form-check form-switch">
                        <input type="checkbox" class="form-check-input" id="qr" name="qr">
                        <label class="form-check-label" for="qr">Enable QR Code</label>
                    </div>
                    <button type="submit" class="btn btn-primary">Add User</button>
                    <a href="/" class="btn btn-secondary">Cancel</a>
                </form>
            </div>
        </div>
    </div>
</body>
</html>


Edit User

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit User</title>
    <link href="../static/mdb/css/mdb.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container my-5">
        <h2 class="text-center mb-4">Edit User</h2>
        <div class="card">
            <div class="card-body">
                <form action="/edit_user/{{ user[0] }}" method="POST">
                    <div class="mb-3">
                        <label for="username" class="form-label">Username</label>
                        <input type="text" class="form-control" id="username" name="username" value="{{ user[1] }}" required>
                    </div>
                    <div class="mb-3">
                        <label for="password" class="form-label">Password</label>
                        <input type="password" class="form-control" id="password" name="password">
                    </div>
                    <div class="mb-3 form-check form-switch">
                        <input type="checkbox" class="form-check-input" id="status" name="status" {% if user[2] %}checked{% endif %}>
                        <label class="form-check-label" for="status">Enable User</label>
                    </div>
                    <div class="mb-3 form-check form-switch">
                        <input type="checkbox" class="form-check-input" id="qr" name="qr" {% if user[3] %}checked{% endif %}>
                        <label class="form-check-label" for="qr">Enable QR Code</label>
                    </div>
                    <button type="submit" class="btn btn-primary">Save Changes</button>
                    <a href="/" class="btn btn-secondary">Cancel</a>
                </form>
            </div>
        </div>
    </div>
</body>
</html>
