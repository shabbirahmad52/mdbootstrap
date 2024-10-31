<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <!-- MDBootstrap CSS -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/mdb-ui-kit/6.1.0/mdb.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="d-flex">
        <!-- Sidebar -->
        <div class="bg-dark p-3" style="width: 250px; min-height: 100vh;">
            <h4 class="text-white">Admin Panel</h4>
            <ul class="list-unstyled">
                <li class="my-3">
                    <a href="#" class="text-white">Dashboard</a>
                </li>
                <li class="my-3">
                    <a href="#" class="text-white">Manage Users</a>
                </li>
                <li class="my-3">
                    <a href="#" class="text-white">Settings</a>
                </li>
                <li class="my-3">
                    <a href="#" class="text-white">Logout</a>
                </li>
            </ul>
        </div>

        <!-- Main Content -->
        <div class="container my-5 flex-grow-1">
            <h2 class="text-center mb-4">Admin Dashboard</h2>
            <div class="card">
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>Username</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                {% for user in users %}
                                <tr>
                                    <td>{{ user[1] }}</td>
                                    <td>
                                        <!-- MDB Toggle switch for enabling/disabling users -->
                                        <div class="form-check form-switch">
                                            <input type="checkbox" class="form-check-input user-status-switch" 
                                                   id="switch-{{ user[0] }}" 
                                                   data-user-id="{{ user[0] }}"
                                                   {% if user[2] %}checked{% endif %}>
                                            <label class="form-check-label" for="switch-{{ user[0] }}">
                                                {{ "Enabled" if user[2] else "Disabled" }}
                                            </label>
                                        </div>
                                    </td>
                                    <td>
                                        <!-- Edit and Delete buttons using MDBootstrap classes -->
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

    <!-- MDBootstrap JS and dependencies -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/mdb-ui-kit/6.1.0/mdb.min.js"></script>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            // Toggle enable/disable status
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

            // Edit and delete handlers
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
