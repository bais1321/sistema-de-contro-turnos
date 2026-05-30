package com.turnos.modelo;

public class HistorialCambio {

    private int    idHistorial;
    private String tablaAfectada;
    private int    idRegistro;
    private String tipoOperacion;
    private String datosAnteriores;
    private String datosNuevos;
    private int    idUsuarioAdmin;
    private String nombreAdmin;
    private String fechaHora;
    private String ipAddress;
    private String descripcion;

    // ---- Getters y Setters ----

    public int getIdHistorial()                      { return idHistorial; }
    public void setIdHistorial(int v)                { this.idHistorial = v; }

    public String getTablaAfectada()                 { return tablaAfectada; }
    public void setTablaAfectada(String v)           { this.tablaAfectada = v; }

    public int getIdRegistro()                       { return idRegistro; }
    public void setIdRegistro(int v)                 { this.idRegistro = v; }

    public String getTipoOperacion()                 { return tipoOperacion; }
    public void setTipoOperacion(String v)           { this.tipoOperacion = v; }

    public String getDatosAnteriores()               { return datosAnteriores; }
    public void setDatosAnteriores(String v)         { this.datosAnteriores = v; }

    public String getDatosNuevos()                   { return datosNuevos; }
    public void setDatosNuevos(String v)             { this.datosNuevos = v; }

    public int getIdUsuarioAdmin()                   { return idUsuarioAdmin; }
    public void setIdUsuarioAdmin(int v)             { this.idUsuarioAdmin = v; }

    public String getNombreAdmin()                   { return nombreAdmin; }
    public void setNombreAdmin(String v)             { this.nombreAdmin = v; }

    public String getFechaHora()                     { return fechaHora; }
    public void setFechaHora(String v)               { this.fechaHora = v; }

    public String getIpAddress()                     { return ipAddress; }
    public void setIpAddress(String v)               { this.ipAddress = v; }

    public String getDescripcion()                   { return descripcion; }
    public void setDescripcion(String v)             { this.descripcion = v; }
}