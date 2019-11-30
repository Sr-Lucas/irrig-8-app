package br.com.lucastsantos.irrig_8_app;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothSocket;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.view.View;
import java.io.InputStream;
import java.io.OutputStream;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import java.nio.ByteBuffer;
import java.util.UUID;

import app.akexorcist.bluetotohspp.library.BluetoothSPP;
import app.akexorcist.bluetotohspp.library.BluetoothState;
import app.akexorcist.bluetotohspp.library.DeviceList;
import io.flutter.Log;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

  private static final String CHANNEL = "blue_channel";

  BluetoothSPP bluetooth;

  @SuppressLint("HandlerLeak")
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

    GeneratedPluginRegistrant.registerWith(this);

    MethodChannel channel = new MethodChannel(getFlutterView(), CHANNEL);


    bluetooth = new BluetoothSPP(this);

    if (!bluetooth.isBluetoothAvailable()) {
      Toast.makeText(getApplicationContext(), "Bluetooth is not available", Toast.LENGTH_SHORT).show();
      finish();
    }

    bluetooth.setBluetoothConnectionListener(new BluetoothSPP.BluetoothConnectionListener() {
      public void onDeviceConnected(String name, String address) {
        Toast.makeText(getApplicationContext(), "CONNECTED", Toast.LENGTH_SHORT).show();
        bluetooth.setOnDataReceivedListener(new BluetoothSPP.OnDataReceivedListener() {
          @Override
          public void onDataReceived(byte[] data, String message) {
            Toast.makeText(getApplicationContext(), "DATA", Toast.LENGTH_SHORT).show();
          }
        });
      }

      public void onDeviceDisconnected() {
        Toast.makeText(getApplicationContext(), "DISCONNECTED", Toast.LENGTH_SHORT).show();
      }

      public void onDeviceConnectionFailed() {
        Toast.makeText(getApplicationContext(), "FAILED", Toast.LENGTH_SHORT).show();
      }
    });


    channel.setMethodCallHandler(
            (call, result) -> {
              switch (call.method) {
                case "connect":
                  onClickBtnConnect();
                  break;
                case "setTimer":
                  onClickSendTime(call.argument("time"));
                  break;
                case "turnOn":
                  onClickSendTurnOn();
                  break;
                case "turnOff":
                  onClickSendTurnOff();
                  break;
                case "turnOnAutomatic":
                  onClickSendPercent(call.argument("percent"));
                  break;
                case "turnOffAutomatic":
                  onClickSendTurnOff();
                  break;
                case "info_bluth":
                  setBluetoothListeners();
                  break;
              }
            }
    );
  }

  public void onStart() {
    super.onStart();
    if (!bluetooth.isBluetoothEnabled()) {
      bluetooth.enable();
    } else {
      if (!bluetooth.isServiceAvailable()) {
        bluetooth.setupService();
        bluetooth.startService(BluetoothState.DEVICE_OTHER);
      }
    }
  }

  public void onDestroy() {
    super.onDestroy();
    bluetooth.stopService();
  }

  public void onActivityResult(int requestCode, int resultCode, Intent data) {
    if (requestCode == BluetoothState.REQUEST_CONNECT_DEVICE) {
      if (resultCode == Activity.RESULT_OK)
        bluetooth.connect(data);
    } else if (requestCode == BluetoothState.REQUEST_ENABLE_BT) {
      if (resultCode == Activity.RESULT_OK) {
        bluetooth.setupService();
      } else {
        Toast.makeText(getApplicationContext()
                , "Bluetooth was not enabled."
                , Toast.LENGTH_SHORT).show();
        finish();
      }
    }
  }

  public void onClickBtnConnect() {
    if (bluetooth.getServiceState() == BluetoothState.STATE_CONNECTED) {
      bluetooth.disconnect();
    } else {
      Intent intent = new Intent(getApplicationContext(), DeviceList.class);
      startActivityForResult(intent, BluetoothState.REQUEST_CONNECT_DEVICE);
    }
  }

  public void onClickSendTurnOn() {
      bluetooth.send("start", true);
  }

  public void onClickSendTurnOff() {
      bluetooth.send("stop", true);
  }

  public  void onClickSendTime(String time) {
    bluetooth.send("1;" + time, true);
  }

  public  void onClickSendPercent(String percent) {
    bluetooth.send("2;" + percent, true);
  }

  private void setBluetoothListeners() {
    bluetooth.setOnDataReceivedListener(new BluetoothSPP.OnDataReceivedListener() {
      @Override
      public void onDataReceived(byte[] data, String msg) {
          Toast.makeText(getApplicationContext(), "FAILED", Toast.LENGTH_SHORT).show();
      }
    });
  }

}
