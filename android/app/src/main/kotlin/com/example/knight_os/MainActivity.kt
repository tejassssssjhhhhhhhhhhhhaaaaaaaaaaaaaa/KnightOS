package com.example.knight_os

import io.flutter.embedding.android.FlutterActivity
import android.os.Bundle
import android.util.Log

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        Log.e("KNIGHT_NATIVE", "MainActivity.onCreate() started")
        super.onCreate(savedInstanceState)
        Log.e("KNIGHT_NATIVE", "MainActivity.onCreate() finished")
    }
}
