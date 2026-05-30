package com.turnos.modelo;

public class Turno {

    private int    idTurno;
    private String nombreTurno;
    private String horaInicio;
    private String horaFin;
    private String descripcion;
    private int    estado;

    // ---- Getters y Setters ----

    public int getIdTurno()                  { return idTurno; }
    public void setIdTurno(int v)            { this.idTurno = v; }

    public String getNombreTurno()           { return nombreTurno; }
    public void setNombreTurno(String v)     { this.nombreTurno = v; }

    public String getHoraInicio()            { return horaInicio; }
    public void setHoraInicio(String v)      { this.horaInicio = v; }

    public String getHoraFin()               { return horaFin; }
    public void setHoraFin(String v)         { this.horaFin = v; }

    public String getDescripcion()           { return descripcion; }
    public void setDescripcion(String v)     { this.descripcion = v; }

    public int getEstado()                   { return estado; }
    public void setEstado(int v)             { this.estado = v; }
}