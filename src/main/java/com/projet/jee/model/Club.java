package com.projet.jee.model;

public class Club {
    private Long id;
    private String nom;
    private String adresse;
    private String telephone;
    private String email;
    private String description;
    private Long federationId;

    public Club() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }

    public String getAdresse() { return adresse; }
    public void setAdresse(String adresse) { this.adresse = adresse; }

    public String getTelephone() { return telephone; }
    public void setTelephone(String telephone) { this.telephone = telephone; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Long getFederationId() { return federationId; }
    public void setFederationId(Long federationId) { this.federationId = federationId; }
}
