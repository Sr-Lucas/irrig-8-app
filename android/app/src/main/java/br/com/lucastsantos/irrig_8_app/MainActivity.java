package br.com.lucastsantos.irrig_8_app;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothSocket;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.widget.Toast;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.UUID;

import app.akexorcist.bluetotohspp.library.BluetoothSPP;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

  private static final String CHANNEL = "blue_channel";

  private static final int ATIVA_BLUETOOTH = 1;
  private static final int SOLICITA_CONEXAO = 2;
  private static final int MESSAGE_READ = 3;

  private static  String MAC = null;

  Handler mHandler;
  StringBuilder dadosBluetooth = new StringBuilder();

  ConnectThread connectThread;

  UUID ID = UUID.fromString("00001101-0000-1000-8000-00805f9b34fb");

  BluetoothSPP bluetooth;
  BluetoothAdapter bluetoothAdapter;
  BluetoothDevice device = null;
  BluetoothSocket socket = null;

  boolean conexao = false;

  @SuppressLint("HandlerLeak")
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

    GeneratedPluginRegistrant.registerWith(this);

    MethodChannel channel = new MethodChannel(getFlutterView(), CHANNEL);

    bluetoothAdapter = BluetoothAdapter.getDefaultAdapter();

    if(bluetoothAdapter == null) {
      Toast.makeText(getApplicationContext(), "Seu dispositivo não possui bluetooth", Toast.LENGTH_LONG).show();
    } else if(!bluetoothAdapter.isEnabled()) {
      Intent enableBluetook = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
      startActivityForResult(enableBluetook, ATIVA_BLUETOOTH);
    }



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
                  //onClickSendTurnOff();
                  break;
                case "info_bluth":
                  result.success(dadosBluetooth.substring(1, 10));
                  break;
              }
            }
    );

    mHandler = new Handler() {
      @Override
      public void handleMessage(Message msg) {

        if(msg.what == MESSAGE_READ) {
          String received = (String) msg.obj;
          dadosBluetooth.append(received);

          int endInfo = dadosBluetooth.indexOf("#");

          if(endInfo > 0) {

            String completedData = dadosBluetooth.substring(0,endInfo);

            int sizeIndo = completedData.length();

            if(dadosBluetooth.charAt(0) == '$') {
              String finalData = dadosBluetooth.substring(1,sizeIndo);
            }

            //dadosBluetooth.delete(0,dadosBluetooth.length());
          }

        }

      }
    };

  }

  private void onClickSendPercent(String percent) {
    if(conexao) {
      connectThread.write("2;" + percent);
    } else {
      Toast.makeText(getApplicationContext(), "BLUETOOTH NAO CONECTADO", Toast.LENGTH_LONG).show();
    }
  }

  private void onClickSendTurnOff() {

    if(conexao) {
      connectThread.write("stop");
    } else {
      Toast.makeText(getApplicationContext(), "BLUETOOTH NAO CONECTADO", Toast.LENGTH_LONG).show();
    }

  }

  private void onClickSendTurnOn() {

    if(conexao) {
      connectThread.write("start");
    } else {
      Toast.makeText(getApplicationContext(), "BLUETOOTH NAO CONECTADO", Toast.LENGTH_LONG).show();
    }

  }


  private void onClickSendTime(String time) {

    if(conexao) {
      connectThread.write("1;" + time);
    } else {
      Toast.makeText(getApplicationContext(), "BLUETOOTH NAO CONECTADO", Toast.LENGTH_LONG).show();
    }

  }

  private void onClickBtnConnect() {

    if(conexao) {
      //desconectar
      try {
        socket.close();
        conexao = false;
        Toast.makeText(getApplicationContext(), "BLUETOOTH FOI DESCONECTADO", Toast.LENGTH_LONG).show();
      } catch (IOException ex) {
        Toast.makeText(getApplicationContext(), "ERRO", Toast.LENGTH_LONG).show();
      }
    } else {
      //conectar
      Intent openList = new Intent(MainActivity.this, ListaDispositivos.class);
      startActivityForResult(openList, SOLICITA_CONEXAO);
    }

  }

  @Override
  protected void onActivityResult(int requestCode, int resultCode, Intent data) {
    //super.onActivityResult(requestCode, resultCode, data);
    switch (requestCode) {
      case ATIVA_BLUETOOTH:
        if(resultCode == Activity.RESULT_OK) {
          Toast.makeText(getApplicationContext(), "O bluetooth foi ativado!", Toast.LENGTH_LONG).show();
        } else {
          Toast.makeText(getApplicationContext(), "Não foi possível ativar o bluetooth!", Toast.LENGTH_LONG).show();
          finish();
        }
        break;
      case SOLICITA_CONEXAO:
        if(resultCode == Activity.RESULT_OK) {
          MAC = data.getExtras().getString(ListaDispositivos.ENDERECO_MAC);

          device = bluetoothAdapter.getRemoteDevice(MAC);

          try {
            socket = device.createRfcommSocketToServiceRecord(ID);
            socket.connect();

            conexao = true;

            connectThread = new ConnectThread(socket);

            Toast.makeText(getApplicationContext(), "BLUETOOTH CONECTADO", Toast.LENGTH_LONG).show();

          } catch (IOException ex) {
            conexao = false;
            Toast.makeText(getApplicationContext(), "ERRO DURANTE A CONEXÃO COM BLUETOOTH", Toast.LENGTH_LONG).show();
          }
        } else {
          Toast.makeText(getApplicationContext(), "Falha ao obter o MAC", Toast.LENGTH_LONG).show();
        }
        break;
    }
  }

  private class ConnectThread extends Thread {
    private  final InputStream inputStream;
    private  final OutputStream outputStream;

    public ConnectThread(BluetoothSocket socket) {
      OutputStream outputStream1;
      InputStream inputStream1;

      inputStream1 = null;
      outputStream1 = null;

      InputStream tmpIn = null;
      OutputStream tmpOut = null;

      // Use a temporary object that is later assigned to mmSocket
      // because mmSocket is final.
      BluetoothSocket tmp = null;

      try {
        tmpIn = socket.getInputStream();
        tmpOut = socket.getOutputStream();
      } catch (IOException e) {
        Log.e("conexao", "Socket's create() method failed", e);
      }

      inputStream1 = tmpIn;
      outputStream1 = tmpOut;

      this.inputStream = inputStream1;
      this.outputStream = outputStream1;
    }

    public void run() {
      byte[] buffer = new byte[1024];
      int bytes;

      while (true) {
        try {
          bytes = inputStream.read(buffer);

          String data = new String(buffer,0,bytes);

          mHandler.obtainMessage(MESSAGE_READ, bytes, -1, data).sendToTarget();
        } catch (IOException ex) {
          break;
        }
      }

    }

    public void write(String output) {
      byte[] buffer = output.getBytes();
      try {
        outputStream.write(buffer);
      } catch (IOException ex) {
        Toast.makeText(getApplicationContext(), "ERRO AO ENVIAR COMANDO", Toast.LENGTH_LONG).show();
      }
    }

  }


}
