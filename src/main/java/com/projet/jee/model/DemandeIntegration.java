package com.projet.jee.model;

import java.util.Date;

public class DemandeIntegration {

    private Long id;
    private Long membreId;
    private Long clubId;
    private String statut; // Ex: 'EN_ATTENTE', 'APPROUVEE', 'REJETEE'
    private Date dateDemande;

    // Getters and Setters
    public Long getId() {
        return id;
    }
    public void setId(Long id) {
        this.id = id;
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
    public String getStatut() {
        return statut;
    }
    public void setStatut(String statut) {
        this.statut = statut;
    }
    public Date getDateDemande() {
        return dateDemande;
    }
    public void setDateDemande(Date dateDemande) {
        this.dateDemande = dateDemande;
    }
}