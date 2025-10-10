package com.projet.jee.model;

import java.sql.Date;

public class DemandeIntegration {
    private Long id;
    private Date dateDemande;
    private String statut;
    private Long membreId;
    private Long clubId;
    
    // Informations supplémentaires pour l'affichage
    private String membreNom;
    private String membrePrenom;
    private String membreEmail;
    private String clubNom;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
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

    public Long getMembreId() {
        return membreId;
    }

    public void setMembreId(Long membreId) {
        this.membreId = membreId;
    }

    public Long getClubId() {
        return clubId;
    }

    public void setClubId(Long clubId) {
        this.clubId = clubId;
    }

    public String getMembreNom() {
        return membreNom;
    }

    public void setMembreNom(String membreNom) {
        this.membreNom = membreNom;
    }

    public String getMembrePrenom() {
        return membrePrenom;
    }

    public void setMembrePrenom(String membrePrenom) {
        this.membrePrenom = membrePrenom;
    }

    public String getMembreEmail() {
        return membreEmail;
    }

    public void setMembreEmail(String membreEmail) {
        this.membreEmail = membreEmail;
    }

    public String getClubNom() {
        return clubNom;
    }

    public void setClubNom(String clubNom) {
        this.clubNom = clubNom;
    }
}

