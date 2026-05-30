package com.turnos.util;

import javax.mail.*;
import javax.mail.internet.*;
import java.util.Properties;

public class EmailUtil {

    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";
    private static final String CORREO    = "baisiquic@gmail.com"; 
    private static final String PASSWORD  = "uoaf khli mvdf jgyn";     

    public static boolean enviar(String destinatario, String asunto, String cuerpoHtml) {
        Properties props = new Properties();
        props.put("mail.smtp.auth",            "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host",            SMTP_HOST);
        props.put("mail.smtp.port",            SMTP_PORT);

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(CORREO, PASSWORD);
            }
        });

        try {
            Message msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(CORREO, "Sistema de Turnos"));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(destinatario));
            msg.setSubject(asunto);
            msg.setContent(cuerpoHtml, "text/html; charset=UTF-8");
            Transport.send(msg);
            return true;
        } catch (Exception e) {
            System.out.println("Error al enviar correo: " + e.getMessage());
            return false;
        }
    }

    // ---- TEMPLATES DE CORREO ----

    public static String templateAprobacionJefe(String nombreEmpleado,
                                                 String tipoSolicitud,
                                                 String fechaInicio,
                                                 String fechaFin,
                                                 String comentario,
                                                 String nombreJefe) {
        return "<html><body style='font-family:Arial,sans-serif;background:#0d1117;margin:0;padding:20px;'>" +
               "<div style='max-width:520px;margin:auto;background:#161b22;border-radius:12px;" +
               "border:1px solid #30363d;padding:30px;'>" +
               "<div style='text-align:center;margin-bottom:20px;'>" +
               "<div style='width:50px;height:50px;background:linear-gradient(135deg,#00d4aa,#0070f3);" +
               "border-radius:10px;display:inline-flex;align-items:center;justify-content:center;" +
               "font-size:24px;'>✅</div>" +
               "</div>" +
               "<h2 style='color:#00d4aa;margin:0 0 8px;'>Solicitud Aprobada</h2>" +
               "<p style='color:#8b949e;font-size:13px;margin:0 0 20px;'>Por Jefe de Área</p>" +
               "<p style='color:#e6edf3;'>Estimado/a <strong>" + nombreEmpleado + "</strong>,</p>" +
               "<p style='color:#e6edf3;'>Su solicitud de <strong>" + tipoSolicitud +
               "</strong> ha sido <strong style='color:#00d4aa;'>APROBADA</strong> " +
               "por su jefe de área. Ahora pasa a revisión de RRHH.</p>" +
               "<table style='width:100%;background:#0d1117;border-radius:8px;padding:16px;" +
               "border:1px solid #30363d;border-collapse:separate;border-spacing:0;margin:20px 0;'>" +
               "<tr><td style='color:#8b949e;padding:6px 0;font-size:13px;'>Período:</td>" +
               "<td style='color:#e6edf3;font-size:13px;'>" + fechaInicio + " → " + fechaFin + "</td></tr>" +
               "<tr><td style='color:#8b949e;padding:6px 0;font-size:13px;'>Aprobado por:</td>" +
               "<td style='color:#e6edf3;font-size:13px;'>" + nombreJefe + "</td></tr>" +
               "<tr><td style='color:#8b949e;padding:6px 0;font-size:13px;'>Comentario:</td>" +
               "<td style='color:#e6edf3;font-size:13px;'>" +
               (comentario != null && !comentario.isEmpty() ? comentario : "Sin comentario") +
               "</td></tr>" +
               "</table>" +
               "<p style='color:#8b949e;font-size:12px;margin-top:20px;'>— Sistema de Control de Turnos</p>" +
               "</div></body></html>";
    }

    public static String templateRechazoJefe(String nombreEmpleado,
                                              String tipoSolicitud,
                                              String fechaInicio,
                                              String fechaFin,
                                              String comentario,
                                              String nombreJefe) {
        return "<html><body style='font-family:Arial,sans-serif;background:#0d1117;margin:0;padding:20px;'>" +
               "<div style='max-width:520px;margin:auto;background:#161b22;border-radius:12px;" +
               "border:1px solid #30363d;padding:30px;'>" +
               "<div style='text-align:center;margin-bottom:20px;'>" +
               "<div style='width:50px;height:50px;background:#4f1111;" +
               "border-radius:10px;display:inline-flex;align-items:center;justify-content:center;" +
               "font-size:24px;'>❌</div>" +
               "</div>" +
               "<h2 style='color:#ff4757;margin:0 0 8px;'>Solicitud Rechazada</h2>" +
               "<p style='color:#8b949e;font-size:13px;margin:0 0 20px;'>Por Jefe de Área</p>" +
               "<p style='color:#e6edf3;'>Estimado/a <strong>" + nombreEmpleado + "</strong>,</p>" +
               "<p style='color:#e6edf3;'>Lamentablemente su solicitud de <strong>" + tipoSolicitud +
               "</strong> ha sido <strong style='color:#ff4757;'>RECHAZADA</strong>.</p>" +
               "<table style='width:100%;background:#0d1117;border-radius:8px;padding:16px;" +
               "border:1px solid #30363d;border-collapse:separate;border-spacing:0;margin:20px 0;'>" +
               "<tr><td style='color:#8b949e;padding:6px 0;font-size:13px;'>Período:</td>" +
               "<td style='color:#e6edf3;font-size:13px;'>" + fechaInicio + " → " + fechaFin + "</td></tr>" +
               "<tr><td style='color:#8b949e;padding:6px 0;font-size:13px;'>Rechazado por:</td>" +
               "<td style='color:#e6edf3;font-size:13px;'>" + nombreJefe + "</td></tr>" +
               "<tr><td style='color:#8b949e;padding:6px 0;font-size:13px;'>Motivo:</td>" +
               "<td style='color:#e6edf3;font-size:13px;'>" +
               (comentario != null && !comentario.isEmpty() ? comentario : "No especificado") +
               "</td></tr>" +
               "</table>" +
               "<p style='color:#8b949e;font-size:12px;margin-top:20px;'>— Sistema de Control de Turnos</p>" +
               "</div></body></html>";
    }

    public static String templateAprobacionRRHH(String nombreEmpleado,
                                                  String tipoSolicitud,
                                                  String fechaInicio,
                                                  String fechaFin,
                                                  String comentario) {
        return "<html><body style='font-family:Arial,sans-serif;background:#0d1117;margin:0;padding:20px;'>" +
               "<div style='max-width:520px;margin:auto;background:#161b22;border-radius:12px;" +
               "border:1px solid #30363d;padding:30px;'>" +
               "<div style='text-align:center;margin-bottom:20px;'>" +
               "<div style='width:50px;height:50px;background:linear-gradient(135deg,#00d4aa,#0070f3);" +
               "border-radius:10px;display:inline-flex;align-items:center;justify-content:center;" +
               "font-size:24px;'>🎉</div>" +
               "</div>" +
               "<h2 style='color:#00d4aa;margin:0 0 8px;'>¡Permiso Autorizado!</h2>" +
               "<p style='color:#8b949e;font-size:13px;margin:0 0 20px;'>Por Recursos Humanos</p>" +
               "<p style='color:#e6edf3;'>Estimado/a <strong>" + nombreEmpleado + "</strong>,</p>" +
               "<p style='color:#e6edf3;'>Su solicitud de <strong>" + tipoSolicitud +
               "</strong> ha sido <strong style='color:#00d4aa;'>AUTORIZADA DEFINITIVAMENTE</strong> " +
               "por Recursos Humanos.</p>" +
               "<table style='width:100%;background:#0d1117;border-radius:8px;padding:16px;" +
               "border:1px solid #30363d;border-collapse:separate;border-spacing:0;margin:20px 0;'>" +
               "<tr><td style='color:#8b949e;padding:6px 0;font-size:13px;'>Período autorizado:</td>" +
               "<td style='color:#e6edf3;font-size:13px;'>" + fechaInicio + " → " + fechaFin + "</td></tr>" +
               "<tr><td style='color:#8b949e;padding:6px 0;font-size:13px;'>Comentario RRHH:</td>" +
               "<td style='color:#e6edf3;font-size:13px;'>" +
               (comentario != null && !comentario.isEmpty() ? comentario : "Sin comentario") +
               "</td></tr>" +
               "</table>" +
               "<p style='color:#00d4aa;font-size:14px;'>Su permiso ha sido registrado. ¡Que lo disfrute!</p>" +
               "<p style='color:#8b949e;font-size:12px;margin-top:20px;'>— Sistema de Control de Turnos</p>" +
               "</div></body></html>";
    }

    public static String templateRechazoRRHH(String nombreEmpleado,
                                               String tipoSolicitud,
                                               String fechaInicio,
                                               String fechaFin,
                                               String comentario) {
        return "<html><body style='font-family:Arial,sans-serif;background:#0d1117;margin:0;padding:20px;'>" +
               "<div style='max-width:520px;margin:auto;background:#161b22;border-radius:12px;" +
               "border:1px solid #30363d;padding:30px;'>" +
               "<div style='text-align:center;margin-bottom:20px;'>" +
               "<div style='width:50px;height:50px;background:#4f1111;" +
               "border-radius:10px;display:inline-flex;align-items:center;justify-content:center;" +
               "font-size:24px;'>❌</div>" +
               "</div>" +
               "<h2 style='color:#ff4757;margin:0 0 8px;'>Solicitud No Autorizada</h2>" +
               "<p style='color:#8b949e;font-size:13px;margin:0 0 20px;'>Por Recursos Humanos</p>" +
               "<p style='color:#e6edf3;'>Estimado/a <strong>" + nombreEmpleado + "</strong>,</p>" +
               "<p style='color:#e6edf3;'>Lamentablemente su solicitud de <strong>" + tipoSolicitud +
               "</strong> no ha sido autorizada por Recursos Humanos.</p>" +
               "<table style='width:100%;background:#0d1117;border-radius:8px;padding:16px;" +
               "border:1px solid #30363d;border-collapse:separate;border-spacing:0;margin:20px 0;'>" +
               "<tr><td style='color:#8b949e;padding:6px 0;font-size:13px;'>Período:</td>" +
               "<td style='color:#e6edf3;font-size:13px;'>" + fechaInicio + " → " + fechaFin + "</td></tr>" +
               "<tr><td style='color:#8b949e;padding:6px 0;font-size:13px;'>Motivo:</td>" +
               "<td style='color:#e6edf3;font-size:13px;'>" +
               (comentario != null && !comentario.isEmpty() ? comentario : "No especificado") +
               "</td></tr>" +
               "</table>" +
               "<p style='color:#8b949e;font-size:12px;margin-top:20px;'>— Sistema de Control de Turnos</p>" +
               "</div></body></html>";
    }
}