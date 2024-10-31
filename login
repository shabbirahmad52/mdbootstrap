<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <!-- MDBootstrap CSS -->
    <link href="../static/mdb/css/mdb.min.css" rel="stylesheet">
    <style>
        .sidebar {
            width: 250px;
            min-height: 100vh;
            background-color: #343a40;
            color: #fff;
        }
        .sidebar .nav-link {
            color: #adb5bd;
            font-size: 1.1rem;
            display: flex;
            align-items: center;
        }
        .sidebar .nav-link:hover {
            background-color: #495057;
            color: #fff;
            text-decoration: none;
        }
        .sidebar .nav-link i {
            font-size: 1.2rem;
            margin-right: 10px;
        }
        .sidebar .active {
            color: #fff;
            background-color: #495057;
        }
        .content {
            padding: 30px;
        }
    </style>
</head>
<body class="bg-light">
    <div class="d-flex">
        <!-- Sidebar -->
        <div class="sidebar p-3">
            <h4 class="text-white mb-4">Admin Panel</h4>
            <ul class="nav flex-column">
                <li class="nav-item mb-2">
                    <a href="#" class="nav-link active"><i class="fas fa-tachometer-alt"></i> Dashboard</a>
                </li>
                <li class="nav-item mb-2">
                    <a href="#" class="nav-link"><i class="fas fa-users"></i> Manage Users</a>
                </li>
                <li class="nav-item mb-2">
                    <a href="#" class="nav-link"><i class="fas fa-cogs"></i> Settings</a>
                </li>
                <li class="nav-item mb-2">
                    <a href="#" class="nav-link"><i class="fas fa-sign-out-alt"></i> Logout</a>
                </li>
            </ul>
        </div>

        <!-- Main Content -->
        <div class="container my-5 flex-grow-1 content">
            <h2 class="text-center mb-4">Admin Dashboard</h2>
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
                                                   id="status-switch-{{ user[0] }}"
                                                   data-user-id="{{ user[0] }}"
                                                   {% if user[2] %}checked{% endif %}>
                                            <label class="form-check-label" for="status-switch-{{ user[0] }}">
                                                {{ "Enabled" if user[2] else "Disabled" }}
                                            </label>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="form-check form-switch">
                                            <input type="checkbox" class="form-check-input user-qr-switch"
                                                   id="qr-switch-{{ user[0] }}"
                                                   data-user-id="{{ user[0] }}"
                                                   {% if user[3] %}checked{% endif %}>
                                            <label class="form-check-label" for="qr-switch-{{ user[0] }}">
                                                {{ "QR Enabled" if user[3] else "QR Disabled" }}
                                            </label>
                                        </div>
                                    </td>
                                    <td>
                                        <button class="btn btn-primary btn-sm edit-user" data-user-id="{{ user[0] }}">
                                            <i class="fas fa-edit"></i> Edit
                                        </button>
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
        document.addEventListener('DOMContentLoaded', function () {
            document.querySelectorAll('.user-status-switch').forEach(function (toggleSwitch) {
                toggleSwitch.addEventListener('change', function () {
                    const userId = this.getAttribute('data-user-id');
                    const newStatus = this.checked ? 1 : 0;
                    const label = this.nextElementSibling;

                    fetch('/toggle_user_status', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({ user_id: userId, enabled: newStatus })
                    })
                    .then(response => response.json())
                    .then(data => {
                        alert(data.msg);
                        label.textContent = this.checked ? 'Enabled' : 'Disabled';
                    })
                    .catch(() => alert('Error updating user status'));
                });
            });

            document.querySelectorAll('.user-qr-switch').forEach(function (toggleSwitch) {
                toggleSwitch.addEventListener('change', function () {
                    const userId = this.getAttribute('data-user-id');
                    const newQrStatus = this.checked ? 1 : 0;
                    const label = this.nextElementSibling;

                    fetch('/toggle_qr_status', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({ user_id: userId, qr_enabled: newQrStatus })
                    })
                    .then(response => response.json())
                    .then(data => {
                        alert(data.msg);
                        label.textContent = this.checked ? 'QR Enabled' : 'QR Disabled';
                    })
                    .catch(() => alert('Error updating QR code status'));
                });
            });

            document.querySelectorAll('.edit-user').forEach(function (editButton) {
                editButton.addEventListener('click', function () {
                    const userId = this.getAttribute('data-user-id');
                    window.location.href = `/edit_user/${userId}`;
                });
            });

            document.querySelectorAll('.delete-user').forEach(function (deleteButton) {
                deleteButton.addEventListener('click', function () {
                    const userId = this.getAttribute('data-user-id');
                    if (confirm('Are you sure you want to delete this user?')) {
                        fetch(`/delete_user/${userId}`, {
                            method: 'DELETE'
                        })
                        .then(response => response.json())
                        .then(data => {
                            alert(data.msg);
                            location.reload();
                        })
                        .catch(() => alert('Error deleting user'));
                    }
                });
            });
        });
    </script>
</body>
</html>
