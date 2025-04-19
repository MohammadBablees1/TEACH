package com.example.teach;

import android.os.Bundle;
import io.flutter.embedding.android.FlutterActivity;
import android.view.Window;
import android.view.WindowManager;

public class MainActivity extends FlutterActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        
        // Set the FLAG_SECURE flag to prevent screenshots and screen recording
        Window window = getWindow();
        if (window != null) {
            window.addFlags(WindowManager.LayoutParams.FLAG_SECURE);
        }
    }

}