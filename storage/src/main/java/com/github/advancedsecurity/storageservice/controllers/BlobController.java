package com.github.advancedsecurity.storageservice.controllers;

import java.util.UUID;
import java.util.List;
import java.io.InputStream;

import io.minio.GetObjectArgs;
import io.minio.MinioClient;
import io.minio.PutObjectArgs;
import io.minio.StatObjectArgs;

import lombok.RequiredArgsConstructor;

import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.server.ResponseStatusException;
import org.springframework.http.HttpStatus;
import org.springframework.web.multipart.MultipartFile;

import com.github.advancedsecurity.storageservice.config.MinioConfig;
// import com.github.advancedsecurity.storageservice.security.JwtAuthenticationToken;
import com.github.advancedsecurity.storageservice.models.Blob;
import com.github.advancedsecurity.storageservice.models.Profile;

@CrossOrigin
@RestController
@RequiredArgsConstructor
public class BlobController {

    private final MinioClient minio;

    @Value("${blob.allowed-content-types}")
    private List<String> allowedContentTypes;

    @Value("${minio.put-object-part-size}")
    private long putObjectPartSize;

    @GetMapping("/blob/{id}")
    // public Blob get(@PathVariable UUID id, JwtAuthenticationToken token) {
    public Blob get(@PathVariable UUID id) {
        // var profile = (Profile)token.getPrincipal();
        try {
            // var path = String.format("%s/%s", profile.name, id.toString());
            var path = String.format("%s", id);

                System.out.format(id + "-local", path );

            var stat = minio.statObject(
                StatObjectArgs
                    .builder()
                    .bucket(MinioConfig.DEFAULT_BUCKET_NAME)
                    .object(path)
                    .build()
            );

            var is = minio.getObject(
                GetObjectArgs
                    .builder()
                    .bucket(MinioConfig.DEFAULT_BUCKET_NAME)
                    .object(path)
                    .build()
            );
            
            return new Blob(
                stat.contentType(), 
                is.readAllBytes()
            );
        } catch (Exception e) {
            throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Failed to retrieve blob!");
        }
    }

    @PostMapping("/blob")
    // public UUID post(@RequestParam MultipartFile file, @RequestParam(defaultValue="false") boolean isBlob, JwtAuthenticationToken token) {
    public UUID post(@RequestParam("file") MultipartFile file) {
        // var profile = (Profile)token.getPrincipal();
        try {
            var id = UUID.randomUUID();

            if(!allowedContentTypes.contains(file.getContentType())) {
                throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Disallowed content type");
            }

            // var path = String.format("%s/%s", profile.name, id.toString());
            var path = String.format("%s", id);

            minio.putObject(
                PutObjectArgs
                    .builder()
                    .bucket(MinioConfig.DEFAULT_BUCKET_NAME)
                    .contentType(file.getContentType())
                    .object(path)
                    .stream(file.getInputStream(), file.getSize(), putObjectPartSize)
                    .build()
            );

            return id;
        } catch (Exception e) {
           throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Failed to store blob!");
        }
    }
}
