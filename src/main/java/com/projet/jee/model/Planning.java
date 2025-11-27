package com.projet.jee.model;

public class Planning {
    private Long id;
    private Long clubId;

    public Planning() {
    }

    public Planning(Long id, Long clubId) {
        this.id = id;
        this.clubId = clubId;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getClubId() {
        return clubId;
    }

    public void setClubId(Long clubId) {
        this.clubId = clubId;
    }
}


