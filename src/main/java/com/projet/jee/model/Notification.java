package com.projet.jee.model;

import java.sql.Date;

public class Notification {
    private Long id;
    private String message;
    private String type; // CLUB_ACCEPTED, EVENT_ADDED, etc.
    private Date dateCreation;
    private boolean lu; // read status
    private Long membreId;

    public Notification() {
    }

    public Notification(Long id, String message, String type, Date dateCreation, boolean lu, Long membreId) {
        this.id = id;
        this.message = message;
        this.type = type;
        this.dateCreation = dateCreation;
        this.lu = lu;
        this.membreId = membreId;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public Date getDateCreation() {
        return dateCreation;
    }

    public void setDateCreation(Date dateCreation) {
        this.dateCreation = dateCreation;
    }

    public boolean isLu() {
        return lu;
    }

    public void setLu(boolean lu) {
        this.lu = lu;
    }

    public Long getMembreId() {
        return membreId;
    }

    public void setMembreId(Long membreId) {
        this.membreId = membreId;
    }
}

