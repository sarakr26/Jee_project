<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profil Membre - Chess Club Manager</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        :root{
            --bg-1: #0f1724; /* dark navy */
            --bg-2: #0b3a66; /* royal blue */
            --card: #ffffff;
            --muted: #6c757d;
            --accent: #6a9cff; /* lighter blue accent to match theme */
            --glass: rgba(255,255,255,0.06);
        }
        body{
            margin:0; padding:20px; min-height:100vh;
            font-family: Inter, system-ui, -apple-system, 'Segoe UI', Roboto, 'Helvetica Neue', Arial;
            background: radial-gradient(1200px 600px at 10% 10%, rgba(106,156,255,0.08), transparent 15%),
                        linear-gradient(135deg, var(--bg-1), var(--bg-2));
            color:#222;
        }
        .member-dashboard {
            min-height: 100vh;
            background: linear-gradient(135deg, #1e3c72 0%, #2a5298 100%);
            padding: 20px;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .dashboard-header {
            background: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 30px;
            box-shadow: 0 5px 20px rgba(0, 0, 0, 0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .header-title {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .header-title i {
            font-size: 2.5rem;
            color: #8B4513;
        }
        .header-title h1 {
            color: #1e3c72;
            font-size: 2rem;
            margin: 0;
        }
        .header-actions {
            display: flex;
            gap: 10px;
        }
        .btn {
            padding: 12px 25px;
            border-radius: 8px;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            font-weight: 600;
            transition: all 0.3s;
            border: none;
            cursor: pointer;
            font-size: 1rem;
        }
        .btn-secondary {
            background: #8B4513;
            color: white !important;
        }
        .btn-secondary:hover {
            background: #6d3410;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(139, 69, 19, 0.3);
        }
        .profile-card{
            width:100%; max-width:980px; border-radius:16px; overflow:hidden; display:flex; box-shadow:0 20px 60px rgba(2,6,23,0.6);
            border:1px solid rgba(255,255,255,0.03);
            background: linear-gradient(180deg, rgba(255,255,255,0.95), rgba(250,250,250,0.97));
        }
        .left-rail{width:320px; background:linear-gradient(180deg, rgba(106,156,255,0.12), transparent); padding:32px; display:flex; flex-direction:column; align-items:center; gap:18px}
        .avatar{width:120px;height:120px;border-radius:16px;background:linear-gradient(135deg,var(--accent),#2b6eff);display:flex;align-items:center;justify-content:center;color:white;font-weight:700;font-size:36px;box-shadow:0 10px 30px rgba(42,54,100,0.12)}
        .user-name{font-size:1.3rem;font-weight:700;color:#0b2440}
        .user-role{font-size:.9rem;color:var(--muted)}
        .left-actions{margin-top:8px;width:100%;display:flex;gap:10px;flex-direction:column}
        .left-actions a{display:inline-flex;align-items:center;gap:10px;padding:10px 12px;border-radius:10px;text-decoration:none;color:#0b2440;background:rgba(255,255,255,0.9);box-shadow:inset 0 -1px 0 rgba(0,0,0,0.03);}

        .right-area{flex:1;padding:28px 36px}
        .section-title{display:flex;align-items:center;justify-content:space-between;margin-bottom:20px}
        .section-title h3{margin:0;color:#0b2440}
        .profile-form{background:transparent}
        .form-row{display:flex;gap:16px}
        .form-card{background:var(--card);padding:18px;border-radius:12px;border:1px solid rgba(15,23,36,0.03)}

        label .edit-icon{margin-left:8px;color:var(--accent);cursor:pointer}
        input[disabled], textarea[disabled]{background:#f8f9fa}

        .save-bar{position:sticky;bottom:0;display:flex;justify-content:flex-end;gap:12px;padding-top:14px}
        .btn-save{background:var(--accent);border:none;color:white;padding:10px 16px;border-radius:10px;font-weight:600}
        .btn-save[disabled]{opacity:.6}

        @media (max-width:900px){
            .profile-card{flex-direction:column}
            .left-rail{width:100%;flex-direction:row;justify-content:space-between;padding:18px}
            .right-area{padding:18px}
            .form-row{flex-direction:column}
        }
    </style>
</head>
<body>
    
    <div class="member-dashboard">
        <div class="dashboard-header">
            <div class="header-title">
                <i class="fas fa-chess-king"></i>
                <h1>Mon Profil</h1>
            </div>
            <div class="header-actions">
                <a href="${pageContext.request.contextPath}/membre/dashboard" class="btn btn-secondary">
                    <i class="fas fa-chess-board"></i> Retour au Dashboard
                </a>
            </div>
        </div>

        <div class="profile-card">
        <div class="left-rail">
            <div class="avatar" aria-hidden="true">
                <c:out value="${fn:substring(sessionScope.currentUser.prenom,0,1)}"/>
                <c:out value="${fn:substring(sessionScope.currentUser.nom,0,1)}"/>
            </div>
            <div style="text-align:center">
                <div class="user-name">${sessionScope.currentUser.prenom} ${sessionScope.currentUser.nom}</div>
                <div class="user-role">${sessionScope.currentUser.role}</div>
            </div>
            <div class="left-actions">
                <a href="${pageContext.request.contextPath}/membre/dashboard"><i class="fas fa-chess-board"></i> Dashboard</a>
                <a href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt"></i> Se déconnecter</a>
            </div>
        </div>

        <div class="right-area">
            <div class="section-title">
                <h3>Mes informations</h3>
                <div style="color:var(--muted);font-size:.95rem">Gérez vos informations personnelles</div>
            </div>

            <c:if test="${not empty requestScope.message}">
                <div class="alert alert-${requestScope.messageType} alert-dismissible fade show" role="alert">
                    ${requestScope.message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                </div>
            </c:if>

            <form id="profileForm" action="${pageContext.request.contextPath}/profile/update" method="POST" class="needs-validation profile-form" novalidate onsubmit="return prepareSubmit(this);">
                <input type="hidden" name="id" value="${sessionScope.currentUser.id}" />

                <div class="form-row">
                    <div class="form-card" style="flex:1">
                        <div class="mb-3">
                            <label for="nom" class="form-label">Nom <i class="fas fa-edit edit-icon" onclick="toggleEdit('nom')"></i></label>
                            <input type="text" class="form-control" id="nom" name="nom" value="${sessionScope.currentUser.nom}" disabled required>
                        </div>
                        <div class="mb-3">
                            <label for="prenom" class="form-label">Prénom <i class="fas fa-edit edit-icon" onclick="toggleEdit('prenom')"></i></label>
                            <input type="text" class="form-control" id="prenom" name="prenom" value="${sessionScope.currentUser.prenom}" disabled required>
                        </div>
                        <div class="mb-3">
                            <label for="email" class="form-label">Email</label>
                            <input type="email" class="form-control" id="email" value="${sessionScope.currentUser.email}" disabled>
                        </div>
                    </div>

                    <div class="form-card" style="width:320px">
                        <div class="mb-3">
                            <label class="form-label">CIN</label>
                            <input type="text" class="form-control" id="cin" value="${sessionScope.currentUser.cin}" disabled>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Rôle</label>
                            <input type="text" class="form-control" id="role" value="${sessionScope.currentUser.role}" disabled>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Club ID</label>
                            <input type="text" class="form-control" id="club" value="${sessionScope.currentUser.clubId}" disabled>
                        </div>
                    </div>
                </div>

                <div class="save-bar">
                    <button type="submit" id="saveButton" class="btn-save" disabled>
                        <i class="fas fa-save me-2"></i> Enregistrer les modifications
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Enable editable fields before submit so they are included in POST
        function prepareSubmit(form) {
            var editable = ['nom', 'prenom'];
            editable.forEach(function(id) {
                var el = document.getElementById(id);
                if (el) el.disabled = false;
            });
            return true;
        }

        function toggleEdit(fieldId) {
            const input = document.getElementById(fieldId);
            const saveButton = document.getElementById('saveButton');
            input.disabled = !input.disabled;
            if (!input.disabled) input.focus();

            // enable save when any editable is enabled
            const hasEnabled = ['nom','prenom'].some(id => !document.getElementById(id).disabled);
            saveButton.disabled = !hasEnabled;
        }

n        // validation (bootstrap style)
        (function () {
            'use strict'
            const forms = document.querySelectorAll('.needs-validation')
            Array.from(forms).forEach(form => {
                form.addEventListener('submit', event => {
                    if (!form.checkValidity()) {
                        event.preventDefault();
                        event.stopPropagation();
                    }
                    form.classList.add('was-validated')
                }, false)
            })
        })()
    </script>
</body>
</html>
