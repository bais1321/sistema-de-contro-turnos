package com.turnos.util;

import com.turnos.modelo.Bitacora;
import com.turnos.modelo.HistorialCambio;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

public class ExcelUtil {

    /**
     * Exporta el historial de cambios a CSV compatible con Excel.
     * No requiere dependencias externas.
     */
    public static void exportarHistorial(List<HistorialCambio> lista,
                                          HttpServletResponse response)
            throws IOException {

        response.setContentType("application/vnd.ms-excel; charset=UTF-8");
        response.setHeader("Content-Disposition",
                "attachment; filename=\"historial_cambios.csv\"");
        response.setCharacterEncoding("UTF-8");

        PrintWriter pw = response.getWriter();

        // BOM para que Excel reconozca UTF-8 correctamente
        pw.write('\uFEFF');

        // Encabezados
        pw.println("ID,Tabla Afectada,ID Registro,Tipo Operacion," +
                   "Administrador,Descripcion,Fecha y Hora,IP");

        // Filas
        for (HistorialCambio h : lista) {
            pw.println(
                csv(String.valueOf(h.getIdHistorial()))   + "," +
                csv(h.getTablaAfectada())                 + "," +
                csv(String.valueOf(h.getIdRegistro()))    + "," +
                csv(h.getTipoOperacion())                 + "," +
                csv(h.getNombreAdmin())                   + "," +
                csv(h.getDescripcion())                   + "," +
                csv(h.getFechaHora())                     + "," +
                csv(h.getIpAddress())
            );
        }
        pw.flush();
    }

    /**
     * Exporta la bitácora del sistema a CSV compatible con Excel.
     */
    public static void exportarBitacora(List<Bitacora> lista,
                                         HttpServletResponse response)
            throws IOException {

        response.setContentType("application/vnd.ms-excel; charset=UTF-8");
        response.setHeader("Content-Disposition",
                "attachment; filename=\"bitacora_sistema.csv\"");
        response.setCharacterEncoding("UTF-8");

        PrintWriter pw = response.getWriter();
        pw.write('\uFEFF');

        // Encabezados
        pw.println("ID,Usuario,Nombre Completo,Tipo Operacion," +
                   "Modulo,Descripcion,IP,Fecha y Hora");

        // Filas
        for (Bitacora b : lista) {
            pw.println(
                csv(String.valueOf(b.getIdBitacora())) + "," +
                csv(b.getUsername())                   + "," +
                csv(b.getNombreCompleto())             + "," +
                csv(b.getTipoOperacion())              + "," +
                csv(b.getModulo())                     + "," +
                csv(b.getDescripcion())                + "," +
                csv(b.getIpAddress())                  + "," +
                csv(b.getFechaHora())
            );
        }
        pw.flush();
    }

    /**
     * Escapa un valor para CSV:
     * envuelve en comillas dobles y escapa comillas internas.
     */
    private static String csv(String value) {
        if (value == null) return "\"\"";
        return "\"" + value.replace("\"", "\"\"") + "\"";
    }
}