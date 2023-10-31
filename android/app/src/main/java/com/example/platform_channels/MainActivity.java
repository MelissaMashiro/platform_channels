package com.example.platform_channels;

import android.os.Build;

import androidx.annotation.NonNull;

import javax.xml.transform.Result;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        //para obtener el binary messanger:
      BinaryMessenger messenger = flutterEngine.getDartExecutor().getBinaryMessenger();
        //para invocar el methodchannel
        MethodChannel methodChannel = new MethodChannel(messenger,"app.meli/my_platform_channel"); //<-- mismonombre del paltform channel del flutter client
        //ahora solo escuchar el mesanej de tipo version que enviamos desde el cliente
        methodChannel.setMethodCallHandler((MethodCall call,MethodChannel.Result result) -> { //codigo siplificado por un lambda, originamente era Methodchannel.MethodCallHandler()...
            //para escuchar los mensajes de la key/string especifica enviados(invicados)
            if(call.method.equals("version")){
          String androidVersion =   getAndroidVersion();
          result.success(androidVersion);//respuesta a enviar al flutter client
            }else{
                result.notImplemented(); //mensaje error
            }
        });
    }

    String getAndroidVersion(){
      int sdkVersion =  Build.VERSION.SDK_INT;
     String release=  Build.VERSION.RELEASE;

     return "Android version "+sdkVersion+"("+release+")";//Android version: 21 (6.1)
    }
}
