package com.example.knight_os

import io.flutter.embedding.android.FlutterFragmentActivity
import android.os.Bundle
import androidx.core.view.WindowCompat
import androidx.core.splashscreen.SplashScreen.Companion.installSplashScreen

class MainActivity : FlutterFragmentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        // P0-1: Zero-delay launch
        installSplashScreen()
        super.onCreate(savedInstanceState)
        
        // P0-1: Ensure edge-to-edge rendering from the first frame
        WindowCompat.setDecorFitsSystemWindows(window, false)
    }
}
