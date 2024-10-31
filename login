<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <!-- MDBootstrap CSS -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/mdb-ui-kit/6.1.0/mdb.min.css" rel="stylesheet">
</head>
<body class="bg-light">
    <div class="container my-5">
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
                                <td>{{ user.username }}</td>
                                <td>
                                    <!-- MDB Toggle switch for enabling/disabling users -->
                                    <div class="form-check form-switch">
                                        <input type="checkbox" class="form-check-input user-status-switch" id="switch-{{ user.id }}"
                                               data-user-id="{{ user.id }}" 
                                               {% if user.enabled %}checked{% endif %}>
                                        <label class="form-check-label" for="switch-{{ user.id }}">
                                            {{ "Enabled" if user.enabled else "Disabled" }}
                                        </label>
                                    </div>
                                </td>
                                <td>
                                    <!-- Edit and Delete buttons using MDBootstrap classes -->
                                    <button class="btn btn-primary btn-sm edit-user" data-user-id="{{ user.id }}">
                                        <i class="fas fa-edit"></i> Edit
                                    </button>
                                    <button class="btn btn-danger btn-sm delete-user" data-user-id="{{ user.id }}">
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

    <!-- MDBootstrap JS and dependencies (jQuery, Bootstrap Bundle) -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/mdb-ui-kit/6.1.0/mdb.min.js"></script>
    
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            // Toggle enable/disable status
            document.querySelectorAll('.user-status-switch').forEach(function (toggleSwitch) {
                toggleSwitch.addEventListener('change', function () {
                    const userId = this.getAttribute('data-user-id');
                    const newStatus = this.checked ? 1 : 0;

                    fetch('/toggle_user_status', {
                        method: 'POST',
                        headers: { 'Content-Type': 'application/json' },
                        body: JSON.stringify({ user_id: userId, enabled: newStatus })
                    })
                    .then(response => response.json())
                    .then(data => alert(data.msg))
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
