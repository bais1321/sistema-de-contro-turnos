package com.turnos.modelo;

import java.util.List;

public class Usuario {

    private int     idUsuario;
    private String  dpi;
    private String  nombreCompleto;
    private String  username;
    private String  password;
    private String  email;
    private int     idArea;
    private int     idTurnoActual;
    private int     idJefeArea;
    private boolean esJefeArea;
    private String  estado;
    private String  motivoInactivacion;
    private String  fechaInactivacion;
    private int     intentosFallidos;
    private String  ultimoAcceso;
    private String  createdAt;

    // Campos extra para vistas (JOIN)
    private String       nombreArea;
    private String       nombreTurno;
    private String       nombreJefe;
    private List<String> roles;

    // ── Getters y Setters ────────────────────────────────────────
    public int    getIdUsuario()               { return idUsuario; }
    public void   setIdUsuario(int v)          { this.idUsuario = v; }
    public String getDpi()                     { return dpi; }
    public void   setDpi(String v)             { this.dpi = v; }
    public String getNombreCompleto()          { return nombreCompleto; }
    public void   setNombreCompleto(String v)  { this.nombreCompleto = v; }
    public String getUsername()                { return username; }
    public void   setUsername(String v)        { this.username = v; }
    public String getPassword()                { return password; }
    public void   setPassword(String v)        { this.password = v; }
    public String getEmail()                   { return email; }
    public void   setEmail(String v)           { this.email = v; }
    public int    getIdArea()                  { return idArea; }
    public void   setIdArea(int v)             { this.idArea = v; }
    public int    getIdTurnoActual()           { return idTurnoActual; }
    public void   setIdTurnoActual(int v)      { this.idTurnoActual = v; }
    public int    getIdJefeArea()              { return idJefeArea; }
    public void   setIdJefeArea(int v)         { this.idJefeArea = v; }
    public boolean isEsJefeArea()              { return esJefeArea; }
    public void   setEsJefeArea(boolean v)     { this.esJefeArea = v; }
    public String getEstado()                  { return estado; }
    public void   setEstado(String v)          { this.estado = v; }
    public String getMotivoInactivacion()      { return motivoInactivacion; }
    public void   setMotivoInactivacion(String v){ this.motivoInactivacion = v; }
    public String getFechaInactivacion()       { return fechaInactivacion; }
    public void   setFechaInactivacion(String v){ this.fechaInactivacion = v; }
    public int    getIntentosFallidos()        { return intentosFallidos; }
    public void   setIntentosFallidos(int v)   { this.intentosFallidos = v; }
    public String getUltimoAcceso()            { return ultimoAcceso; }
    public void   setUltimoAcceso(String v)    { this.ultimoAcceso = v; }
    public String getCreatedAt()               { return createdAt; }
    public void   setCreatedAt(String v)       { this.createdAt = v; }
    public String getNombreArea()              { return nombreArea; }
    public void   setNombreArea(String v)      { this.nombreArea = v; }
    public String getNombreTurno()             { return nombreTurno; }
    public void   setNombreTurno(String v)     { this.nombreTurno = v; }
    public String getNombreJefe()              { return nombreJefe; }
    public void   setNombreJefe(String v)      { this.nombreJefe = v; }
    public List<String> getRoles()             { return roles; }
    public void   setRoles(List<String> v)     { this.roles = v; }

    // ── Método genérico (para uso en Java) ──────────────────────
    public boolean tieneRol(String rol) {
        return roles != null && roles.contains(rol);
    }

    // ── Getters booleanos por rol (para JSTL / EL) ──────────────
    // JSTL Expression Language NO puede llamar métodos con parámetros,
    // por eso necesitamos un getter por cada rol.
    // En el JSP se usa: ${menuUsuario.rolAdminRRHH}
    //                   ${menuUsuario.rolJefeArea}  etc.

    public boolean isRolAdminRRHH() {
        return tieneRol("AdminRRHH");
    }

    public boolean isRolAdminArea() {
        return tieneRol("AdminArea");
    }

    public boolean isRolJefeArea() {
        return tieneRol("JefeArea");
    }

    public boolean isRolEmpleado() {
        return tieneRol("Empleado");
    }
}
