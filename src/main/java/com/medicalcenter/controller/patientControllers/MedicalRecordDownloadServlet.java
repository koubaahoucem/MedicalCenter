package com.medicalcenter.controller.patientControllers;

import com.medicalcenter.dao.MedicalDocumentDAO;
import com.medicalcenter.model.MedicalDocument;

import com.medicalcenter.model.User;
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

@WebServlet("/patient/medical-record/download")
public class MedicalRecordDownloadServlet extends HttpServlet {
    private MedicalDocumentDAO medicalDocumentDAO;

    @Override
    public void init() throws ServletException {
        medicalDocumentDAO = new MedicalDocumentDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // Check if user is logged in
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        String documentIdStr = request.getParameter("documentId");
        if (documentIdStr == null || documentIdStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Document ID is required");
            return;
        }

        try {
            int documentId = Integer.parseInt(documentIdStr);
            MedicalDocument document = medicalDocumentDAO.getMedicalDocumentById(documentId);
            
            if (document == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Document not found");
                return;
            }

            // Security check: ensure the document belongs to the current user
            // This would require additional validation based on your security model

            File file = new File(document.getFilePath());
            if (!file.exists()) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "File not found on server");
                return;
            }

            // Set response headers
            response.setContentType("application/octet-stream");
            response.setHeader("Content-Disposition", "attachment; filename=\"" + document.getFileName() + "\"");
            response.setContentLength((int) file.length());

            // Stream the file
            try (FileInputStream fileInputStream = new FileInputStream(file);
                 OutputStream outputStream = response.getOutputStream()) {
                
                byte[] buffer = new byte[4096];
                int bytesRead;
                while ((bytesRead = fileInputStream.read(buffer)) != -1) {
                    outputStream.write(buffer, 0, bytesRead);
                }
            }

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid document ID");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error downloading document");
        }
    }
}
