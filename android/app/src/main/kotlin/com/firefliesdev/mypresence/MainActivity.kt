package com.firefliesdev.mypresence

import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel

import android.R.attr.path
import java.io.File;

import androidx.core.content.FileProvider
import android.content.Intent
import android.icu.lang.UCharacter.GraphemeClusterBreak.T
import android.net.Uri
import android.icu.lang.UCharacter.GraphemeClusterBreak.T

import android.graphics.BitmapFactory
import android.os.Environment
import java.io.FileOutputStream
import android.graphics.Bitmap
import android.os.Build
import android.content.pm.PackageManager

class MainActivity: FlutterActivity() {
  //
  private val CHANNEL = "flutter.native/share"
  
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)

    //
    MethodChannel(flutterView, CHANNEL).setMethodCallHandler { call, result ->
      if(call.method == "shareImage") {
        shareImage(call.argument<String>("path")!!, call.argument<String>("message")!!)
      }
    }
  }

  //
  private fun shareImage(path :String, message :String) {
    val imageFile = File(applicationContext.cacheDir, path)
    val contentUri = FileProvider.getUriForFile(this, "com.firefliesdev.mypresence", imageFile)
    val intent = Intent(Intent.ACTION_SEND)

    intent.type = "image/*"
    intent.putExtra(Intent.EXTRA_STREAM, contentUri)
    intent.putExtra(Intent.EXTRA_TEXT, message)
    startActivity(Intent.createChooser(intent, "Share QR Code"))
  }
}
