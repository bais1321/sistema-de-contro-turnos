package com.turnos.modelo;

public class Solicitud {

    private int    idSolicitud;
    private int    idUsuarioSolicitante;
    private int    idTipoSolicitud;
    private int    idEstado;
    private int    idJefeArea;
    private int    idAdminRrhhAprobador;
    private int    idTurnoActual;
    private int    idTurnoSolicitado;
    private String estadoAprobacion;
    private String fechaSolicitud;
    private String fechaInicio;
    private String fechaFin;
    private String fechaTurnoActual;
    private String fechaTurnoNuevo;
    private String motivo;
    private String justificacion;
    private String fechaAprobacionJefe;
    private String comentarioJefe;
    private String fechaAprobacionRrhh;
    private String comentarioAprobacionRrhh;
    private boolean notificacionEnviada;

    // Campos extra para vistas (JOIN)
    private String nombreSolicitante;
    private String emailSolicitante;
    private String usernameSolicitante;
    private String areaSolicitante;
    private String turnoSolicitante;
    private String nombreTipoSolicitud;
    private String nombreEstado;
    private String nombreJefeArea;
    private String nombreAdminRrhh;
    private String nombreTurnoActual;
    private String nombreTurnoSolicitado;
    private int    diasSolicitados;

    // ---- Getters y Setters ----

    public int getIdSolicitud()                         { return idSolicitud; }
    public void setIdSolicitud(int v)                   { this.idSolicitud = v; }

    public int getIdUsuarioSolicitante()                { return idUsuarioSolicitante; }
    public void setIdUsuarioSolicitante(int v)          { this.idUsuarioSolicitante = v; }

    public int getIdTipoSolicitud()                     { return idTipoSolicitud; }
    public void setIdTipoSolicitud(int v)               { this.idTipoSolicitud = v; }

    public int getIdEstado()                            { return idEstado; }
    public void setIdEstado(int v)                      { this.idEstado = v; }

    public int getIdJefeArea()                          { return idJefeArea; }
    public void setIdJefeArea(int v)                    { this.idJefeArea = v; }

    public int getIdAdminRrhhAprobador()                { return idAdminRrhhAprobador; }
    public void setIdAdminRrhhAprobador(int v)          { this.idAdminRrhhAprobador = v; }

    public int getIdTurnoActual()                       { return idTurnoActual; }
    public void setIdTurnoActual(int v)                 { this.idTurnoActual = v; }

    public int getIdTurnoSolicitado()                   { return idTurnoSolicitado; }
    public void setIdTurnoSolicitado(int v)             { this.idTurnoSolicitado = v; }

    public String getEstadoAprobacion()                 { return estadoAprobacion; }
    public void setEstadoAprobacion(String v)           { this.estadoAprobacion = v; }

    public String getFechaSolicitud()                   { return fechaSolicitud; }
    public void setFechaSolicitud(String v)             { this.fechaSolicitud = v; }

    public String getFechaInicio()                      { return fechaInicio; }
    public void setFechaInicio(String v)                { this.fechaInicio = v; }

    public String getFechaFin()                         { return fechaFin; }
    public void setFechaFin(String v)                   { this.fechaFin = v; }

    public String getFechaTurnoActual()                 { return fechaTurnoActual; }
    public void setFechaTurnoActual(String v)           { this.fechaTurnoActual = v; }

    public String getFechaTurnoNuevo()                  { return fechaTurnoNuevo; }
    public void setFechaTurnoNuevo(String v)            { this.fechaTurnoNuevo = v; }

    public String getMotivo()                           { return motivo; }
    public void setMotivo(String v)                     { this.motivo = v; }

    public String getJustificacion()                    { return justificacion; }
    public void setJustificacion(String v)              { this.justificacion = v; }

    public String getFechaAprobacionJefe()              { return fechaAprobacionJefe; }
    public void setFechaAprobacionJefe(String v)        { this.fechaAprobacionJefe = v; }

    public String getComentarioJefe()                   { return comentarioJefe; }
    public void setComentarioJefe(String v)             { this.comentarioJefe = v; }

    public String getFechaAprobacionRrhh()              { return fechaAprobacionRrhh; }
    public void setFechaAprobacionRrhh(String v)        { this.fechaAprobacionRrhh = v; }

    public String getComentarioAprobacionRrhh()         { return comentarioAprobacionRrhh; }
    public void setComentarioAprobacionRrhh(String v)   { this.comentarioAprobacionRrhh = v; }

    public boolean isNotificacionEnviada()              { return notificacionEnviada; }
    public void setNotificacionEnviada(boolean v)       { this.notificacionEnviada = v; }

    public String getNombreSolicitante()                { return nombreSolicitante; }
    public void setNombreSolicitante(String v)          { this.nombreSolicitante = v; }

    public String getEmailSolicitante()                 { return emailSolicitante; }
    public void setEmailSolicitante(String v)           { this.emailSolicitante = v; }

    public String getUsernameSolicitante()              { return usernameSolicitante; }
    public void setUsernameSolicitante(String v)        { this.usernameSolicitante = v; }

    public String getAreaSolicitante()                  { return areaSolicitante; }
    public void setAreaSolicitante(String v)            { this.areaSolicitante = v; }

    public String getTurnoSolicitante()                 { return turnoSolicitante; }
    public void setTurnoSolicitante(String v)           { this.turnoSolicitante = v; }

    public String getNombreTipoSolicitud()              { return nombreTipoSolicitud; }
    public void setNombreTipoSolicitud(String v)        { this.nombreTipoSolicitud = v; }

    public String getNombreEstado()                     { return nombreEstado; }
    public void setNombreEstado(String v)               { this.nombreEstado = v; }

    public String getNombreJefeArea()                   { return nombreJefeArea; }
    public void setNombreJefeArea(String v)             { this.nombreJefeArea = v; }

    public String getNombreAdminRrhh()                  { return nombreAdminRrhh; }
    public void setNombreAdminRrhh(String v)            { this.nombreAdminRrhh = v; }

    public String getNombreTurnoActual()                { return nombreTurnoActual; }
    public void setNombreTurnoActual(String v)          { this.nombreTurnoActual = v; }

    public String getNombreTurnoSolicitado()            { return nombreTurnoSolicitado; }
    public void setNombreTurnoSolicitado(String v)      { this.nombreTurnoSolicitado = v; }

    public int getDiasSolicitados()                     { return diasSolicitados; }
    public void setDiasSolicitados(int v)               { this.diasSolicitados = v; }

    public void setEstado(String v) {
        this.nombreEstado = v;
    }

    public void setNombreTipo(String v) {
        this.nombreTipoSolicitud = v;
    }
    
    // Métodos de compatibilidad para el DAO
    public void setUsuario(String v) {
        this.usernameSolicitante = v;
    }

    public String getUsuario() {
        return usernameSolicitante;
    }
}