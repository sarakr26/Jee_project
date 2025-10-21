package com.projet.jee.model;

import java.sql.Date;

public class DemandeCreationClub {
    private Long id;
    private String nomClub;
    private String description;
    private Date dateDemande;
    private String statut; // EN_ATTENTE, ACCEPTEE, REFUSEE
    private Long presidentId;
    
    // Propriétés supplémentaires pour l'affichage
    private String nomPresident;
    private String prenomPresident;
    private String emailPresident;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getNomClub() {
        return nomClub;
    }

    public void setNomClub(String nomClub) {
        this.nomClub = nomClub;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Date getDateDemande() {
        return dateDemande;
    }

    public void setDateDemande(Date dateDemande) {
        this.dateDemande = dateDemande;
    }

    public String getStatut() {
        return statut;
    }

    public void setStatut(String statut) {
        this.statut = statut;
    }

    public Long getPresidentId() {
        return presidentId;
    }

    public void setPresidentId(Long presidentId) {
        this.presidentId = presidentId;
    }

    public String getNomPresident() {
        return nomPresident;
    }

    public void setNomPresident(String nomPresident) {
        this.nomPresident = nomPresident;
    }

    public String getPrenomPresident() {
        return prenomPresident;
    }

    public void setPrenomPresident(String prenomPresident) {
        this.prenomPresident = prenomPresident;
    }

    public String getEmailPresident() {
        return emailPresident;
    }

    public void setEmailPresident(String emailPresident) {
        this.emailPresident = emailPresident;
    }
}

