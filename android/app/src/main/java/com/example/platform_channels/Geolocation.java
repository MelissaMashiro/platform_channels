package com.example.platform_channels;

import android.Manifest;
import android.annotation.SuppressLint;
import android.annotation.TargetApi;
import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageManager;
import android.location.Location;
import android.os.Build;
import android.os.Looper;

import androidx.annotation.NonNull;
import androidx.core.content.ContextCompat;

import com.google.android.gms.location.FusedLocationProviderClient;
import com.google.android.gms.location.Granularity;
import com.google.android.gms.location.LocationCallback;
import com.google.android.gms.location.LocationRequest;
import com.google.android.gms.location.LocationResult;
import com.google.android.gms.location.LocationServices;
import com.google.android.gms.location.Priority;

import java.util.HashMap;

import io.flutter.Log;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.plugins.shim.ShimPluginRegistry;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.PluginRegistry;

public class Geolocation implements MethodCallHandler ,EventChannel.StreamHandler{

    private Activity activity;
    private MethodChannel.Result flutterResult;
    final int REQUEST_CODE = 1204;
    //se encesita agregar dependencia de 'com.google.android.gms:play-services-location:21.0.1' para que funcione la siguiente variable
    private FusedLocationProviderClient fusedLocationClient;
    private EventChannel.EventSink events;

    Geolocation(Activity activity , FlutterEngine flutterEngine){
        this.activity = activity;//constext traidod esde el MainActivity
        fusedLocationClient = LocationServices.getFusedLocationProviderClient(this.activity);

        BinaryMessenger messenger = flutterEngine.getDartExecutor().getBinaryMessenger();

        MethodChannel channel = new MethodChannel(messenger,"app.meli/geolocation");

        EventChannel eventChannel = new EventChannel(messenger,"app.meli/geolocation-listener");
       //para esto, agrego el siguiente implement EventChannel.StreamHandler
        eventChannel.setStreamHandler(this);

        channel.setMethodCallHandler(this);       //el this, llama al method onMethodCall

        //Esta era forma antigua, sin usar el implements del methodcallhandler
        /*
        channel.setMethodCallHandler(new MethodCallHandler(){
            @Override
            public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
            }
         });
         */

        ShimPluginRegistry registry = new ShimPluginRegistry(flutterEngine);
       PluginRegistry.Registrar registar = registry.registrarFor("app.meli/geolocation");

       registar.addRequestPermissionsResultListener((requestCode, permissions, grantResults) -> {
          //
           if(requestCode ==  REQUEST_CODE){

               //si tenemos por lo menos un permiso otrogado
               if(grantResults.length>0 && grantResults[0] == PackageManager.PERMISSION_GRANTED){
                   Log.i("meliapp","PERMISSIONS GRANTED GOOD");
                    this.flutterResult.success("granted");
               }else{
                   Log.i("meliapp","PERMISSIONS NO GRANTED BAD");

                   this.flutterResult.success("denied");
               }
               this.flutterResult = null;
           }
           return false;
       });
    }

     private LocationCallback locationCallback = new LocationCallback() {

         @Override
         public void onLocationResult(@NonNull LocationResult locationResult) {
             super.onLocationResult(locationResult);
             if(locationResult!=null){//si tengo una nueva ubicacion del dispositivo
                 Location location = locationResult.getLastLocation();
                Log.i("location",location.getLatitude()+""+location.getLongitude());
                if(events!=null){
                    HashMap<String,Double> data = new HashMap<String, Double>();
                    data.put("lat",location.getLatitude());
                    data.put("lng",location.getLongitude());

                    events.success(data);
                }
             }
         }
     };




    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {

        switch (call.method){
            case "check":
                _check(result);
                break;
            case "request":
                _request(result);
                break;
            case  "start":
                this.start();
                result.success(null);
                break;
            case  "stop":
                this.stop();
                result.success(null);
                break;
            default:
                result.notImplemented();
        }
    }

    private void _check(MethodChannel.Result result){
       int status = ContextCompat.checkSelfPermission(this.activity, Manifest.permission.ACCESS_FINE_LOCATION);
       if(status == PackageManager.PERMISSION_GRANTED){
        result.success("granted");
       }else{
           result.success("denied");

       }
    }

    private void _request(MethodChannel.Result result){
        if(flutterResult!=null){
            result.error("PENDING TASK","You have a pending task",null);
            return;
        }else{
            this.flutterResult = result;
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                this.activity.requestPermissions(new String[]{
                        Manifest.permission.ACCESS_FINE_LOCATION
                },REQUEST_CODE);
            }else{//ya tenemos acceso a la ubicacion del dispositivo en esta version
                this.flutterResult.success("granted");
                this.flutterResult = null;

            }
        }
    }


     @SuppressLint("MissingPermission")
     private void start() {
        //start listening changes on mobile location system

         LocationRequest   locationRequest = new LocationRequest.Builder(100)
                 .setIntervalMillis(10000)             // Sets the interval for location updates
                 .setMinUpdateIntervalMillis(10000/2)  // Sets the fastest allowed interval of location updates.
                // .setWaitForAccurateLocation(false)              // Want Accurate location updates make it true or you get approximate updates
                 .setMaxUpdateDelayMillis(100)                   // Sets the longest a location update may be delayed.
                 .build();

//si no funciona, cambiar el import usado
          fusedLocationClient.requestLocationUpdates(locationRequest,
                 locationCallback,
                 Looper.getMainLooper());
    }
    public void stop(){
        //stop listening changes on mobile location system
        fusedLocationClient.removeLocationUpdates(locationCallback);

        //nota:
        //tambien se llama este metodo desde el metodo onDestroy en el MainActivity para asetgurar que no quede abierto
    }

    @Override
    public void onListen(Object arguments, EventChannel.EventSink events) {
        this.events = events;
    }

    @Override
    public void onCancel(Object arguments) {

    }
}
