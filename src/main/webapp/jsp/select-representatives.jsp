<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.projet.jee.model.Club" %>
<%@ page import="com.projet.jee.model.Evenement" %>
<%@ page import="com.projet.jee.model.Utilisateur" %>
<%
    Utilisateur currentUser = (Utilisateur) session.getAttribute("currentUser");
    if (currentUser == null || !"PRESIDENT".equals(currentUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    
    Evenement evenement = (Evenement) request.getAttribute("evenement");
    Club club = (Club) request.getAttribute("club");
    List<Utilisateur> members = (List<Utilisateur>) request.getAttribute("members");
    List<Long> selectedIds = (List<Long>) request.getAttribute("selectedIds");
    
    if (evenement == null || club == null) {
        response.sendRedirect(request.getContextPath() + "/president/dashboard");
        return;
    }
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sélectionner les Représentants - <%= evenement.getTitre() %></title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/federation-dashboard.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        /* Additional styles for select representatives */
        .event-info-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem;
            border-radius: 12px;
            margin-bottom: 1.5rem;
        }

        .event-info-card h3 {
            font-size: 1.8rem;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .event-meta {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1rem;
            margin-top: 1rem;
        }

        .event-meta-item {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 1rem;
        }

        .event-meta-item i {
            font-size: 1.2rem;
        }

        .info-box {
            background: #fff3cd;
            border-left: 4px solid #ffc107;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 25px;
            color: #856404;
        }

        .info-box i {
            margin-right: 10px;
        }

        .members-list {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 1rem;
            margin-bottom: 25px;
        }

        @media (max-width: 768px) {
            .members-list {
                grid-template-columns: 1fr;
            }
        }

        .member-item {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 15px;
            display: flex;
            align-items: center;
            gap: 15px;
            transition: all 0.3s;
            cursor: pointer;
            border: 2px solid transparent;
        }

        .member-item:hover {
            background: #e9ecef;
            transform: translateX(5px);
        }

        .member-item.selected {
            background: #d4edda;
            border-color: #4CAF50;
        }

        .member-checkbox {
            width: 24px;
            height: 24px;
            cursor: pointer;
            accent-color: #4CAF50;
        }

        .member-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            font-size: 1.2rem;
        }

        .member-info {
            flex: 1;
        }

        .member-name {
            font-weight: 600;
            color: #1e3c72;
            font-size: 1.1rem;
            margin-bottom: 5px;
        }

        .member-email {
            color: #666;
            font-size: 0.9rem;
        }

        .actions {
            display: flex;
            gap: 15px;
            justify-content: flex-end;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 2px solid #f0f0f0;
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

        .btn-primary {
            background: #4CAF50;
            color: white;
        }

        .btn-primary:hover {
            background: #45a049;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(76, 175, 80, 0.3);
        }

        .btn-primary:disabled {
            background: #ccc;
            cursor: not-allowed;
            transform: none;
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
        }

        .btn-secondary:hover {
            background: #5a6268;
            transform: translateY(-2px);
        }

        .empty-message {
            text-align: center;
            padding: 40px;
            color: #999;
        }

        .empty-message i {
            font-size: 3rem;
            margin-bottom: 15px;
            color: #ccc;
        }

        .selection-counter {
            background: #4CAF50;
            color: white;
            padding: 10px 20px;
            border-radius: 8px;
            text-align: center;
            font-weight: 600;
            margin-bottom: 20px;
        }

        .selection-counter.warning {
            background: #ffc107;
            color: #000;
        }

        .selection-counter.error {
            background: #dc3545;
        }
    </style>
</head>
<body>
    <div class="federation-dashboard">
        <!-- Header -->
        <header class="dashboard-header">
            <div class="header-content">
                <h1><i class="fas fa-users"></i> Sélectionner les Représentants</h1>
                <div class="user-info">
                    <span>Bienvenue, <%= currentUser.getPrenom() %> <%= currentUser.getNom() %></span>
                    <a href="<%= request.getContextPath() %>/president/dashboard" class="logout-btn">
                        <i class="fas fa-arrow-left"></i> Retour
                    </a>
                </div>
            </div>
        </header>

        <!-- Main Content -->
        <main class="dashboard-main">
            <!-- Event Information -->
            <section class="key-indicators">
                <div class="event-info-card">
                    <h3><i class="fas fa-trophy"></i> <%= evenement.getTitre() %></h3>
                    <p style="margin-bottom: 1rem;">Choisissez 1 ou 2 membres de <strong><%= club.getNom() %></strong> pour représenter votre club</p>
                    <div class="event-meta">
                        <div class="event-meta-item">
                            <i class="fas fa-map-marker-alt"></i>
                            <span><strong>Lieu:</strong> <%= evenement.getLieu() != null ? evenement.getLieu() : "Lieu non précisé" %></span>
                        </div>
                        <div class="event-meta-item">
                            <i class="fas fa-calendar"></i>
                            <span><strong>Date:</strong> <%= evenement.getDateDebut() %> au <%= evenement.getDateFin() %></span>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Selection Form -->
            <section class="pending-requests">
                <div class="info-box">
                    <i class="fas fa-info-circle"></i>
                    <strong>Important:</strong> Vous pouvez sélectionner un maximum de 2 membres pour représenter votre club à ce tournoi.
                </div>

                <div id="selectionCounter" class="selection-counter">
                    <i class="fas fa-check-circle"></i>
                    <span id="counterText">0 membre(s) sélectionné(s) sur 2 maximum</span>
                </div>

                <form id="selectionForm" action="<%= request.getContextPath() %>/president/select-representatives" method="post">
                    <input type="hidden" name="evenementId" value="<%= evenement.getId() %>">
                    
                    <h2><i class="fas fa-list"></i> Membres du Club</h2>

                    <% if (members != null && !members.isEmpty()) { %>
                        <div class="members-list">
                            <% for (Utilisateur member : members) { 
                                boolean isSelected = selectedIds != null && selectedIds.contains(member.getId());
                                String initials = (member.getPrenom().substring(0, 1) + member.getNom().substring(0, 1)).toUpperCase();
                            %>
                                <label class="member-item <%= isSelected ? "selected" : "" %>" data-member-id="<%= member.getId() %>">
                                    <input type="checkbox" 
                                           name="memberIds" 
                                           value="<%= member.getId() %>" 
                                           class="member-checkbox"
                                           <%= isSelected ? "checked" : "" %>
                                           onchange="updateSelection(this)">
                                    <div class="member-avatar"><%= initials %></div>
                                    <div class="member-info">
                                        <div class="member-name"><%= member.getPrenom() %> <%= member.getNom() %></div>
                                        <div class="member-email"><%= member.getEmail() %></div>
                                    </div>
                                </label>
                            <% } %>
                        </div>
                    <% } else { %>
                        <div class="empty-message">
                            <i class="fas fa-users-slash"></i>
                            <p>Aucun membre dans votre club</p>
                            <p style="font-size: 0.9rem; color: #bbb;">Invitez des membres à rejoindre votre club pour pouvoir les sélectionner</p>
                        </div>
                    <% } %>

                    <div class="actions">
                        <% if (members != null && !members.isEmpty()) { %>
                            <button type="submit" class="btn btn-primary" id="submitBtn">
                                <i class="fas fa-check"></i>
                                Confirmer la Sélection
                            </button>
                        <% } %>
                    </div>
                </form>
            </section>
        </main>
    </div>

    <script>
        function updateSelection(checkbox) {
            const memberItem = checkbox.closest('.member-item');
            const allCheckboxes = document.querySelectorAll('.member-checkbox');
            const checkedCount = document.querySelectorAll('.member-checkbox:checked').length;
            
            // Update visual state
            if (checkbox.checked) {
                memberItem.classList.add('selected');
            } else {
                memberItem.classList.remove('selected');
            }
            
            // Update counter
            const counter = document.getElementById('selectionCounter');
            const counterText = document.getElementById('counterText');
            const submitBtn = document.getElementById('submitBtn');
            
            counterText.textContent = checkedCount + ' membre(s) sélectionné(s) sur 2 maximum';
            
            if (checkedCount === 0) {
                counter.className = 'selection-counter';
            } else if (checkedCount <= 2) {
                counter.className = 'selection-counter';
            } else {
                counter.className = 'selection-counter error';
            }
            
            // Disable other checkboxes if 2 are selected
            if (checkedCount >= 2) {
                allCheckboxes.forEach(cb => {
                    if (!cb.checked) {
                        cb.disabled = true;
                        cb.closest('.member-item').style.opacity = '0.5';
                        cb.closest('.member-item').style.cursor = 'not-allowed';
                    }
                });
            } else {
                allCheckboxes.forEach(cb => {
                    cb.disabled = false;
                    cb.closest('.member-item').style.opacity = '1';
                    cb.closest('.member-item').style.cursor = 'pointer';
                });
            }
            
            // Disable submit if more than 2 selected (shouldn't happen, but just in case)
            if (submitBtn) {
                submitBtn.disabled = checkedCount > 2;
            }
        }
        
        // Initialize on page load
        document.addEventListener('DOMContentLoaded', function() {
            const allCheckboxes = document.querySelectorAll('.member-checkbox');
            allCheckboxes.forEach(cb => {
                if (cb.checked) {
                    updateSelection(cb);
                }
            });
        });
        
        // Prevent form submission if more than 2 selected
        document.getElementById('selectionForm').addEventListener('submit', function(e) {
            const checkedCount = document.querySelectorAll('.member-checkbox:checked').length;
            if (checkedCount > 2) {
                e.preventDefault();
                alert('Vous ne pouvez sélectionner que 2 membres maximum !');
                return false;
            }
        });
    </script>
</body>
</html>