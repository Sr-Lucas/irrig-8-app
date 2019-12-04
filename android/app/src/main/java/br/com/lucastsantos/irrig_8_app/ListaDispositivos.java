package br.com.lucastsantos.irrig_8_app;

import android.app.ListActivity;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import java.util.Set;

public class ListaDispositivos extends ListActivity {

    private BluetoothAdapter bluetoothAdapter = null;

    static String ENDERECO_MAC = null;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        ArrayAdapter<String> arrayBluetooth = new ArrayAdapter<String>(this, android.R.layout.simple_list_item_1);

        bluetoothAdapter = BluetoothAdapter.getDefaultAdapter();

        Set<BluetoothDevice> dispositivosPareados = bluetoothAdapter.getBondedDevices();

        if(dispositivosPareados.size() > 0) {
            for(BluetoothDevice dispositivo : dispositivosPareados) {
                String nomeBt = dispositivo.getName();
                String macBt = dispositivo.getAddress();
                arrayBluetooth.add(nomeBt + '\n' + macBt);
            }
        }

        setListAdapter(arrayBluetooth);
    }

    @Override
    protected void onListItemClick(ListView l, View v, int position, long id) {
        super.onListItemClick(l, v, position, id);

        String generalInfo = ((TextView) v).getText().toString();

        String macAddress = generalInfo.substring(generalInfo.length() - 17);

        Intent returnMac = new Intent();
        returnMac.putExtra(ENDERECO_MAC, macAddress);
        setResult(RESULT_OK, returnMac);

        finish();
    }
}
