package com.projet.jee.model;

import java.sql.Timestamp;

public class Activite {
    private Long id;
    private String titre;
    private String type;
    private Timestamp dateDebut;
    private Timestamp dateFin;
    private Long planningId;

    public Activite() {
    }

    public Activite(Long id, String titre, String type, Timestamp dateDebut, Timestamp dateFin, Long planningId) {
        this.id = id;
        this.titre = titre;
        this.type = type;
        this.dateDebut = dateDebut;
        this.dateFin = dateFin;
        this.planningId = planningId;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTitre() {
        return titre;
    }

    public void setTitre(String titre) {
        this.titre = titre;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public Timestamp getDateDebut() {
        return dateDebut;
    }

    public void setDateDebut(Timestamp dateDebut) {
        this.dateDebut = dateDebut;
    }

    public Timestamp getDateFin() {
        return dateFin;
    }

    public void setDateFin(Timestamp dateFin) {
        this.dateFin = dateFin;
    }

    public Long getPlanningId() {
        return planningId;
    }

    public void setPlanningId(Long planningId) {
        this.planningId = planningId;
    }
}


