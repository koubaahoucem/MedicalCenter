//package com.medicalcenter.controller;
//
//import com.medicalcenter.model.MedicalDocument;
//import com.medicalcenter.model.User;
//import com.medicalcenter.service.MedicalRecordService;
//
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.MultipartConfig;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import jakarta.servlet.http.Part;
//import java.io.File;
//import java.io.IOException;
//import java.nio.file.Paths;
//import java.util.UUID;
//
//@WebServlet("/upload")
//@MultipartConfig(
//        fileSizeThreshold = 1024 * 1024, // 1 MB
//        maxFileSize = 1024 * 1024 * 10,  // 10 MB
//        maxRequestSize = 1024 * 1024 * 50 // 50 MB
//)
//public class FileUploadServlet extends HttpServlet {
//
//    private MedicalRecordService medicalRecordService;
//    private String uploadPath;
//
//    @Override
//    public void init() throws ServletException {
//        super.init();
//        medicalRecordService = new MedicalRecordService();
//        uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
//        File uploadDir = new File(uploadPath);
//        if (!uploadDir.exists()) {
//            uploadDir.mkdir();
//        }
//    }
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//
//        // Check if user is logged in
//        User user = (User) request.getSession().getAttribute("user");
//        if (user == null) {
//            response.sendRedirect(request.getContextPath() + "/login.jsp");
//            return;
//        }
//
//        int recordId = Integer.parseInt(request.getParameter("recordId"));
//        String description = request.getParameter("description");
//
//        // Process the uploaded file
//        Part filePart = request.getPart("file");
//        String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
//
//        // Generate a unique file name to prevent overwriting
//        String uniqueFileName = UUID.randomUUID().toString() + "_" + fileName;
//        String filePath = uploadPath + File.separator + uniqueFileName;
//
//        // Save the file to disk
//        filePart.write(filePath);
//
//        // Save file information to database
//        MedicalDocument document = new MedicalDocument();
//        document.setRecordId(recordId);
//        document.setFilePath("uploads/" + uniqueFileName);
//        document.setDescription(description);
//        document.setUploadedBy(user.getId());
//
//        medicalRecordService.addDocumentToRecord(document);
//
//        // Redirect back to the medical record page
//        response.sendRedirect(request.getContextPath() + "/doctor/medical-record?id=" + recordId);
//    }
//}