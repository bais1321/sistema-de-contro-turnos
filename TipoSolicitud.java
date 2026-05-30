package com.turnos.modelo;

public class TipoSolicitud {

    private int    idTipoSolicitud;
    private String nombreTipo;
    private String descripcion;
    private int    requiereAprobacionRrhh;
    private int    diasMaximos;

    // ---- Getters y Setters ----

    public int getIdTipoSolicitud()                     { return idTipoSolicitud; }
    public void setIdTipoSolicitud(int v)               { this.idTipoSolicitud = v; }

    public String getNombreTipo()                       { return nombreTipo; }
    public void setNombreTipo(String v)                 { this.nombreTipo = v; }

    public String getDescripcion()                      { return descripcion; }
    public void setDescripcion(String v)                { this.descripcion = v; }

    public int getRequiereAprobacionRrhh()              { return requiereAprobacionRrhh; }
    public void setRequiereAprobacionRrhh(int v)        { this.requiereAprobacionRrhh = v; }

    public int getDiasMaximos()                         { return diasMaximos; }
    public void setDiasMaximos(int v)                   { this.diasMaximos = v; }
}