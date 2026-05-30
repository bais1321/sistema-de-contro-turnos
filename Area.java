package com.turnos.modelo;

public class Area {

    private int    idArea;
    private String nombreArea;
    private String descripcion;
    private int    idAreaPadre;
    private boolean esJefatura;
    private int    estado;

    // Campo extra para vistas (JOIN)
    private String nombreAreaPadre;

    // ---- Getters y Setters ----

    public int getIdArea()                       { return idArea; }
    public void setIdArea(int v)                 { this.idArea = v; }

    public String getNombreArea()                { return nombreArea; }
    public void setNombreArea(String v)          { this.nombreArea = v; }

    public String getDescripcion()               { return descripcion; }
    public void setDescripcion(String v)         { this.descripcion = v; }

    public int getIdAreaPadre()                  { return idAreaPadre; }
    public void setIdAreaPadre(int v)            { this.idAreaPadre = v; }

    public boolean isEsJefatura()                { return esJefatura; }
    public void setEsJefatura(boolean v)         { this.esJefatura = v; }

    public int getEstado()                       { return estado; }
    public void setEstado(int v)                 { this.estado = v; }

    public String getNombreAreaPadre()           { return nombreAreaPadre; }
    public void setNombreAreaPadre(String v)     { this.nombreAreaPadre = v; }
}