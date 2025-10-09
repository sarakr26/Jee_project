package com.projet.jee.model;

import java.sql.Date;

public class Evenement {
    private Long id;
    private String titre;
    private String description;
    private String lieu;
    private Date dateDebut;
    private Date dateFin;
    private String statut;
    private Long federationId;

    public Evenement() {}

    public Evenement(Long id, String titre, String description, String lieu, Date dateDebut, Date dateFin, String statut, Long federationId) {
        this.id = id;
        this.titre = titre;
        this.description = description;
        this.lieu = lieu;
        this.dateDebut = dateDebut;
        this.dateFin = dateFin;
        this.statut = statut;
        this.federationId = federationId;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getTitre() { return titre; }
    public void setTitre(String titre) { this.titre = titre; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getLieu() { return lieu; }
    public void setLieu(String lieu) { this.lieu = lieu; }

    public Date getDateDebut() { return dateDebut; }
    public void setDateDebut(Date dateDebut) { this.dateDebut = dateDebut; }

    public Date getDateFin() { return dateFin; }
    public void setDateFin(Date dateFin) { this.dateFin = dateFin; }

    public String getStatut() { return statut; }
    public void setStatut(String statut) { this.statut = statut; }

    public Long getFederationId() { return federationId; }
    public void setFederationId(Long federationId) { this.federationId = federationId; }
}
