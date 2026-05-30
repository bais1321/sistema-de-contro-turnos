package com.turnos.modelo;

public class Bitacora {

    private int    idBitacora;
    private int    idUsuario;
    private String username;
    private String nombreCompleto;
    private String tipoOperacion;
    private String modulo;
    private String descripcion;
    private String ipAddress;
    private String fechaHora;

    // ---- Getters y Setters ----

    public int getIdBitacora()                   { return idBitacora; }
    public void setIdBitacora(int v)             { this.idBitacora = v; }

    public int getIdUsuario()                    { return idUsuario; }
    public void setIdUsuario(int v)              { this.idUsuario = v; }

    public String getUsername()                  { return username; }
    public void setUsername(String v)            { this.username = v; }

    public String getNombreCompleto()            { return nombreCompleto; }
    public void setNombreCompleto(String v)      { this.nombreCompleto = v; }

    public String getTipoOperacion()             { return tipoOperacion; }
    public void setTipoOperacion(String v)       { this.tipoOperacion = v; }

    public String getModulo()                    { return modulo; }
    public void setModulo(String v)              { this.modulo = v; }

    public String getDescripcion()               { return descripcion; }
    public void setDescripcion(String v)         { this.descripcion = v; }

    public String getIpAddress()                 { return ipAddress; }
    public void setIpAddress(String v)           { this.ipAddress = v; }

    public String getFechaHora()                 { return fechaHora; }
    public void setFechaHora(String v)           { this.fechaHora = v; }
}