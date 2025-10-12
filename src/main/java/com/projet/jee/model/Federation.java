package com.projet.jee.model;

public class Federation {
    private Long id;
    private String nom;
    private String pays;

    public Federation() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }

    public String getPays() { return pays; }
    public void setPays(String pays) { this.pays = pays; }
}
