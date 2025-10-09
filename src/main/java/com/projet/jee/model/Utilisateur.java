package com.projet.jee.model;

public class Utilisateur {
    private Long id;
    private String nom;
    private String prenom;
    private String email;
    private String motDePasse; // hashed
    private String cin;
    private String role;
    private Long clubId;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }
    public String getPrenom() { return prenom; }
    public void setPrenom(String prenom) { this.prenom = prenom; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getMotDePasse() { return motDePasse; }
    public void setMotDePasse(String motDePasse) { this.motDePasse = motDePasse; }
    public String getCin() { return cin; }
    public void setCin(String cin) { this.cin = cin; }
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    public Long getClubId() { return clubId; }
    public void setClubId(Long clubId) { this.clubId = clubId; }
}
