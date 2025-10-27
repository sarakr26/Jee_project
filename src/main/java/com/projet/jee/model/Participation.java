package com.projet.jee.model;

import java.sql.Date;

public class Participation {
    private Long id;
    private Date dateInvitation;
    private Date dateConfirmation;
    private String statut; // INVITE, CONFIRME, REFUSE
    private Long membreId;
    private Long evenementId;

    public Participation() {}

    public Participation(Long id, Date dateInvitation, Date dateConfirmation, String statut, Long membreId, Long evenementId) {
        this.id = id;
        this.dateInvitation = dateInvitation;
        this.dateConfirmation = dateConfirmation;
        this.statut = statut;
        this.membreId = membreId;
        this.evenementId = evenementId;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Date getDateInvitation() { return dateInvitation; }
    public void setDateInvitation(Date dateInvitation) { this.dateInvitation = dateInvitation; }

    public Date getDateConfirmation() { return dateConfirmation; }
    public void setDateConfirmation(Date dateConfirmation) { this.dateConfirmation = dateConfirmation; }

    public String getStatut() { return statut; }
    public void setStatut(String statut) { this.statut = statut; }

    public Long getMembreId() { return membreId; }
    public void setMembreId(Long membreId) { this.membreId = membreId; }

    public Long getEvenementId() { return evenementId; }
    public void setEvenementId(Long evenementId) { this.evenementId = evenementId; }
}
