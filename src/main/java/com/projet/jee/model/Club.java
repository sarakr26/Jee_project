package com.projet.jee.model;

public class Club {
    private Long id;
    private String nom;
    private String logo;
    private String description;
    private String statut; // EN_ATTENTE, ACTIF, REFUSE, SUSPENDU, ARCHIVE
    private Long presidentId;

    public Club() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }

    public String getLogo() { return logo; }
    public void setLogo(String logo) { this.logo = logo; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getStatut() { return statut; }
    public void setStatut(String statut) { this.statut = statut; }

    public Long getPresidentId() { return presidentId; }
    public void setPresidentId(Long presidentId) { this.presidentId = presidentId; }
}
