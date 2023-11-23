package com.github.advancedsecurity.storageservice.models;

import java.util.Base64;

public class Blob {
    private String mimeType;
    private String base64EncodedData;

    public Blob(String mimeType, byte[] data) {
        this.mimeType = mimeType;
        this.base64EncodedData = Base64.getEncoder().encodeToString(data);
    }

    public String getMimeType() {
        return this.mimeType;
    }

    public String getData() {
        return this.base64EncodedData;
    }
}