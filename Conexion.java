package com.turnos.conexion;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Conexion {

    private static final String URL     = "jdbc:mysql://localhost:3308/sistema_turnos2?useSSL=false&serverTimezone=America/Guatemala&characterEncoding=UTF-8";
    private static final String USUARIO = "byron";
    private static final String CLAVE   = "";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("Driver MySQL no encontrado", e);
        }
    }

    public static Connection getConexion() throws SQLException {
        return DriverManager.getConnection(URL, USUARIO, CLAVE);
    }
}