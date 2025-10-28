<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Configuration Email SMTP</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <div class="row">
            <div class="col-md-8 offset-md-2">
                <div class="card">
                    <div class="card-header">
                        <h3>Configuration SMTP</h3>
                    </div>
                    <div class="card-body">
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger">${error}</div>
                        </c:if>
                        <c:if test="${not empty message}">
                            <div class="alert alert-success">${message}</div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/admin/smtp-config" method="post" class="needs-validation" novalidate>
                            <div class="mb-3">
                                <label for="smtpHost" class="form-label">Serveur SMTP</label>
                                <input type="text" class="form-control" id="smtpHost" name="smtpHost" 
                                       value="${smtpHost}" required>
                                <div class="form-text">Ex: smtp.gmail.com</div>
                            </div>

                            <div class="mb-3">
                                <label for="smtpPort" class="form-label">Port SMTP</label>
                                <input type="text" class="form-control" id="smtpPort" name="smtpPort" 
                                       value="${smtpPort}" required>
                                <div class="form-text">Ex: 587 pour TLS, 465 pour SSL</div>
                            </div>

                            <div class="mb-3">
                                <label for="smtpUser" class="form-label">Nom d'utilisateur SMTP</label>
                                <input type="text" class="form-control" id="smtpUser" name="smtpUser" 
                                       value="${smtpUser}" required>
                                <div class="form-text">Votre adresse email complète</div>
                            </div>

                            <div class="mb-3">
                                <label for="smtpPassword" class="form-label">Mot de passe SMTP</label>
                                <input type="password" class="form-control" id="smtpPassword" name="smtpPassword" 
                                       required>
                                <div class="form-text">Pour Gmail, utilisez un mot de passe d'application</div>
                            </div>

                            <div class="mb-3">
                                <label for="mailFrom" class="form-label">Adresse expéditeur</label>
                                <input type="email" class="form-control" id="mailFrom" name="mailFrom" 
                                       value="${mailFrom}" required>
                                <div class="form-text">L'adresse qui apparaîtra comme expéditeur</div>
                            </div>

                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-primary">Enregistrer la configuration</button>
                                <button type="button" class="btn btn-secondary" id="testConfig">Tester la configuration</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Form validation
        (function () {
            'use strict'
            var forms = document.querySelectorAll('.needs-validation')
            Array.prototype.slice.call(forms).forEach(function (form) {
                form.addEventListener('submit', function (event) {
                    if (!form.checkValidity()) {
                        event.preventDefault()
                        event.stopPropagation()
                    }
                    form.classList.add('was-validated')
                }, false)
            })
        })()

        // Test configuration button
        document.getElementById('testConfig').addEventListener('click', function() {
            fetch('${pageContext.request.contextPath}/admin/test-smtp', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: new URLSearchParams(new FormData(document.querySelector('form')))
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('Configuration SMTP testée avec succès !');
                } else {
                    alert('Erreur lors du test : ' + data.error);
                }
            })
            .catch(error => {
                alert('Erreur lors du test : ' + error);
            });
        });
    </script>
</body>
</html>