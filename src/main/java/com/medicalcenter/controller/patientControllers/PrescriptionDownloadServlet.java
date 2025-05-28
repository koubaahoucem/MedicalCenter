package com.medicalcenter.controller.patientControllers;

import com.medicalcenter.model.Prescription;
import com.medicalcenter.model.User;
import com.medicalcenter.service.PrescriptionService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;

@WebServlet("/patient/prescriptions/download/*")
public class PrescriptionDownloadServlet extends HttpServlet {

    private PrescriptionService prescriptionService;

    @Override
    public void init() throws ServletException {
        prescriptionService = new PrescriptionService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // Check if user is logged in
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");

        try {
            // Get prescription ID from path
            String pathInfo = request.getPathInfo();
            if (pathInfo == null || pathInfo.equals("/")) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID d'ordonnance manquant");
                return;
            }

            int prescriptionId = Integer.parseInt(pathInfo.substring(1));

            // Get prescription
            Prescription prescription = prescriptionService.getPrescriptionById(prescriptionId);

            if (prescription == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Ordonnance non trouvée");
                return;
            }

            // Check if file exists
            String filePath = prescription.getFilePath();
            if (filePath == null || filePath.isEmpty()) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Fichier d'ordonnance non disponible");
                return;
            }

            // Get file
            File file = new File(filePath);
            if (!file.exists()) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Fichier d'ordonnance non trouvé");
                return;
            }

            // Set response headers
            String fileName = "ordonnance_" + prescriptionId + ".pdf";
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
            response.setContentLength((int) file.length());

            // Stream file to response
            try (FileInputStream in = new FileInputStream(file);
                 OutputStream out = response.getOutputStream()) {

                byte[] buffer = new byte[4096];
                int bytesRead;

                while ((bytesRead = in.read(buffer)) != -1) {
                    out.write(buffer, 0, bytesRead);
                }
            }

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID d'ordonnance invalide");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Une erreur est survenue: " + e.getMessage());
        }
    }
}
