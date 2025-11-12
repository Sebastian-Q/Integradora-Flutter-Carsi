package com.example.SIGAUT_BACK.services;

import com.google.cloud.storage.Blob;
import com.google.cloud.storage.BlobId;
import com.google.cloud.storage.BlobInfo;
import com.google.firebase.cloud.StorageClient;
import org.springframework.stereotype.Service;

import java.io.IOException;

@Service
public class FirebaseStorageService {

    private final StorageClient storageClient;

    public FirebaseStorageService(StorageClient storageClient) {
        this.storageClient = storageClient;
    }

    public String uploadFile(byte[] fileBytes, String fileName, String contentType) throws IOException {
        BlobId blobId = BlobId.of(storageClient.bucket().getName(), fileName);
        BlobInfo blobInfo = BlobInfo.newBuilder(blobId)
                .setContentType(contentType)
                .build();

        Blob blob = storageClient.bucket().create(blobInfo.getName(), fileBytes, blobInfo.getContentType());

        return String.format("https://storage.googleapis.com/%s/%s", blob.getBucket(), blob.getName());
    }

}
