package com.turnos.modelo;

public class Marcaje {

    private int     idMarcaje;
    private int     idUsuario;
    private String  fecha;
    private String  horaEntrada;
    private String  horaInicioBreak;
    private String  horaFinBreak;
    private String  horaInicioLonch;
    private String  horaFinLonch;
    private String  horaSalida;
    private boolean entradaTarde;
    private String  ipMarcaje;
    private String  dispositivo;
    private String  createdAt;

    // Campos extra JOIN
    private String  nombreCompleto;
    private String  username;
    private String  nombreArea;
    private String  nombreTurno;
    private String  estadoMarcaje;
    private long    minutosBreak;
    private long    minutosLonch;
    private boolean breakExcedido;
    private boolean lonchExcedido;

    // Getters y Setters
    public int     getIdMarcaje()                    { return idMarcaje; }
    public void    setIdMarcaje(int v)               { this.idMarcaje = v; }
    public int     getIdUsuario()                    { return idUsuario; }
    public void    setIdUsuario(int v)               { this.idUsuario = v; }
    public String  getFecha()                        { return fecha; }
    public void    setFecha(String v)                { this.fecha = v; }
    public String  getHoraEntrada()                  { return horaEntrada; }
    public void    setHoraEntrada(String v)          { this.horaEntrada = v; }
    public String  getHoraInicioBreak()              { return horaInicioBreak; }
    public void    setHoraInicioBreak(String v)      { this.horaInicioBreak = v; }
    public String  getHoraFinBreak()                 { return horaFinBreak; }
    public void    setHoraFinBreak(String v)         { this.horaFinBreak = v; }
    public String  getHoraInicioLonch()              { return horaInicioLonch; }
    public void    setHoraInicioLonch(String v)      { this.horaInicioLonch = v; }
    public String  getHoraFinLonch()                 { return horaFinLonch; }
    public void    setHoraFinLonch(String v)         { this.horaFinLonch = v; }
    public String  getHoraSalida()                   { return horaSalida; }
    public void    setHoraSalida(String v)           { this.horaSalida = v; }
    public boolean isEntradaTarde()                  { return entradaTarde; }
    public void    setEntradaTarde(boolean v)        { this.entradaTarde = v; }
    public String  getIpMarcaje()                    { return ipMarcaje; }
    public void    setIpMarcaje(String v)            { this.ipMarcaje = v; }
    public String  getDispositivo()                  { return dispositivo; }
    public void    setDispositivo(String v)          { this.dispositivo = v; }
    public String  getCreatedAt()                    { return createdAt; }
    public void    setCreatedAt(String v)            { this.createdAt = v; }
    public String  getNombreCompleto()               { return nombreCompleto; }
    public void    setNombreCompleto(String v)       { this.nombreCompleto = v; }
    public String  getUsername()                     { return username; }
    public void    setUsername(String v)             { this.username = v; }
    public String  getNombreArea()                   { return nombreArea; }
    public void    setNombreArea(String v)           { this.nombreArea = v; }
    public String  getNombreTurno()                  { return nombreTurno; }
    public void    setNombreTurno(String v)          { this.nombreTurno = v; }
    public String  getEstadoMarcaje()                { return estadoMarcaje; }
    public void    setEstadoMarcaje(String v)        { this.estadoMarcaje = v; }
    public long    getMinutosBreak()                 { return minutosBreak; }
    public void    setMinutosBreak(long v)           { this.minutosBreak = v; }
    public long    getMinutosLonch()                 { return minutosLonch; }
    public void    setMinutosLonch(long v)           { this.minutosLonch = v; }
    public boolean isBreakExcedido()                 { return breakExcedido; }
    public void    setBreakExcedido(boolean v)       { this.breakExcedido = v; }
    public boolean isLonchExcedido()                 { return lonchExcedido; }
    public void    setLonchExcedido(boolean v)       { this.lonchExcedido = v; }
}