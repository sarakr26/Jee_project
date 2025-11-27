package com.projet.jee.model;

import java.sql.Timestamp;

/**
 * Modèle pour un message interne envoyé par un utilisateur vers tous les
 * membres d'un club.
 */
public class Message {
    private Long id;
    private Long expediteurId;
    private Long clubId;
    private String sujet;
    private String contenu;
    private Timestamp dateEnvoi;
    // Nom du club (jointure SQL, pas une colonne directe)
    private String clubNom;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getExpediteurId() {
        return expediteurId;
    }

    public void setExpediteurId(Long expediteurId) {
        this.expediteurId = expediteurId;
    }

    public Long getClubId() {
        return clubId;
    }

    public void setClubId(Long clubId) {
        this.clubId = clubId;
    }

    public String getSujet() {
        return sujet;
    }

    public void setSujet(String sujet) {
        this.sujet = sujet;
    }

    public String getContenu() {
        return contenu;
    }

    public void setContenu(String contenu) {
        this.contenu = contenu;
    }

    public Timestamp getDateEnvoi() {
        return dateEnvoi;
    }

    public void setDateEnvoi(Timestamp dateEnvoi) {
        this.dateEnvoi = dateEnvoi;
    }

    public String getClubNom() {
        return clubNom;
    }

    public void setClubNom(String clubNom) {
        this.clubNom = clubNom;
    }
}


